//
//  ARContentView.swift
//  FTG
//
//  Created by Vincent Saranang on 16/05/24.
//

import SwiftUI

struct ARContentView: UIViewRepresentable {
    let arView: CustomARView

    func makeUIView(context: Context) -> CustomARView {
        return arView
    }

    func updateUIView(_ uiView: CustomARView, context: Context) {
    }
}
