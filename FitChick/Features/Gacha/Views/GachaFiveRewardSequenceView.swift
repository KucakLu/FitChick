//
//  GachaFiveRewardSequenceView.swift
//  FitChick
//
//  Created by Codex on 26/05/26.
//

import SwiftUI

struct GachaFiveRewardSequenceView: View {
    let items: [CollectionItem]

    @State private var currentIndex = 0
    @State private var navigateToDashboard = false

    var body: some View {
        Group {
            if let currentItem {
                currentRewardView(for: currentItem)
                    .id(currentItem.svgAssetName)
            } else {
                DashboardView()
            }
        }
        .fullScreenCover(isPresented: $navigateToDashboard) {
            DashboardView()
        }
    }

    private var currentItem: CollectionItem? {
        guard items.indices.contains(currentIndex) else {
            return nil
        }

        return items[currentIndex]
    }

    @ViewBuilder
    private func currentRewardView(for item: CollectionItem) -> some View {
        if item.rarity == .rare {
            RewardRareItem(item: item) {
                collectCurrentItem()
            }
        } else {
            RewardItem(item: item) {
                collectCurrentItem()
            }
        }
    }

    private func collectCurrentItem() {
        if currentIndex < items.count - 1 {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                currentIndex += 1
            }
        } else {
            navigateToDashboard = true
        }
    }
}

#Preview {
    GachaFiveRewardSequenceView(items: Array(CollectionData.items.prefix(5)))
}
