//
//  GachaView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 21/05/26.
//


import SwiftUI
import SwiftData

struct GachaView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query var users: [UserAccount]
    
    @State private var showRewardView: Bool = false
    @State private var selectedDrawType: Int = 1
    
    var body: some View {
        let userTotalCoint = users.first?.totalCoint ?? 50
        
        let isButton1xDisabled = userTotalCoint < 10 && !showRewardView
        let isButton5xDisabled = userTotalCoint < 50 && !showRewardView
        
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
                        
                        Text("\(userTotalCoint)")
                            .font(AppFont.title1Bold)
                            .foregroundStyle(AppColor.secondary500Dark)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    
                    Spacer()
                            .frame(width: 50)
                    // bentar belum nemu nama icon yang bener
                    IconButton(icon: Image("collectibleIcon")) {
                        // nanti ke page daftar item
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
                        GachaRewardView(drawType: selectedDrawType)
            }
        
        }
    }

    private func executeGacha(cost: Int, drawCount: Int) {
        if let currentUser = users.first, currentUser.totalCoint >= cost {
            self.selectedDrawType = drawCount
            self.showRewardView = true
        
            currentUser.totalCoint -= cost
                do {
                    try modelContext.save()
                    print("Coins deducted successfully!")
                } catch {
                    print("Failed to save coin data: \(error.localizedDescription)")
                }
        }
    }
}

// coba testing disini
#Preview {
    let container = try! ModelContainer(for: UserAccount.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let dummyUser = UserAccount(userId: "", petName: "", totalCoint: 100)
    
    container.mainContext.insert(dummyUser)
    
    return GachaView()
        .modelContainer(container)
}
