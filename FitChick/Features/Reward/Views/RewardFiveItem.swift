//
//  RewardFiveItem.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 25/05/26.
//

import SwiftUI

struct RewardFiveItem: View {
    @EnvironmentObject private var router: AppRouter
    @State private var isRotating = false
    @State private var currentStep: Int = 0
    
    let items: [CollectionItem]
    
    var body: some View {
        let currentItem = items[currentStep]
        let isItemRare = currentItem.rarity == .rare

        ZStack {
            if isItemRare {
                RewardAnimationRare()
            } else {
                RewardAnimation()
            }

            VStack {
                Text("Congratulations\nyou got a")
                    .font(AppFont.largeTitleBold)
                    .foregroundColor(isItemRare ? AppColor.neutral100 : AppColor.secondary500Dark)
                    .padding(.bottom, 130)
                    .multilineTextAlignment(.center)

                ZStack {
                    VStack {
                        Image(currentItem.svgAssetName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 234, height: 234)
                            .rotationEffect(.degrees(isRotating ? 25 : -25))
                            .animation(
                                .easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: isRotating
                            )
                            .onAppear {
                                isRotating = true
                            }
                    }
                }
                .frame(width: 234, height: 234)
                .padding(.bottom, 100)
                
                Text(currentItem.name.capitalized)
                    .font(AppFont.largeTitleBold)
                    .foregroundColor(isItemRare ? AppColor.neutral100 : AppColor.secondary500Dark)
                
                CollectRewardButton(title: "Tap to collect") {
                    handleTapSequence()
                }
                .padding(.top, 20)
            }
        }
    }
    
    private func handleTapSequence() {
        withAnimation(.spring()) {
            // Berjalan maju sesuai jumlah item beneran yang dikirim
            if currentStep < items.count - 1 {
                currentStep += 1
            } else {
                PerformanceProbe.event("RouteRewardFiveToDashboard")
                router.showDashboard()
            }
        }
    }
}

#Preview {
    let sampleItems = Array(CollectionData.items.prefix(5))
    
    return RewardFiveItem(items: sampleItems)
        .environmentObject(AppRouter())
}
