//
//  Inventory.swift
//  FTG
//
//  Created by Vincent Saranang on 16/05/24.
//

import Foundation

import SwiftUI

struct InventoryItem: Identifiable {
    let id = UUID()
    let name: String
    let modelURL: URL
    var thumbnail: UIImage?
}

class Inventory: ObservableObject {
    @Published var items: [InventoryItem] = []

    func addItem(_ item: InventoryItem) {
        items.append(item)
    }
}
