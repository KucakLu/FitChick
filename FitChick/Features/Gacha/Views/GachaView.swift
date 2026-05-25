//
//   GachaView.swift
//   FitChick
//
//   Created by Vinka Alrezky As on 21/05/26.
//

import SwiftUI

enum GachaResultType {
    case singleNormal(CollectionItem)
    case singleRare(CollectionItem)
    case fiveDraw([CollectionItem])
}

struct GachaView: View {
    private enum GachaOpeningState {
        case idle
        case shaking
        case opened
    }

    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("coinCount") private var coinCount = 0
    @AppStorage("totalGachaCount") private var totalGachaCount = 0
    
    @AppStorage(CollectionData.unlockedStorageKey) private var unlockedStorageString = "{}"
        
    @State private var showRewardView: Bool = false
    @State private var selectedResultType: GachaResultType = .singleNormal(CollectionData.items[0])
    @State private var navigateToCollectionPage = false
    @State private var gachaOpeningState: GachaOpeningState = .idle
    @State private var showPreviewItems = false
    @State private var showCollectPrompt = false
    @State private var arePreviewItemsRotating = false
    
    var body: some View {
        let isGachaAnimationActive = gachaOpeningState != .idle
        let isGachaSoldOut = !hasAvailableGachaItem
        let isButton1xDisabled = coinCount < 10 || showRewardView || isGachaAnimationActive || isGachaSoldOut
        let isButton5xDisabled = coinCount < 50 || showRewardView || isGachaAnimationActive || isGachaSoldOut
        
        ZStack {
            RewardAnimation()
            
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 12) {
                    Spacer()
                    DismissButton(variant: .neutral) { dismiss() }
                    Spacer().frame(width: 50)
                    HStack(spacing: 6) {
                        Image("RewardCoin").resizable().aspectRatio(contentMode: .fit).frame(width: 28, height: 28)
                        Text("\(coinCount)").font(AppFont.title1Bold).foregroundStyle(AppColor.secondary500Dark)
                    }
                    .padding(.horizontal, 16).padding(.vertical, 6)
                    Spacer().frame(width: 50)
                    IconButton(icon: Image("collectibleIcon")) { navigateToCollectionPage = true }
                    Spacer()
                }
                .opacity(isGachaAnimationActive ? 0 : 1)
                .allowsHitTesting(!isGachaAnimationActive)
                .padding(.horizontal, 24).padding(.top, 60)
                
                Spacer()

                gachaCaseView
                
                if showCollectPrompt {
                    Spacer()
                    Text("Tap anywhere to collect")
                        .font(AppFont.title2Bold)
                        .kerning(AppFont.bodyBold.letterSpacing)
                        .foregroundStyle(AppColor.secondary500Dark)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .transition(.opacity)
                } else if !isGachaAnimationActive {
                    HStack(spacing: 24) {
                        ClaimRewardButton(coinAmount: 10, claimText: "1x", isDisabled: isButton1xDisabled) {
                            executeGacha(cost: 10, drawCount: 1)
                        }
                        .allowsHitTesting(!isButton1xDisabled)

                        ClaimRewardButton(coinAmount: 50, claimText: "5x", isDisabled: isButton5xDisabled) {
                            executeGacha(cost: 50, drawCount: 5)
                        }
                        .allowsHitTesting(!isButton5xDisabled)
                    }

                    Spacer().frame(height: 32)
                    Text(gachaStatusText(isGachaSoldOut: isGachaSoldOut, isButton1xDisabled: isButton1xDisabled, isButton5xDisabled: isButton5xDisabled))
                        .font(AppFont.body).foregroundStyle(AppColor.secondary500Dark).multilineTextAlignment(.center).padding(.horizontal, 32)
                }
                
                Spacer()
            }
            .fullScreenCover(isPresented: $showRewardView) {
                rewardDestinationView
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToCollectionPage) {
                CollectionView()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            collectGachaRewardIfReady()
        }
    }
    
    @ViewBuilder
    private var gachaCaseView: some View {
        ZStack {
            GachaCasAnimationView(phase: gachaCasePhase)
                .frame(width: gachaOpeningState == .idle ? 260 : 280, height: gachaOpeningState == .idle ? 260 : 280)

            if showPreviewItems {
                previewItemsView
            }
        }
        .frame(width: 280, height: 280)
    }

    private var gachaCasePhase: CaseOpeningPhase {
        switch gachaOpeningState {
        case .idle:
            return .closed
        case .shaking:
            return .shaking
        case .opened:
            return .open
        }
    }

    @ViewBuilder
    private var previewItemsView: some View {
        let items = selectedPreviewItems

        if items.count == 1, let item = items.first {
            previewImage(for: item, size: 90)
                .offset(y: -42)
        } else {
            VStack(spacing: 8) {
                previewRow(items: Array(items.prefix(3)), size: 46)
                previewRow(items: Array(items.dropFirst(3).prefix(2)), size: 46)
            }
            .offset(y: -42)
        }
    }

    @ViewBuilder
    private func previewRow(items: [CollectionItem], size: CGFloat) -> some View {
        HStack(spacing: 8) {
            ForEach(items) { item in
                previewImage(for: item, size: size)
            }
        }
    }

    private func previewImage(for item: CollectionItem, size: CGFloat) -> some View {
        Image(item.svgAssetName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .rotationEffect(arePreviewItemsRotating ? Angle(degrees: 10) : Angle(degrees: -10))
            .transition(.scale(scale: 0.72).combined(with: .opacity))
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    arePreviewItemsRotating.toggle()
                }
            }
    }

    private var selectedPreviewItems: [CollectionItem] {
        switch selectedResultType {
        case .singleNormal(let item), .singleRare(let item):
            return [item]
        case .fiveDraw(let items):
            return items
        }
    }

    @ViewBuilder
    private var rewardDestinationView: some View {
        switch selectedResultType {
        case .singleNormal(let item):
            RewardItem(item: item)
        case .singleRare(let item):
            RewardRareItem(item: item)
        case .fiveDraw(let items):
            GachaFiveRewardSequenceView(items: items)
        }
    }

    private var hasAvailableGachaItem: Bool {
        let unlockedList = UnlockedItems(encodedString: unlockedStorageString).assetNames

        return CollectionData.items.contains { item in
            !isItemOwned(item, unlockedList: unlockedList)
        }
    }

    private func gachaStatusText(
        isGachaSoldOut: Bool,
        isButton1xDisabled: Bool,
        isButton5xDisabled: Bool
    ) -> String {
        if isGachaSoldOut {
            return "All rewards collected!"
        }

        return isButton1xDisabled && isButton5xDisabled
            ? "Earn coins to get exciting rewards!"
            : "Guaranteed rare item within 5x draws!"
    }

    private func executeGacha(cost: Int, drawCount: Int) {
        guard coinCount >= cost, gachaOpeningState == .idle, hasAvailableGachaItem else {
            return
        }

        if drawCount == 1 {
            executeSingleGacha(cost: cost)
        } else {
            executeFiveGacha(cost: cost)
        }
    }

    private func executeSingleGacha(cost: Int) {
        coinCount -= cost

        var unlockedContainer = UnlockedItems(encodedString: unlockedStorageString)
        totalGachaCount += 1
        let isRare = totalGachaCount % 4 == 0

        guard let drawnItem = rollUnownedItem(unlockedList: unlockedContainer.assetNames, preferRare: isRare) else {
            coinCount += cost
            totalGachaCount -= 1
            return
        }

        unlock(drawnItem, in: &unlockedContainer)
        selectedResultType = drawnItem.rarity == .rare ? .singleRare(drawnItem) : .singleNormal(drawnItem)
        unlockedStorageString = unlockedContainer.encodedString

        startGachaOpeningAnimation()
    }

    private func executeFiveGacha(cost: Int) {
        coinCount -= cost

        var unlockedContainer = UnlockedItems(encodedString: unlockedStorageString)
        var gachaResults: [CollectionItem] = []
        let originalTotalGachaCount = totalGachaCount

        for _ in 1...5 {
            totalGachaCount += 1
            let isRare = totalGachaCount % 4 == 0

            if let drawnItem = rollUnownedItem(unlockedList: unlockedContainer.assetNames, preferRare: isRare) {
                gachaResults.append(drawnItem)
                unlock(drawnItem, in: &unlockedContainer)
            }
        }

        guard !gachaResults.isEmpty else {
            coinCount += cost
            totalGachaCount = originalTotalGachaCount
            return
        }

        selectedResultType = .fiveDraw(gachaResults)
        unlockedStorageString = unlockedContainer.encodedString
        startGachaOpeningAnimation()
    }

    private func startGachaOpeningAnimation() {
        arePreviewItemsRotating = false
        showPreviewItems = false
        showCollectPrompt = false

        withAnimation(.easeInOut(duration: 0.25)) {
            gachaOpeningState = .shaking
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_250_000_000)

            withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                gachaOpeningState = .opened
            }

            try? await Task.sleep(nanoseconds: 420_000_000)

            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                showPreviewItems = true
                showCollectPrompt = true
            }
        }
    }

    private func collectGachaRewardIfReady() {
        guard showCollectPrompt else {
            return
        }

        SoundManager.shared.playButtonSound()
        showRewardView = true
    }

    private func unlock(_ item: CollectionItem, in unlockedContainer: inout UnlockedItems) {
        if !unlockedContainer.assetNames.contains(item.svgAssetName) {
            unlockedContainer.assetNames.append(item.svgAssetName)
        }
    }

    private func rollUnownedItem(unlockedList: [String], preferRare: Bool) -> CollectionItem? {
        let targetRarity: ItemRarity = preferRare ? .rare : .reguler
        
        let pool = CollectionData.items.filter { item in
            !isItemOwned(item, unlockedList: unlockedList) && item.rarity == targetRarity
        }
        
        let fallbackPool = pool.isEmpty ? CollectionData.items.filter { item in
            !isItemOwned(item, unlockedList: unlockedList)
        } : pool
        
        return fallbackPool.randomElement()
    }

    private func isItemOwned(_ item: CollectionItem, unlockedList: [String]) -> Bool {
        item.isOwned || unlockedList.contains(item.svgAssetName)
    }
}
#Preview {
    let _ = UserDefaults.standard.set(100, forKey: "coinCount")
    let _ = UserDefaults.standard.set(0, forKey: "totalGachaCount")
    
    return GachaView()
}
