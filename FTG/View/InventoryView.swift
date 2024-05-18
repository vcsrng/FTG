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

    var body: some View {
        VStack {
            ZStack {
                Text("Found Items")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showInventory.toggle()
                        }
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
                            Text(item.modelURL.absoluteString)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding([.leading, .trailing, .top])
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
