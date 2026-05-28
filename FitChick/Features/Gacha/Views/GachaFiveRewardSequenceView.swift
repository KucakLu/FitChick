//
//  GachaFiveRewardSequenceView.swift
//  FitChick
//
//  Created by Codex on 26/05/26.
//

import SwiftUI

struct GachaFiveRewardSequenceView: View {
    @EnvironmentObject private var router: AppRouter
    let items: [CollectionItem]

    @State private var currentIndex = 0

    var body: some View {
        Group {
            if let currentItem {
                currentRewardView(for: currentItem)
                    .id(currentItem.svgAssetName)
            } else {
                Color.clear
                    .onAppear {
                        router.showDashboard()
                    }
            }
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
            PerformanceProbe.event("RouteRewardFiveToDashboard")
            router.showDashboard()
        }
    }
}

#Preview {
    GachaFiveRewardSequenceView(items: Array(CollectionData.items.prefix(5)))
        .environmentObject(AppRouter())
}
