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
import UIKit

extension String {
    static let spawnedItemName = "spawnedItem"
}

protocol CustomARViewDelegate {
    func didFind(verticalPlane: Bool)
}

class CustomARView: ARView {
    
    var itemManager: ItemManager = ItemManager.shared

    // MARK: - Properties

    var focusEntity: FocusEntity?
    var delegate: CustomARViewDelegate?
    
    var collisionSubscription: Cancellable?
    private var cancellables: Set<AnyCancellable> = []
    var cancellable: AnyCancellable?

    // List of item assets
    let itemAssets = ["Eight_Ball.usdz", "Golf_Ball.usdz", "Soccer_Ball.usdz", "Basketball_Ball.usdz", "Crumpled_paper.usdz"]

    // MARK: - Lifecycle

    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        setupFocusEntity()
        setupARView()
        
        spawnItems()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}

// MARK: - Extension

private extension CustomARView {
    
    func setupFocusEntity() {
        focusEntity = FocusEntity(on: self, style: .classic(color: .clear))
        focusEntity?.setAutoUpdate(to: true)
        focusEntity?.delegate = self
    }
    
    func setupARView() {
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
    
    func spawnItems() {
        let shuffledAssets = itemAssets.shuffled()
        for asset in shuffledAssets {
            let randomPosition = SIMD3<Float>(
                Float.random(in: -1...1),
                Float.random(in: -1...1),
                Float.random(in: -1...1)
            )
            spawnItem(named: asset, at: randomPosition)
        }
    }
    
    func spawnItem(named assetName: String, at position: SIMD3<Float>) {
        guard let modelEntity = try? ModelEntity.loadModel(named: assetName) else {
            return print("Failed to load 3D model \(assetName)")
        }
        
        modelEntity.name = .spawnedItemName
        modelEntity.transform.translation = position
        modelEntity.scale = SIMD3<Float>(repeating: 0.001) // Change scale as needed
        
        let anchorEntity = AnchorEntity(world: position)
        anchorEntity.addChild(modelEntity)
        scene.addAnchor(anchorEntity)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: self)
        guard let entity = self.entity(at: tapLocation) else { return }
        
        if entity.name == .spawnedItemName {
            showItemFoundProgress()
        }
    }
    
    func showItemFoundProgress() {
        let alert = UIAlertController(title: "Item Found", message: "You found an item!", preferredStyle: .alert)
        self.window?.rootViewController?.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true)
        }
    }
}

extension CustomARView: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let _ = scene.findEntity(named: "hoop") {
            ItemManager.shared.isHoopEntityPlaced = true
        }
    }
}

extension CustomARView: FocusEntityDelegate {
    func focusEntity(_ focusEntity: FocusEntity, trackingUpdated trackingState: FocusEntity.State, oldState: FocusEntity.State?) {
        delegate?.didFind(verticalPlane: focusEntity.onPlane)
    }
}
