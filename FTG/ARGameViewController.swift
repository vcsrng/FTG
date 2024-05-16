//
//  ARGameViewController.swift
//  FTG
//
//  Created by Vincent Saranang on 15/05/24.
//

import UIKit
import ARKit
import RealityKit

class ARGameViewController: UIViewController {

    var arView: ARView!
    var itemEntities = [Entity]()
    var progressLabel: UILabel!
    var itemsFound = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize ARView
        arView = ARView(frame: .zero)
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        
        view.addSubview(arView)

        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)

        // Add progress label
        progressLabel = UILabel(frame: CGRect(x: 20, y: 50, width: view.frame.width - 40, height: 50))
        progressLabel.textColor = .white
        progressLabel.textAlignment = .center
        view.addSubview(progressLabel)

        // Spawn items
        spawnItems()

        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
    }

    func spawnItems() {
        // Load each item manually and specify its position
        let asset1 = try! Entity.load(named: "Eight_Ball.usdz")
        let asset2 = try! Entity.load(named: "Golf_Ball.usdz")
        let asset3 = try! Entity.load(named: "Soccer_Ball.usdz")
        let asset4 = try! Entity.load(named: "Crumpled_paper.usdz")
        
        asset1.generateCollisionShapes(recursive: true)
        asset2.generateCollisionShapes(recursive: true)
        asset3.generateCollisionShapes(recursive: true)
        asset4.generateCollisionShapes(recursive: true)
        
        // Add items to the scene
        let anchor = AnchorEntity()
        
        let positions: [SIMD3<Float>] = [
            SIMD3<Float>(1, 0, 1),
            SIMD3<Float>(5, 0, 0),
            SIMD3<Float>(-5, 0, 1),
            SIMD3<Float>(6, 0, 7)
        ]

        for (index, position) in positions.enumerated() {
            let asset =
            index == 0 ? asset1 :
            (index == 1 ? asset2 :
                (index == 2 ? asset3 :
                asset4))
            asset.position = position
            anchor.addChild(asset)
            itemEntities.append(asset)
        }
        
        arView.scene.addAnchor(anchor)
    }

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let arView = recognizer.view as? ARView else { return }
        
        // Perform hit test to get tapped entity
        let tapLocation = recognizer.location(in: arView)
        
        if let tappedEntity = arView.entity(at: tapLocation) {
            if itemEntities.contains(tappedEntity) {
                itemsFound += 1
                progressLabel.text = "Items Found: \(itemsFound)"
                tappedEntity.removeFromParent()
                if itemsFound == itemEntities.count {
                    gameOver()
                }
            }
        }
    }

    func gameOver() {
        progressLabel.text = "Congratulations! You found all items!"
    }
}
