//
//  ARContentView.swift
//  FTG
//
//  Created by Vincent Saranang on 16/05/24.
//

import SwiftUI
import ARKit
import RealityKit
import Combine
import FocusEntity

struct ARContentView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        return CustomARView(frame: .zero)
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
         
    }
}
