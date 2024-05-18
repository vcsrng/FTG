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

protocol CustomARViewDelegate {
    func didFind(verticalPlane: Bool)
}

class CustomARView: ARView, ObservableObject {

    var itemManager: ItemManager = ItemManager.shared
    var inventory = Inventory()
    // MARK: - Properties

    var focusEntity: FocusEntity?
    var delegate: CustomARViewDelegate?

    var collisionSubscription: Cancellable?
    private var cancellables: Set<AnyCancellable> = []
    var cancellable: AnyCancellable?

    var collectedItems: Set<Entity> = []

    // List of item assets
    let itemAssets = ["Eight_Ball.usdz", "Golf_Ball.usdz", "Soccer_Ball.usdz", "Basketball_Ball.usdz", "Crumpled_paper.usdz"]

    // Scales for each item asset
    let itemScales: [SIMD3<Float>] = [
        SIMD3<Float>(repeating: 0.0005), // Scale for Eight_Ball.usdz
        SIMD3<Float>(repeating: 0.00012), // Scale for Golf_Ball.usdz
        SIMD3<Float>(repeating: 0.0012), // Scale for Soccer_Ball.usdz
        SIMD3<Float>(repeating: 0.015), // Scale for Basketball_Ball.usdz
        SIMD3<Float>(repeating: 0.0008) // Scale for Crumpled_paper.usdz
    ]

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
        spawnItems(withScales: itemScales)
    }

    func spawnItems(withScales scales: [SIMD3<Float>]) {
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
            let itemName = asset.replacingOccurrences(of: ".usdz", with: "") // Remove the file extension for naming
            spawnItem(named: asset, withName: itemName, at: randomPosition, scale: scale)
        }
    }

    func spawnItem(named assetName: String, withName name: String, at position: SIMD3<Float>, scale: SIMD3<Float>) {
        guard let modelEntity = try? ModelEntity.loadModel(named: assetName) else {
            return print("Failed to load 3D model \(assetName)")
        }
        modelEntity.generateCollisionShapes(recursive: true)

        modelEntity.name = name // Set the name of the modelEntity
        modelEntity.transform.translation = position
        modelEntity.scale = scale

        let anchorEntity = AnchorEntity(world: position)
        anchorEntity.addChild(modelEntity)
        scene.addAnchor(anchorEntity)
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: self)
        guard let entity = self.entity(at: tapLocation) else { return }

        if entity.name != "" && !collectedItems.contains(entity) {
            collectItem(entity)
            removeItemFromScene(entity)
        }
    }

    func collectItem(_ item: Entity) {
        collectedItems.insert(item)

        // Create InventoryItem instance and add it to inventory
        let itemName = item.name
        let itemURL = URL(string: "path/to/\(itemName).usdz")! // Adjust this according to how you manage model URLs
        let inventoryItem = InventoryItem(name: itemName, modelURL: itemURL)
        inventory.addItem(inventoryItem)

        // Optionally show a message to the user
        showItemFoundProgress()
    }

    func removeItemFromScene(_ item: Entity) {
        if let anchorEntity = item.anchor {
            scene.removeAnchor(anchorEntity)
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

extension CustomARView: ARSessionDelegate {}

extension CustomARView: FocusEntityDelegate {
    func focusEntity(_ focusEntity: FocusEntity, trackingUpdated trackingState: FocusEntity.State, oldState: FocusEntity.State?) {
        delegate?.didFind(verticalPlane: focusEntity.onPlane)
    }
}
