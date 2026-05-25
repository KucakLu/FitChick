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
        CollectionItem(name: "round glasses", rarity: .reguler, category: .face, svgAssetName: "round_glasses", isOwned: true),
        CollectionItem(name: "black hat", rarity: .reguler, category: .head, svgAssetName: "black_hat", isOwned: true),
        CollectionItem(name: "headband", rarity: .reguler, category: .head, svgAssetName: "headband", isOwned: true),
        CollectionItem(name: "red ribbon", rarity: .rare, category: .neck, svgAssetName: "RedRibbon", isOwned: true),
        CollectionItem(name: "dino hat", rarity: .rare, category: .head, svgAssetName: "dino_hat", isOwned: true),
        CollectionItem(name: "baseball cap", rarity: .reguler, category: .head, svgAssetName: "baseball_cap", isOwned: true),
        CollectionItem(name: "astronaut costume", rarity: .reguler, category: .body, svgAssetName: "astronaut_costume", isOwned: true),
        CollectionItem(name: "yellow jacket", rarity: .reguler, category: .body, svgAssetName: "yellow_jacket", isOwned: true),
        CollectionItem(name: "birthday hat", rarity: .reguler, category: .head, svgAssetName: "birthday_hat", isOwned: false),
        CollectionItem(name: "set of magician", rarity: .rare, category: .body, svgAssetName: "set_of_magician", isOwned: false),
        CollectionItem(name: "burberry cap", rarity: .reguler, category: .head, svgAssetName: "burberry_cap", isOwned: false),
        CollectionItem(name: "black beret", rarity: .reguler, category: .head, svgAssetName: "red_beret", isOwned: false),
        CollectionItem(name: "reindeer hat", rarity: .reguler, category: .head, svgAssetName: "reindeer_hat", isOwned: false),
        CollectionItem(name: "artist hat", rarity: .reguler, category: .head, svgAssetName: "artist_hat", isOwned: false),
        CollectionItem(name: "vr glasses", rarity: .reguler, category: .face, svgAssetName: "vr_glasses", isOwned: false),
        CollectionItem(name: "police hat", rarity: .reguler, category: .head, svgAssetName: "police_hat", isOwned: false),
        CollectionItem(name: "tie", rarity: .reguler, category: .body, svgAssetName: "tie", isOwned: false)
        CollectionItem(name: "witch hat", rarity: .reguler, category: .head, svgAssetName: "witch_hat", isOwned: false),
        CollectionItem(name: "christmas hat", rarity: .reguler, category: .head, svgAssetName: "christmas_hat", isOwned: false),
        CollectionItem(name: "sunglasses", rarity: .reguler, category: .face, svgAssetName: "sunglasses", isOwned: false),
        CollectionItem(name: "peter hat", rarity: .reguler, category: .head, svgAssetName: "peter_hat", isOwned: false),
        CollectionItem(name: "red scarf", rarity: .reguler, category: .body, svgAssetName: "red_scarf", isOwned: false),
        CollectionItem(name: "circus hat", rarity: .reguler, category: .head, svgAssetName: "circus_hat", isOwned: false),
        CollectionItem(name: "softball cap", rarity: .reguler, category: .head, svgAssetName: "softball_cap", isOwned: false),
        CollectionItem(name: "necklace", rarity: .reguler, category: .neck, svgAssetName: "necklace", isOwned: false),
        CollectionItem(name: "ruby ", rarity: .reguler, category: .neck, svgAssetName: "ruby", isOwned: false),        CollectionItem(name: "love necklace", rarity: .reguler, category: .neck, svgAssetName: "love_necklace", isOwned: false),
        CollectionItem(name: "diamond", rarity: .reguler, category: .neck, svgAssetName: "diamond", isOwned: false)
    ]

    static let unlockedStorageKey = "unlockedGachaItems"
    

    static func isOwnedEquipment(_ equipment: EquippedPetItem) -> Bool {
        let unlockedItems = UserDefaults.standard.stringArray(forKey: unlockedStorageKey) ?? []
        
        return items.contains { item in
            let currentOwnership = item.isOwned || unlockedItems.contains(item.svgAssetName)
            
            return currentOwnership
                && item.category == equipment.category
                && item.svgAssetName == equipment.assetName
        }
    }
}

struct UnlockedItems: Codable {
    var assetNames: [String] = []

    init(assetNames: [String] = []) {
        self.assetNames = assetNames
    }

    init(encodedString: String) {
        guard let data = encodedString.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(UnlockedItems.self, from: data) else {
            self = UnlockedItems()
            return
        }
        self = decoded
    }

    var encodedString: String {
        guard let data = try? JSONEncoder().encode(self),
              let string = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return string
    }
}
