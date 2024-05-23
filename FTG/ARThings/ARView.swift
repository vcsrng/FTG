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
        let configuration = selectConfiguration(caseNumber: Int.random(in: 1...9))
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
                itemAssets: ["Bag.usdz", "Macbook.usdz", "Notebook.usdz", "iPhone.usdz", "Lanyard.usdz", "Pen.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.001),
                    SIMD3<Float>(repeating: 0.001),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.0005)
                ],
                itemDescriptions: [
                    "A sturdy, multi-compartment backpack used to carry books, electronics, and other personal items.",
                    "A sleek, high-performance laptop commonly used for software development, graphic design, and professional tasks.",
                    "A portable writing pad or clipboard used for taking notes, organizing tasks, and recording information.",
                    "A smartphone with various apps and functionalities used for communication, internet access, and productivity.",
                    "A strap worn around the neck to hold ID cards, keys, or small devices, often used for identification or security purposes.",
                    "A writing instrument used for jotting down notes, signing documents, and other writing tasks."
                ],
                answerKey: "Apple Developer Student"
            )
        case 2:
            return ItemConfiguration(
                itemAssets: ["Notebook.usdz", "iPhone.usdz", "Lanyard.usdz", "Watch.usdz", "Pen.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.0005)
                ],
                itemDescriptions: [
                    "A portable writing pad or clipboard used for taking notes, organizing tasks, and recording information.",
                    "A smartphone with various apps and functionalities used for communication, internet access, and productivity.",
                    "A strap worn around the neck to hold ID cards, keys, or small devices, often used for identification or security purposes.",
                    "A device worn on the wrist to keep track of time, often with additional features for timing events or activities.",
                    "A writing instrument used for jotting down notes, signing documents, and other writing tasks."
                ],
                answerKey: "Personal Trainer"
            )
        case 3:
            return ItemConfiguration(
                itemAssets: ["Bag.usdz", "Notebook.usdz", "iPhone.usdz", "Pen.usdz", "Lunchbox.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.001),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.0005)
                ],
                itemDescriptions: [
                    "A sturdy, multi-compartment backpack used to carry books, electronics, and other personal items.",
                    "A portable writing pad or clipboard used for taking notes, organizing tasks, and recording information.",
                    "A smartphone with various apps and functionalities used for communication, internet access, and productivity.",
                    "A writing instrument used for jotting down notes, signing documents, and other writing tasks.",
                    "A container used to carry meals and snacks, often used by students, office workers, and field professionals."
                ],
                answerKey: "General Student"
            )
        case 4:
            return ItemConfiguration(
                itemAssets: ["Bag.usdz", "Macbook.usdz", "iPhone.usdz", "Lanyard.usdz", "Lunchbox.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.001),
                    SIMD3<Float>(repeating: 0.001),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.0005)
                ],
                itemDescriptions: [
                    "A sturdy, multi-compartment backpack used to carry books, electronics, and other personal items.",
                    "A sleek, high-performance laptop commonly used for software development, graphic design, and professional tasks.",
                    "A smartphone with various apps and functionalities used for communication, internet access, and productivity.",
                    "A strap worn around the neck to hold ID cards, keys, or small devices, often used for identification or security purposes.",
                    "A container used to carry meals and snacks, often used by students, office workers, and field professionals."
                ],
                answerKey: "Office Worker"
            )
        case 5:
            return ItemConfiguration(
                itemAssets: ["Bag.usdz", "Macbook.usdz", "Notebook.usdz", "Lanyard.usdz", "Pen.usdz", "Scissors.usdz", "WhiteCoat.usdz", "Mask.usdz", "Glove.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.001),
                    SIMD3<Float>(repeating: 0.001),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.0001),
                    SIMD3<Float>(repeating: 0.002),
                    SIMD3<Float>(repeating: 0.001),
                    SIMD3<Float>(repeating: 0.005)
                ],
                itemDescriptions: [
                    "A sturdy, multi-compartment backpack used to carry books, electronics, and other personal items.",
                    "A sleek, high-performance laptop commonly used for software development, graphic design, and professional tasks.",
                    "A portable writing pad or clipboard used for taking notes, organizing tasks, and recording information.",
                    "A strap worn around the neck to hold ID cards, keys, or small devices, often used for identification or security purposes.",
                    "A writing instrument used for jotting down notes, signing documents, and other writing tasks.",
                    "A tool with two blades used for cutting paper, fabric, and other materials, essential in various professions.",
                    "A knee-length coat worn by doctors and scientists, symbolizing cleanliness and professionalism.",
                    "A protective face covering used to prevent the spread of germs and exposure to harmful substances.",
                    "Protective hand coverings used to maintain hygiene and safety in various tasks and professions."
                ],
                answerKey: "Doctor"
            )
        case 6:
            return ItemConfiguration(
                itemAssets: ["Notebook.usdz", "Lanyard.usdz", "Watch.usdz", "Pen.usdz", "Scissors.usdz", "WhiteCoat.usdz", "Mask.usdz", "Glove.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.0001),
                    SIMD3<Float>(repeating: 0.002),
                    SIMD3<Float>(repeating: 0.001),
                    SIMD3<Float>(repeating: 0.005)
                ],
                itemDescriptions: [
                    "A portable writing pad or clipboard used for taking notes, organizing tasks, and recording information.",
                    "A strap worn around the neck to hold ID cards, keys, or small devices, often used for identification or security purposes.",
                    "A device worn on the wrist to keep track of time, often with additional features for timing events or activities.",
                    "A writing instrument used for jotting down notes, signing documents, and other writing tasks.",
                    "A tool with two blades used for cutting paper, fabric, and other materials, essential in various professions.",
                    "A knee-length coat worn by doctors and scientists, symbolizing cleanliness and professionalism.",
                    "A protective face covering used to prevent the spread of germs and exposure to harmful substances.",
                    "Protective hand coverings used to maintain hygiene and safety in various tasks and professions."
                ],
                answerKey: "Scientist"
            )
        case 7:
            return ItemConfiguration(
                itemAssets: ["Notebook.usdz", "iPhone.usdz", "Watch.usdz", "Pen.usdz", "Whistle.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.00005)
                ],
                itemDescriptions: [
                    "A portable writing pad or clipboard used for taking notes, organizing tasks, and recording information.",
                    "A smartphone with various apps and functionalities used for communication, internet access, and productivity.",
                    "A device worn on the wrist to keep track of time, often with additional features for timing events or activities.",
                    "A writing instrument used for jotting down notes, signing documents, and other writing tasks.",
                    "A small, handheld device used to produce a loud sound for signaling or commanding attention, often used in sports and training."
                ],
                answerKey: "Physical Education Teacher"
            )
        case 8:
            return ItemConfiguration(
                itemAssets: ["Notebook.usdz", "Watch.usdz", "Pen.usdz", "Hat.usdz", "Whistle.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.01),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.0003),
                    SIMD3<Float>(repeating: 0.00005)
                ],
                itemDescriptions: [
                    "A portable writing pad or clipboard used for taking notes, organizing tasks, and recording information.",
                    "A device worn on the wrist to keep track of time, often with additional features for timing events or activities.",
                    "A writing instrument used for jotting down notes, signing documents, and other writing tasks.",
                    "A head covering worn for protection against the elements, as part of a uniform, or for fashion.",
                    "A small, handheld device used to produce a loud sound for signaling or commanding attention, often used in sports and training."
                ],
                answerKey: "Referee"
            )
        case 9:
            return ItemConfiguration(
                itemAssets: ["Bag.usdz", "Scissors.usdz", "Mask.usdz", "Glove.usdz", "Lunchbox.usdz", "Hat.usdz"],
                itemScales: [
                    SIMD3<Float>(repeating: 0.001),
                    SIMD3<Float>(repeating: 0.0001),
                    SIMD3<Float>(repeating: 0.001),
                    SIMD3<Float>(repeating: 0.005),
                    SIMD3<Float>(repeating: 0.0005),
                    SIMD3<Float>(repeating: 0.0003)
                ],
                itemDescriptions: [
                    "A sturdy, multi-compartment backpack used to carry books, electronics, and other personal items.",
                    "A tool with two blades used for cutting paper, fabric, and other materials, essential in various professions.",
                    "A protective face covering used to prevent the spread of germs and exposure to harmful substances.",
                    "Protective hand coverings used to maintain hygiene and safety in various tasks and professions.",
                    "A container used to carry meals and snacks, often used by students, office workers, and field professionals.",
                    "A head covering worn for protection against the elements, as part of a uniform, or for fashion."
                ],
                answerKey: "Gardener"
            )
        default:
            fatalError("Invalid case number")
        }
    }

    func generateAnswerList() -> [String: [String]] {
        return [
            // 1
            "Apple Developer Student": ["Bag", "Macbook", "Notebook/Clipboard", "iPhone", "Lanyard", "Pen"],
            // 2
            "Personal Trainer": ["Notebook/Clipboard", "iPhone", "Lanyard", "Watch/Stopwatch", "Pen"],
            // 3
            "General Student": ["Bag", "Notebook/Clipboard", "iPhone", "Pen", "Lunchbox"],
            // 4
            "Office Worker": ["Bag", "Macbook", "iPhone", "Lanyard", "Lunchbox"],
            // 5
            "Doctor": ["Bag", "Macbook", "Notebook/Clipboard", "Lanyard", "Pen", "Scissors", "White Coat", "Mask", "Glove"],
            // 6
            "Scientist": ["Notebook/Clipboard", "Lanyard", "Watch/Stopwatch", "Pen", "Scissors", "White Coat", "Mask", "Glove"],
            // 7
            "Physical Education Teacher": ["Notebook/Clipboard", "iPhone", "Watch/Stopwatch", "Pen", "Whistle"],
            // 8
            "Referee": ["Notebook/Clipboard", "Watch/Stopwatch", "Pen", "Hat", "Whistle"],
            // 9
            "Gardener": ["Bag", "Scissors", "Mask", "Glove", "Lunchbox", "Hat"]
        ]
    }
    
    private func applyConfiguration(_ configuration: ItemConfiguration) {
        itemAssets = configuration.itemAssets
        itemScales = configuration.itemScales
        itemDescriptions = configuration.itemDescriptions
        answerKey = configuration.answerKey
    }

    private func spawnItems() {
        let boundingBoxSize: Float = 1
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
        return itemName.replacingOccurrences(of: "_", with: " ")/*.capitalized*/
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
        let alertView = ItemFoundAlertView(itemName: itemName)
        let hostingController = UIHostingController(rootView: alertView)
            
        hostingController.view.frame = self.bounds
        hostingController.view.backgroundColor = UIColor.clear
        self.addSubview(hostingController.view)
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            hostingController.view.removeFromSuperview()
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
