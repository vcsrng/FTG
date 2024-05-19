//
//  ItemManager.swift
//  FTG
//
//  Created by Vincent Saranang on 16/05/24.
//

import Foundation

struct ItemConfiguration {
    let itemAssets: [String]
    let itemScales: [SIMD3<Float>]
    let itemDescriptions: [String]
    let answerKey: String
}

class ItemManager {
    static let shared = ItemManager()
    
    var isItemEntityPlaced = false
    
    private init() {}
}
