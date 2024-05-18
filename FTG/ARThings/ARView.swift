//
//  ARView.swift
//  FTG
//
//  Created by Vincent Saranang on 16/05/24.
//

import ARKit
import FocusEntity
import RealityKit
import Combine
import SwiftUI
import UIKit
import AVFoundation

protocol CustomARViewDelegate {
    func didFind(verticalPlane: Bool)
}

class CustomARView: ARView, ObservableObject {
    @Published var sfxVolume: Float = 1.0
    
    var itemManager: ItemManager = ItemManager.shared
    var inventory = Inventory()
    
    var focusEntity: FocusEntity?
    var delegate: CustomARViewDelegate?
    
    var collisionSubscription: Cancellable?
    private var cancellables: Set<AnyCancellable> = []
    var cancellable: AnyCancellable?
    
    var collectedItems: Set<Entity> = []
    
    let itemAssets = ["Eight_Ball.usdz", "Golf_Ball.usdz", "Soccer_Ball.usdz", "Basketball_Ball.usdz", "Crumpled_paper.usdz"]
    
    let itemScales: [SIMD3<Float>] = [
        SIMD3<Float>(repeating: 0.0005),
        SIMD3<Float>(repeating: 0.00012),
        SIMD3<Float>(repeating: 0.0012),
        SIMD3<Float>(repeating: 0.015),
        SIMD3<Float>(repeating: 0.0008)
    ]
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        setupFocusEntity()
        setupARView()
        
        spawnItems()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        
        // Play background music
//        AudioManager.shared.playBGM(filename: "bgm", fileType: "mp3")
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    private func setupFocusEntity() {
        focusEntity = FocusEntity(on: self, style: .classic(color: .clear))
        focusEntity?.setAutoUpdate(to: true)
        focusEntity?.delegate = self
    }
    
    private func setupARView() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.environmentTexturing = .automatic
        config.frameSemantics = [.personSegmentation, .personSegmentationWithDepth]
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        session.delegate = self
        self.session.run(config)
    }
    
    private func spawnItems() {
        spawnItems(withScales: itemScales)
    }
    
    private func spawnItems(withScales scales: [SIMD3<Float>]) {
        guard itemAssets.count == scales.count else {
            print("Number of scales provided does not match number of item assets.")
            return
        }
        
        for (index, asset) in itemAssets.enumerated() {
            let randomPosition = SIMD3<Float>(
                Float.random(in: -1...1),
                Float.random(in: 0...1),
                Float.random(in: 0...1)
            )
            let scale = scales[index]
            let itemName = asset.replacingOccurrences(of: ".usdz", with: "")
            spawnItem(named: asset, withName: itemName, at: randomPosition, scale: scale)
        }
    }
    
    private func spawnItem(named assetName: String, withName name: String, at position: SIMD3<Float>, scale: SIMD3<Float>) {
        guard let modelEntity = try? ModelEntity.loadModel(named: assetName) else {
            return print("Failed to load 3D model \(assetName)")
        }
        modelEntity.generateCollisionShapes(recursive: true)
        
        modelEntity.name = name
        modelEntity.transform.translation = position
        modelEntity.scale = scale
        
        let anchorEntity = AnchorEntity(world: position)
        anchorEntity.addChild(modelEntity)
        scene.addAnchor(anchorEntity)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: self)
        guard let entity = self.entity(at: tapLocation) else { return }
        
        if entity.name != "" && !collectedItems.contains(entity) {
            collectItem(entity)
            removeItemFromScene(entity)
        }
    }
    
    private func collectItem(_ item: Entity) {
        collectedItems.insert(item)
        let itemName = item.name
        let itemURL = URL(string: "path/to/\(itemName).usdz")!
        
        generateThumbnail(for: itemName) { [weak self] image in
            guard let self = self else { return }
            let inventoryItem = InventoryItem(name: itemName, modelURL: itemURL, thumbnail: image)
            self.inventory.addItem(inventoryItem)
            
            // Play item collection sound effect
            AudioManager.shared.playSFX(filename: "ItemCollect", volume: sfxVolume)
            
            self.showItemFoundProgress(itemName: itemName)
        }
    }
    
    private func removeItemFromScene(_ item: Entity) {
        if let anchorEntity = item.anchor {
            scene.removeAnchor(anchorEntity)
        }
    }
    
    private func showItemFoundProgress(itemName: String) {
        let alert = UIAlertController(title: "Item Found", message: "You found: \(itemName)", preferredStyle: .alert)
        self.window?.rootViewController?.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true)
        }
    }
    
    func generateThumbnail(for modelName: String, completion: @escaping (UIImage?) -> Void) {
        guard let modelEntity = try? ModelEntity.loadModel(named: modelName) else {
            return completion(nil)
        }
        
        let thumbnailSize: CGFloat = 160
        let thumbnailView = ARView(frame: CGRect(x: 0, y: 0, width: thumbnailSize, height: thumbnailSize))
        
        let anchor = AnchorEntity()
        anchor.addChild(modelEntity)
        thumbnailView.scene.addAnchor(anchor)
        
        thumbnailView.snapshot(saveToHDR: false) { image in
            completion(image)
        }
    }
}

extension CustomARView: FocusEntityDelegate {
    func toTrackingState() { }
    
    func toInitializingState() { }
}

extension CustomARView: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if frame.worldMappingStatus == .mapped {
        }
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                if planeAnchor.alignment == .vertical {
                    delegate?.didFind(verticalPlane: true)
                }
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                if planeAnchor.alignment == .vertical {
                    delegate?.didFind(verticalPlane: true)
                }
            }
        }
    }
}
