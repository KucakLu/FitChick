//
//  ItemSectionView.swift
//  FitChick
//
//  Created by Hendra Irawan on 23/05/26.
//

import SwiftUI

struct ItemSectionView: View {
    @EnvironmentObject private var appState: AppStateStore
    @Binding var equippedItems: EquippedPetItems

    private var unlockedAssetNames: [String] {
        appState.unlockedItems.assetNames
    }

    private var items: [CollectionItem] {
        CollectionData.items.filter { item in
            item.isOwned || unlockedAssetNames.contains(item.svgAssetName)
        }
    }
    
    private let columns = [
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16)
    ]

    private let emptyMessage = "You haven’t collected anything yet. \n do your first gacha \n and see what you’ll get!"
    
    var body: some View {
        Rectangle()
            .fill(AppColor.secondary50Surface)
            .frame(maxWidth: .infinity)
            .frame(height: 380)
            .overlay(alignment: .top) {
                if items.isEmpty {
                    emptyState
                } else {
                    itemGrid
                }
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea(.container, edges: .bottom)
    }

    private var emptyState: some View {
        Text(emptyMessage)
            .font(AppFont.bodyBold)
            .kerning(AppFont.bodyBold.letterSpacing)
            .lineSpacing(AppFont.bodyBold.lineSpacing)
            .foregroundStyle(AppColor.secondary500Dark)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private var itemGrid: some View {
        VStack(spacing: 0) {
            Text("")
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items) { item in
                        ItemGridButton(
                            svgAssetName: item.svgAssetName,
                            state: equippedItems.isEquipped(item) ? .selected : .normal
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

    private func toggle(_ item: CollectionItem) {
        equippedItems.toggle(item)
    }
}

#Preview {
    ItemSectionPreview()
}

private struct ItemSectionPreview: View {
    @State private var equippedItems = EquippedPetItems.empty

    var body: some View {
        ZStack {
            AppColor.dashboardBackground.ignoresSafeArea()

            ItemSectionView(equippedItems: $equippedItems)
                .environmentObject(AppStateStore.preview())
        }
    }
}
