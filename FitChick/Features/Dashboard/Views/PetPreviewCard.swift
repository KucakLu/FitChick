//
//  PetPreviewCard.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI

struct PetPreviewCard: View {
    private let cardSize = CGSize(width: 360, height: 254)
    private let petSceneSize = CGSize(width: 250, height: 305)
    private let shadowWidth: CGFloat = 300
    private let contentYOffset: CGFloat = -2
    @AppStorage(EquippedPetItems.storageKey) private var equippedPetItemsStorage = EquippedPetItems.empty.encodedString

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("ShadowSpotlight")
                .resizable()
                .scaledToFit()
                .frame(width: shadowWidth)
                .offset(y: contentYOffset + 6)

            petContent
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .onAppear(perform: removeUnavailableEquipment)
        .onChange(of: equippedPetItemsStorage) { _, _ in
            removeUnavailableEquipment()
        }
    }

    @ViewBuilder
    private var petContent: some View {
        PetSceneView(equipment: equippedPetItems)
            .frame(width: petSceneSize.width, height: petSceneSize.height)
            .offset(y: contentYOffset)
    }

    private var equippedPetItems: EquippedPetItems {
        EquippedPetItems(encodedString: equippedPetItemsStorage)
            .sanitizedForCurrentCatalog
    }

    private func removeUnavailableEquipment() {
        let sanitizedItems = equippedPetItems

        guard sanitizedItems.encodedString != equippedPetItemsStorage else {
            return
        }

        equippedPetItemsStorage = sanitizedItems.encodedString
    }
}

#Preview {
    PetPreviewCard()
}
