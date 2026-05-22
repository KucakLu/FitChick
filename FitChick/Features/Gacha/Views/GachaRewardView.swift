//
//  GachaRewardView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 21/05/26.
//

import SwiftUI

struct GachaRewardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Int = 0
    let drawType: Int
    
    private var showReward: Bool { currentStep == 4 }
    
    var body: some View {
        ZStack {
            RewardAnimation()
            
            VStack(spacing: 0) {
                Color.clear
                    .frame(height: 114)
                
                Spacer()
                
                ZStack {
                    chestImageView
                }
                .frame(width: 260, height: 260)
                .rotationEffect(.degrees(currentRotationDegrees))
                .scaleEffect(currentStep == 2 ? 1.05 : 1.0)
                
                Spacer()
                
                CollectRewardButton(title: "Tap to collect") {
                    handleTapSequence()
                }

                .padding(.horizontal, 24)
                .padding(.bottom, 94)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .overlay(
            Group {
                if currentStep == 4 {
                    RewardItem()
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.8).combined(with: .opacity),
                            removal: .opacity
                        ))
                        .zIndex(1)
                }
            }
        )
        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: currentStep)
    }
    
    @ViewBuilder
    private var chestImageView: some View {
        switch currentStep {
        case 1:
            Image("ChestBox-2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .transition(.opacity)
        case 2:
            Image("ChestBox-3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .transition(.opacity)
        case 3:
            ZStack(alignment: .center) {
                Image("ChestBox-4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                // buat test pake reward coin dulu, nanti bakal ke item benerannya
                Image("RedRibbon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 90, height: 90)
                    .offset(y: -40)
            }
            .transition(.opacity)
        case 4:
            // RewardItem is presented via overlay when currentStep == 4
            EmptyView()
        default:
            EmptyView()
        }
    }
    
    
    private var currentRotationDegrees: Double {
        switch currentStep {
        case 1: return -5
        case 2: return 5
        default: return 0
        }
    }
    
    private func handleTapSequence() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.6, blendDuration: 0)) {
            if currentStep < 3 {
                currentStep += 1
            } else if currentStep == 3 {
                currentStep = 4 // trigger RewardItem presentation
            } else {
                dismiss()
            }
        }
    }
}

#Preview {
    GachaRewardView(drawType: 5)
}
