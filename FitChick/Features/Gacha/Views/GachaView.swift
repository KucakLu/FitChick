//
//   GachaView.swift
//   FitChick
//
//   Created by Vinka Alrezky As on 21/05/26.
//

import SwiftUI


struct GachaView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("coinCount") private var coinCount = 0
    @AppStorage("totalGachaCount") private var totalGachaCount = 0
    
    @State private var showRewardView: Bool = false
    @State private var selectedResultType: GachaResultType = .singleNormal
    @State private var navigateToCollectionPage = false
    
    var body: some View {
        let isButton1xDisabled = coinCount < 10 && !showRewardView
        let isButton5xDisabled = coinCount < 50 && !showRewardView
        
        ZStack {
            RewardAnimation()
            
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 12) {
                    Spacer()
                    
                    DismissButton(variant: .neutral) {
                        dismiss()
                    }
                    Spacer()
                        .frame(width: 50)
                    
                    HStack(spacing: 6) {
                        Image("RewardCoin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                        
                        Text("\(coinCount)")
                            .font(AppFont.title1Bold)
                            .foregroundStyle(AppColor.secondary500Dark)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    
                    Spacer()
                        .frame(width: 50)

                    IconButton(icon: Image("collectibleIcon")) {
                        navigateToCollectionPage = true
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                Spacer()
                
                Image("ChestBox-1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 260, height: 260)
                
                HStack(spacing: 24) {
                    ClaimRewardButton(
                        coinAmount: 10,
                        claimText: "1x",
                        isDisabled: isButton1xDisabled
                    ) {
                        executeGacha(cost: 10, drawCount: 1)
                    }
                    .allowsHitTesting(!showRewardView)
                    
                    ClaimRewardButton(
                        coinAmount: 50,
                        claimText: "5x",
                        isDisabled: isButton5xDisabled
                    ) {
                        executeGacha(cost: 50, drawCount: 5)
                    }
                    .allowsHitTesting(!showRewardView)
                }
                
                Spacer()
                    .frame(height: 32)
                
                Text(
                    isButton1xDisabled && isButton5xDisabled
                    ? "Earn coins to get exciting rewards!"
                    : "Guaranteed rare item within 5x draws!"
                )
                .font(AppFont.body)
                .foregroundStyle(AppColor.secondary500Dark)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .fullScreenCover(isPresented: $showRewardView) {
                GachaRewardView(resultType: selectedResultType)
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToCollectionPage) {
                CollectionView()
            }
        }
    }
    
    private func executeGacha(cost: Int, drawCount: Int) {
        if coinCount >= cost {
            coinCount -= cost
            
            if drawCount == 5 {
                self.selectedResultType = .fiveDraw
                
                for _ in 1...5 {
                    totalGachaCount += 1
                }
            } else {
                totalGachaCount += 1
                if totalGachaCount % 4 == 0 {
                    self.selectedResultType = .singleRare
                    print("Draw ke-\(totalGachaCount): FIXED RARE ITEM!")
                } else {
                    self.selectedResultType = .singleNormal
                    print("Draw ke-\(totalGachaCount): Random Item Biasa.")
                }
            }
            
            print("Total Gacha saat ini: \(totalGachaCount) kali. Sisa koin: \(coinCount)")
            self.showRewardView = true
        }
    }
}

enum GachaResultType {
    case singleNormal
    case singleRare
    case fiveDraw
}

#Preview {
    let _ = UserDefaults.standard.set(100, forKey: "coinCount")
    let _ = UserDefaults.standard.set(0, forKey: "totalGachaCount")
    
    return GachaView()
}
