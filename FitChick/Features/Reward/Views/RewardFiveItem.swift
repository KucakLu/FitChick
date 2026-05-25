//
//  RewardFiveItem.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 25/05/26.
//

import SwiftUI

struct RewardFiveItem: View {
    @State private var isRotating = false
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Int = 0
    @State private var navigateToDashboard: Bool = false
    
    struct RewardData {
        let image: String
        let title: String
        let isRare: Bool
    }
    
    private let rewards: [RewardData] = [
        RewardData(
            image: "RedRibbon",
            title: "Red Ribbon",
            isRare: false
        ),
        RewardData(
            image: "BaseballCap",
            title: "Baseball Cap",
            isRare: false
        ),
        RewardData(
            image: "DinoCap",
            title: "Dino Cap",
            isRare: false
        ),
        RewardData(
            image: "PeterHat",
            title: "PeterHat",
            isRare: false
        ),
        RewardData(
            image: "BlueChicken",
            title: "Blue Chicken",
            isRare: true
        )
    ]
    
    var body: some View {
        let reward = rewards[currentStep]

        ZStack {
            
            if reward.isRare {
                RewardAnimationRare()
            } else {
                RewardAnimation()
            }

            VStack {
                Text("Congratulations\nyou got a")
                    .font(AppFont.largeTitleBold)
                    .foregroundColor(reward.isRare ? AppColor.neutral100 : AppColor.secondary500Dark)
                    .padding(.bottom, 130)
                    .multilineTextAlignment(.center)

                ZStack {
                    VStack {
                        Image(reward.image)
                            .resizable()
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
                .padding(.bottom, 100)
                Text(reward.title)
                    .font(AppFont.largeTitleBold)
                    .foregroundColor(reward.isRare ? AppColor.neutral100 : AppColor.secondary500Dark)
                CollectRewardButton(title: "Tap to collect") {
                    handleTapSequence()
                }
                .fullScreenCover(isPresented: $navigateToDashboard) {
                    DashboardView()
                }
                .padding(.top, 20)
            }
        }
    }
    
    private func handleTapSequence() {
        withAnimation(.spring()) {
            if currentStep < rewards.count - 1 {
                currentStep += 1
            } else {
                navigateToDashboard = true
            }
        }
    }
    
    
}

#Preview {
    RewardFiveItem()
}
