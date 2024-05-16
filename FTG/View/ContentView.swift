//
//  ContentView.swift
//  FTG
//
//  Created by Vincent Saranang on 16/05/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var arView = CustomARView(frame: .zero)

    var body: some View {
        VStack {
            ARContentView(arView: arView)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 4 / 5)

            InventoryView(inventory: arView.inventory)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 5)
        }
    }
}
