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

enum ItemCategory: String, Codable, CaseIterable {
    case head
    case face
    case body
    case neck
}

struct CollectionItem: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let rarity: ItemRarity
    let category: ItemCategory
    let svgAssetName: String
    var isOwned: Bool
}

struct EquippedPetItem: Codable, Equatable {
    let name: String
    let category: ItemCategory
    let assetName: String

    init(item: CollectionItem) {
        name = item.name
        category = item.category
        assetName = item.svgAssetName
    }
}

struct EquippedPetItems: Codable, Equatable {
    static let storageKey = "equippedPetItems"
    static let empty = EquippedPetItems()

    var head: EquippedPetItem?
    var body: EquippedPetItem?
    var face: EquippedPetItem?
    var neck: EquippedPetItem?
    var hasBlackHatEquipped: Bool {
        head?.assetName == "black_hat"
    }

    var sanitizedForCurrentCatalog: EquippedPetItems {
        var sanitizedItems = self

        ItemCategory.allCases.forEach { category in
            guard let item = sanitizedItems[category] else {
                return
            }

            if CollectionData.isOwnedEquipment(item) == false {
                sanitizedItems[category] = nil
            }
        }

        return sanitizedItems.singleSelection
    }

    var singleSelection: EquippedPetItems {
        // Older storage could keep one item per category; collapse it to one visible choice.
        let equippedCategories = ItemCategory.allCases.filter { self[$0] != nil }

        guard equippedCategories.count > 1 else {
            return self
        }

        guard
            let preservedCategory = equippedCategories.last,
            let preservedItem = self[preservedCategory]
        else {
            return .empty
        }

        var selectedItems = EquippedPetItems()
        selectedItems[preservedCategory] = preservedItem
        return selectedItems
    }

    init(
        head: EquippedPetItem? = nil,
        body: EquippedPetItem? = nil,
        face: EquippedPetItem? = nil,
        neck: EquippedPetItem? = nil
    ) {
        self.head = head
        self.body = body
        self.face = face
        self.neck = neck
    }

    init(encodedString: String) {
        guard
            let data = encodedString.data(using: .utf8),
            let decodedEquipment = try? JSONDecoder().decode(
                EquippedPetItems.self,
                from: data
            )
        else {
            self = .empty
            return
        }

        self = decodedEquipment
    }

    var encodedString: String {
        guard
            let data = try? JSONEncoder().encode(self),
            let encodedString = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }

        return encodedString
    }

    func isEquipped(_ item: CollectionItem) -> Bool {
        self[item.category]?.assetName == item.svgAssetName
    }

    mutating func toggle(_ item: CollectionItem) {
        if isEquipped(item) {
            self = .empty
            return
        }

        self = .empty
        self[item.category] = EquippedPetItem(item: item)
    }

    subscript(category: ItemCategory) -> EquippedPetItem? {
        get {
            switch category {
            case .head:
                return head
            case .body:
                return body
            case .face:
                return face
            case .neck:
                return neck
            }
        }
        set {
            switch category {
            case .head:
                head = newValue
            case .body:
                body = newValue
            case .face:
                face = newValue
            case .neck:
                neck = newValue
            }
        }
    }
}

struct CollectionData {
    static let items: [CollectionItem] = [
        CollectionItem(
            name: "round glasses",
            rarity: .reguler,
            category: .face,
            svgAssetName: "round_glasses",
            isOwned: true
        ),
        CollectionItem(
            name: "black hat",
            rarity: .reguler,
            category: .head,
            svgAssetName: "black_hat",
            isOwned: true
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            category: .head,
            svgAssetName: "headband",
            isOwned: true
        ),
        CollectionItem(
            name: "red ribbon",
            rarity: .rare,
            category: .neck,
            svgAssetName: "RedRibbon",
            isOwned: true
        ),
        CollectionItem(
            name: "dino hat",
            rarity: .rare,
            category: .head,
            svgAssetName: "dino_hat",
            isOwned: true
        ),
        CollectionItem(
            name: "baseball cap",
            rarity: .reguler,
            category: .head,
            svgAssetName: "baseball_cap",
            isOwned: true
        ),
        CollectionItem(
            name: "astronaut costume",
            rarity: .reguler,
            category: .body,
            svgAssetName: "astronaut_costume",
            isOwned: true
        ),
        CollectionItem(
            name: "yellow jacket",
            rarity: .reguler,
            category: .body,
            svgAssetName: "yellow_jacket",
            isOwned: true
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            category: .head,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            category: .head,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            category: .head,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            category: .head,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            category: .head,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            category: .head,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            category: .head,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            category: .head,
            svgAssetName: "headband",
            isOwned: false
        ),
        CollectionItem(
            name: "headband",
            rarity: .reguler,
            category: .head,
            svgAssetName: "headband",
            isOwned: false
        ),
    ]

    static func isOwnedEquipment(_ equipment: EquippedPetItem) -> Bool {
        items.contains { item in
            item.isOwned
                && item.category == equipment.category
                && item.svgAssetName == equipment.assetName
        }
    }
}
