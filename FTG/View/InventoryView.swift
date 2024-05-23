//
//  InventoryView.swift
//  FTG
//
//  Created by Vincent Saranang on 16/05/24.
//

import SwiftUI

struct InventoryView: View {
    @ObservedObject var inventory: Inventory
    @Binding var showInventory: Bool
    @Binding var sfxVolume: Float

    var body: some View {
        VStack {
            ZStack {
                Text("Found Items")
                    .font(Font.custom("Koulen-Regular", size: 64))
                    .padding()
                    .padding(.top)
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showInventory.toggle()
                        }
                        AudioManager.shared.playSFX(filename: "ButtonClick", volume: sfxVolume)
                    }) {
                        Image(systemName: "x.square.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                            .padding()
                    }
                    .padding()
                }
            }
            
            ScrollView {
                ForEach(inventory.items, id: \.id) { item in
                    HStack {
                        if let thumbnail = item.thumbnail {
                            Image(uiImage: thumbnail)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .padding()
                        } else {
                            Image(systemName: "cube.box.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding()
                        }

                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.8))
                        }

                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .padding([.horizontal, .top])
                }
            }
            .padding(.horizontal, 24)
        }
        .background(
            Image("BrownTexture2")
                .resizable()
                .frame(width: 1384, height: 1384)
        )
    }
}
