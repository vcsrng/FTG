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
import AVFoundation

protocol CustomARViewDelegate {
    func didFind(verticalPlane: Bool)
}

class CustomARView: ARView, ObservableObject {
    @Published var sfxVolume: Float = 1.0
    @Published var isGuessCorrect: Bool = false
    @Published var correctAnswer: String = "Correct Answer"

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

        let configuration = selectConfiguration(caseNumber: Int.random(in: 1...3))
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
        // Stop the current AR session
        self.session.pause()

        // Clear the current AR scene
        self.scene.anchors.removeAll()

        // Clear inventory
        inventory.items.removeAll()

        // Reset collected items
        collectedItems.removeAll()
        collectedEvidence.removeAll()

        // Reset answer list and correct answer
        answerList = generateAnswerList()

        // Reapply configuration
        let configuration = selectConfiguration(caseNumber: Int.random(in: 1...3))
        applyConfiguration(configuration)

        // Start a new AR session
        setupARView()

        // Respawn items
        spawnItems()

        // Ensure UI updates
        NotificationCenter.default.post(name: .gameEnded, object: nil)
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
        self.session.run(config, options: [.resetTracking, .removeExistingAnchors])
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
                    "An eight ball with black and white colors.",
                    "A small golf ball, typically white with dimples.",
                    "A classic soccer ball with black and white patches.",
                    "A standard basketball with orange color.",
                    "A piece of crumpled paper."
                ],
                answerKey: "Answer 1"
            )
        case 2:
            return ItemConfiguration(
                itemAssets: ["Toothpaste.usdz", "Sandwich.usdz", "Sundae.usdz", "Cookies.usdz", "Coffee_Cup.usdz", "Crumpled_paper.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.0008)
                ],
                itemDescriptions: [
                    "A tube of toothpaste, often used for dental care.",
                    "A sandwich with layers of ingredients between bread slices.",
                    "A delicious sundae with ice cream and toppings.",
                    "A plate of cookies, freshly baked and ready to eat.",
                    "A cup of coffee, often enjoyed hot.",
                    "A piece of crumpled paper."
                ],
                answerKey: "Answer 2"
            )
        case 3:
            return ItemConfiguration(
                itemAssets: ["Eight_Ball.usdz", "Sandwich.usdz", "Soccer_Ball.usdz", "Basketball_Ball.usdz", "Coffee_Cup.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.0012),
                    SIMD3<Float>(repeating: 0.015),
                    SIMD3<Float>(repeating: 0.01)
                ],
                itemDescriptions: [
                    "An eight ball with black and white colors.",
                    "A sandwich with layers of ingredients between bread slices.",
                    "A classic soccer ball with black and white patches.",
                    "A standard basketball with orange color.",
                    "A cup of coffee, often enjoyed hot."
                ],
                answerKey: "Answer 3"
            )
        default:
            fatalError("Invalid case number")
        }
    }

    func generateAnswerList() -> [String: [String]] {
        // Generate a dummy answer list from ItemConfiguration or any other source
        return [
            "Answer 1": ["Eight_Ball.usdz", "Golf_Ball.usdz", "Soccer_Ball.usdz", "Basketball_Ball.usdz", "Crumpled_paper.usdz"],
            "Answer 2": ["Toothpaste.usdz", "Sandwich.usdz", "Sundae.usdz", "Cookies.usdz", "Coffee_Cup.usdz", "Crumpled_paper.usdz"],
            "Answer 3": ["Eight_Ball.usdz", "Sandwich.usdz", "Soccer_Ball.usdz", "Basketball_Ball.usdz", "Coffee_Cup.usdz"],
            "Answer 4": ["Eight_Ball.usdz", "Soccer_Ball.usdz", "Basketball_Ball.usdz", "Crumpled_paper.usdz", "Cookies.usdz"]
        ]
    }
    
    private func applyConfiguration(_ configuration: ItemConfiguration) {
        itemAssets = configuration.itemAssets
        itemScales = configuration.itemScales
        itemDescriptions = configuration.itemDescriptions
        answerKey = configuration.answerKey
    }

    private func spawnItems() {
        let boundingBoxSize: Float = 0.5
        let minX: Float = -boundingBoxSize / 2
        let maxX: Float = boundingBoxSize / 2
        let minZ: Float = -boundingBoxSize / 2
        let maxZ: Float = boundingBoxSize / 2

        for (index, asset) in itemAssets.enumerated() {
            let randomX = Float.random(in: minX...maxX)
            let randomY = Float.random(in: 0...2)
            let randomZ = Float.random(in: minZ...maxZ)
            let randomPosition = SIMD3<Float>(randomX, randomY, randomZ)
            let scale = itemScales[index]

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
        let formattedItemName = formatItemName(itemName)
        let itemDescription = getItemDescription(for: itemName)
        let itemURL = URL(string: "path/to/\(itemName).usdz")!

        generateThumbnail(for: itemName) { [weak self] image in
            guard let self = self else { return }
            let inventoryItem = InventoryItem(name: formattedItemName, modelURL: itemURL, thumbnail: image, description: itemDescription)
            self.inventory.addItem(inventoryItem)

            // Play item collection sound effect
            AudioManager.shared.playSFX(filename: "ItemCollect", volume: self.sfxVolume)

            self.showItemFoundProgress(itemName: formattedItemName)
        }
    }

    private func formatItemName(_ itemName: String) -> String {
        return itemName.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    private func getItemDescription(for itemName: String) -> String {
        if let index = itemAssets.firstIndex(of: "\(itemName).usdz") {
            return itemDescriptions[index]
        }
        return "Description not available"
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

    func handleGuess(guess: String) {
        isGuessCorrect = (guess == answerKey)
        showGameEnd(correct: isGuessCorrect)
    }

    func showGameEnd(correct: Bool) {
        // Implement your logic to show the game end view
        print(correct ? "Correct Guess" : "Incorrect Guess")
        NotificationCenter.default.post(name: .gameEnded, object: nil, userInfo: ["correct": correct])
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
