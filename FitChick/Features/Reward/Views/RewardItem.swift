//
//  RewardItem.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 22/05/26.
//

import SwiftUI

struct RewardItem: View {
    @State private var isRotating: Bool = true
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Int = 0
    
    var body: some View {
        ZStack {
            RewardAnimation()
            VStack {
                Text("Congratulations\nyou got a")
                    .font(AppFont.largeTitleBold)
                    .padding(.bottom, 80)
                    .multilineTextAlignment(.center)
                ZStack {
                    Image("OvalReward")
                    VStack {
                        Image("RedRibbon")
                            .resizable()
                            .frame(width: 234, height: 234)
                            .rotationEffect(isRotating ? Angle(degrees: 25) : Angle(degrees: -25))
                            .animation(
                                .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                                value: isRotating
                            )
                        Text("red ribbon")
                            .font(AppFont.largeTitleBold)
                    }
                }
                .padding(.bottom, 50)
                CollectRewardButton(title: "Tap to collect") {
                    handleTapSequence()
                }
            }
            .onAppear {
                // Start the oscillating rotation
                isRotating.toggle()
            }
        }
    }
    
    private func handleTapSequence() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.6, blendDuration: 0)) {
            if currentStep < 3 {
                currentStep += 1
            } else {
                dismiss()
            }
        }
    }
}

#Preview {
    RewardItem()
}
