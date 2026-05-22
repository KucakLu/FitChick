//
//  CollectionItem.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 22/05/26.
//

import Foundation

enum ItemRarity: String, Codable {
    case reguler = "Reguler"
    case rare = "Rare"
}

struct CollectionItem: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let rarity: ItemRarity
    let svgAssetName: String
    var isOwned: Bool
}

struct CollectionData {
    static let items: [CollectionItem] = [
        CollectionItem(
            name: "round glasses",
            rarity: .reguler,
            svgAssetName: "round_glasses",
            isOwned: true
        ),
        CollectionItem(
            name: "black hat",
            rarity: .reguler,
            svgAssetName: "black_hat",
            isOwned: true
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: true
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: true
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: true
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            svgAssetName: "headband",
            isOwned: false
        ),
    ]
}
