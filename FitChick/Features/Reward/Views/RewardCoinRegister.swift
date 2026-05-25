//
//  RewardCoinRegister.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 20/05/26.
//

import SwiftUI

struct RewardCoinRegister: View {
    @AppStorage("coinCount") private var coinCount = 0
    @State private var navigateToHatchView = false
    @State private var isCollected = false
    @State private var showHatchView = false

    var body: some View {
        ZStack {
            RewardAnimation()
                .allowsHitTesting(false)

            VStack {
                Text("Register Reward")
                    .font(AppFont.largeTitleBold)
                    .foregroundColor(AppColor.secondary500Dark)
                    .padding(.bottom, 170)

                VStack {
                    Image("RewardCoin")
                        .resizable()
                        .frame(width: 234, height: 234)

                    Text("+ 10 Coins")
                        .font(AppFont.largeTitleBold)
                        .foregroundColor(AppColor.secondary500Dark)
                        .padding(.top, 20)
                }
                .padding(.bottom, 120)
                
                

                Text("Tap anywhere to collect the coin")
                    .font(AppFont.bodyBold)
                    .foregroundColor(.black)
            }
            if showHatchView {
                HatchPage4s()
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 0.7)
                                .combined(with: .opacity),
                            removal: .opacity
                        )
                    )
                    .zIndex(1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            coinCount += 10

            withAnimation(.spring(
                response: 0,
                dampingFraction: 1
            )) {
                showHatchView = true
            }
        }
        .fullScreenCover(isPresented: $navigateToHatchView) {
            HatchPage4s() // nanti ganti screen nya kemana
        }
    }
}

#Preview {
    RewardCoinRegister()
}
