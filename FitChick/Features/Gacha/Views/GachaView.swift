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
    
    var body: some View {
        // kalau cuman buat testing bisa di ubah disini yeah total koin sementaranya
        let userTotalCoint = users.first?.totalCoint ?? 40
        
        let isButton1xDisabled = userTotalCoint < 10
        let isButton5xDisabled = userTotalCoint < 50
        
        ZStack {
            RewardAnimation()
            
            VStack(spacing: 0) {
                
                HStack(alignment: .center, spacing: 12) {
                    Spacer()
                    
                    IconButton(icon: Image(systemName: "xmark")) {
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
                    IconButton(icon: Image(systemName: "shippingbox.fill")) {
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
                        executeGacha(cost: 10)
                    }
                    
                    ClaimRewardButton(
                        coinAmount: 50,
                        claimText: "5x",
                        isDisabled: isButton5xDisabled
                    ) {
                        executeGacha(cost: 50)
                    }
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
        
        }
    }
    private func executeGacha(cost: Int) {
        if let currentUser = users.first, currentUser.totalCoint >= cost {
            withAnimation {
                currentUser.totalCoint -= cost
                try? modelContext.save()
            }
            print("Gacha successful! Deducted \(cost) coins. Remaining coins: \(currentUser.totalCoint)")
        }
    }
}

#Preview {
    // Container SwiftData cuman buat keperluan Preview di Canvas yeah
    GachaView()
        .modelContainer(for: UserAccount.self, inMemory: true)
}
