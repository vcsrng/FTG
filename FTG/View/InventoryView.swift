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
                        AudioManager.shared.playSFX(filename: "sfxClick", volume: sfxVolume)
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                            .overlay{
                                ZStack{
                                    VStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.white.opacity(0.2))
                                        RoundedRectangle(cornerRadius: 16)
                                            .opacity(0)
                                    }
                                    .padding(4)
                                    Image("CloseIcon")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .shadow(radius: 4)
                                    
                                }
                            }
                            .padding(.trailing, 24)
                    }
                    .padding()
                }
            }
            
            ScrollView(showsIndicators: false) {
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
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
            Image("BrownTexture")
                .resizable()
                .frame(width: 1384, height: 1384)
        )
    }
}
