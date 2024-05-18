//
//  Inventory.swift
//  FTG
//
//  Created by Vincent Saranang on 16/05/24.
//

import Foundation

struct InventoryItem: Identifiable {
    let id = UUID()
    let name: String
    let modelURL: URL // URL of the 3D model associated with the item
}

class Inventory: ObservableObject {
    @Published var items: [InventoryItem] = []

    func addItem(_ item: InventoryItem) {
        items.append(item)
    }
}
