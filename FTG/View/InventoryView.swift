//
//  InventoryView.swift
//  FTG
//
//  Created by Vincent Saranang on 16/05/24.
//

import SwiftUI

struct InventoryView: View {
    @ObservedObject var inventory: Inventory

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Inventory").font(.title)
                ForEach(inventory.items, id: \.name) { item in
                    Text(item.name)
                }
            }.padding()
        }
    }
}
