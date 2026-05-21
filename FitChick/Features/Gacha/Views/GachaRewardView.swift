//
//  GachaRewardView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 21/05/26.
//

import SwiftUI

struct GachaRewardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Int = 1
    let drawType: Int
    
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
                Image("RewardCoin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 90, height: 90)
                    .offset(y: -40)
            }
            .transition(.opacity)
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
            } else {
                dismiss()
            }
        }
    }
}

#Preview {
    GachaRewardView(drawType: 5)
}
