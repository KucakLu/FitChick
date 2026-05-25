//
//  ItemSectionView.swift
//  FitChick
//
//  Created by Hendra Irawan on 23/05/26.
//

import SwiftUI

struct ItemSectionView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(EquippedPetItems.storageKey) private var equippedPetItemsStorage = EquippedPetItems.empty.encodedString
    @State private var navigateToDashboard = false

    private let items: [CollectionItem] = CollectionData.items.filter { $0.isOwned }
    
    private let columns = [
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16)
    ]
    
    var body: some View {
        Rectangle()
            .fill(AppColor.secondary50Surface)
            .frame(maxWidth: .infinity)
            .frame(height: 380)
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    Text("")
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(items) { item in
                                ItemGridButton(
                                    svgAssetName: item.svgAssetName,
                                    state: equippedPetItems.isEquipped(item) ? .selected : .normal
                                ) {
                                    toggle(item)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 4)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToDashboard) {
                DashboardView()
            }
            .onAppear(perform: removeUnavailableEquipment)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea(.container, edges: .bottom)
    }

    private var equippedPetItems: EquippedPetItems {
        EquippedPetItems(encodedString: equippedPetItemsStorage)
            .sanitizedForCurrentCatalog
    }

    private func toggle(_ item: CollectionItem) {
        var updatedItems = equippedPetItems
        updatedItems.toggle(item)
        equippedPetItemsStorage = updatedItems.encodedString
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
    ZStack {
        AppColor.dashboardBackground.ignoresSafeArea()
        
        ItemSectionView()
    }
}
