//
//  RewardCoinRegister.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 20/05/26.
//

import SwiftUI

struct RewardCoinRegister: View {
    @State private var isRotating: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.secondary0Surface,
                    Color.secondary300Main
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            Image("RewardBg")
                .ignoresSafeArea()
                .scaleEffect(1.1)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
                .animation(
                    .linear(duration: 3)
                    .repeatForever(autoreverses: false),
                    value: isRotating
                )
                .onAppear {
                    isRotating = true
                }
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
                NavigationLink(destination: HatchView()) {
                    Text("Tap to collect the coin")
                        .font(AppFont.bodyBold)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    RewardCoinRegister()
}
