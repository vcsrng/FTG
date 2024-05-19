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
    @Published var isGuessCorrect: Bool = false
    @Published var correctAnswer: String = "Correct Answer"
    
    func showGameEnd(correct: Bool) {
        // Implement your logic to show the game end view
        print(correct ? "Correct Guess" : "Incorrect Guess")
        // You may need to update some @Published properties to trigger UI updates
        NotificationCenter.default.post(name: .gameEnded, object: nil, userInfo: ["correct": correct])
    }
    
    var itemManager: ItemManager = ItemManager.shared
    var inventory = Inventory()
    
    var focusEntity: FocusEntity?
    var delegate: CustomARViewDelegate?
    
    var collisionSubscription: Cancellable?
    private var cancellables: Set<AnyCancellable> = []
    var cancellable: AnyCancellable?
    
    var collectedItems: Set<Entity> = []
    
    var itemAssets: [String] = []
    var itemScales: [SIMD3<Float>] = []
    var itemDescriptions: [String] = []
    var answerKey: String = ""

    var answerList: [String: [String]] = [:]  // Answer list with corresponding evidence
    var collectedEvidence: Set<String> = []   // Collected evidence
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        setupFocusEntity()
        setupARView()
        
        let configuration = selectConfiguration(caseNumber: Int.random(in: 1...2))
        applyConfiguration(configuration)
        
        answerList = generateAnswerList() // Generate the answer list
        
        spawnItems()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func resetGame() {
        // Clear inventory
        inventory.items.removeAll()
        
        // Reset collected items
        collectedItems.removeAll()
        
        // Reset any other necessary game state
        answerList = [:]
        correctAnswer = "" // Set to the correct default or new game value
        // Add additional reset logic as needed
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
    
    private func selectConfiguration(caseNumber: Int) -> ItemConfiguration {
        switch caseNumber {
        case 1:
            return ItemConfiguration(
                itemAssets: ["Eight_Ball.usdz", "Golf_Ball.usdz", "Soccer_Ball.usdz", "Basketball_Ball.usdz", "Crumpled_paper.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.00012),
                    SIMD3<Float>(repeating: 0.0012),
                    SIMD3<Float>(repeating: 0.015),
                    SIMD3<Float>(repeating: 0.0008)
                ],
                itemDescriptions: [
                    "An eight ball",
                    "A golf ball",
                    "A soccer ball",
                    "A basketball",
                    "Crumpled paper"
                ],
                answerKey: "Coach"
            )
        case 2:
            return ItemConfiguration(
                itemAssets: ["Nine_Ball.usdz", "Bowling_Ball.usdz", "Rugby_Ball.usdz", "Basketball_Ball.usdz", "Crumpled_paper.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.001),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.015),
                    SIMD3<Float>(repeating: 0.0008)
                ],
                itemDescriptions: [
                    "A nine ball",
                    "A bowling ball",
                    "A rugby ball",
                    "A basketball",
                    "Crumpled paper"
                ],
                answerKey: "Coach 2"
            )
        default:
            fatalError("Unknown case number")
        }
    }
    
    func generateAnswerList() -> [String: [String]] {
        // Generate a dummy answer list from ItemConfiguration or any other source
        return [
            "Answer 1": ["Evidence 1", "Evidence 2"],
            "Answer 2": ["Evidence 2", "Evidence 3"],
            "Answer 3": ["Evidence 1", "Evidence 3"],
            "Answer 4": ["Evidence 1", "Evidence 2", "Evidence 3"]
        ]
    }
    
    private func applyConfiguration(_ configuration: ItemConfiguration) {
        itemAssets = configuration.itemAssets
        itemScales = configuration.itemScales
        itemDescriptions = configuration.itemDescriptions
        answerKey = configuration.answerKey
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
            AudioManager.shared.playSFX(filename: "ItemCollect", volume: self.sfxVolume)
            
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

extension Notification.Name {
    static let gameEnded = Notification.Name("gameEnded")
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
                let isVertical = planeAnchor.alignment == .vertical
                self.delegate?.didFind(verticalPlane: isVertical)
            }
        }
    }
}
