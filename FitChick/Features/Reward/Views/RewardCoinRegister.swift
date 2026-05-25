//
//  RewardCoinRegister.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 20/05/26.
//

import SwiftUI

struct RewardCoinRegister: View {
    @AppStorage("coinCount") private var coinCount = 0
    
    @State private var isRotating: Bool = false
    @State private var navigateToHatchView: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.secondary50Surface,
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
