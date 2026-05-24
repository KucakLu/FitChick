//
//  RewardCoinRegister.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 20/05/26.
//

import SwiftUI

struct RewardCoinRegister: View {
    @AppStorage("coinCount") private var coinCount = 0
    @State private var navigateToHatchView: Bool = false
    
    var body: some View {
        ZStack {
            RewardBg(scale: 1.1)

            VStack {
                Text("Register Reward")
                    .font(AppFont.largeTitleBold)
                    .padding(.bottom, 80)
                ZStack {
                    Image("OvalReward")
                    VStack {
                        Image("RewardCoin")
                            .resizable()
                            .frame(width: 234, height: 234)
                        Text("+ 10 Coins")
                            .font(AppFont.largeTitleBold)
                    }
                }
                .padding(.bottom, 120)
                Button {
                    coinCount += 10
                    navigateToHatchView = true
                } label: {
                    Text("Tap to collect the coin")
                        .font(AppFont.bodyBold)
                        .foregroundColor(.black)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToHatchView) {
            HatchView()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    RewardCoinRegister()
}
