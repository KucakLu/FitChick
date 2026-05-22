//
//  HatchView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 20/05/26.
//

import SwiftUI

struct HatchView: View {
    @State private var isRotating: Bool = false
    @State private var hasCompletedHatch: Bool = false
    @State private var isChickVisible = false
    @State private var isChickIdleAnimating = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppColor.secondary0Surface,
                    AppColor.secondary300Main
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Image("RewardBg")
                .scaleEffect(hasCompletedHatch ? 1.1 : 1.3)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
                .animation(
                    .linear(duration: 3)
                    .repeatForever(autoreverses: false),
                    value: isRotating
                )
                .onAppear {
                    isRotating = true
                }
                .ignoresSafeArea()
            
            if hasCompletedHatch {
                hatchedPetContent
            } else {
                hatchAnimationContent
            }
        }
    }
    
    private var hatchAnimationContent: some View {
        VStack {
            VStack(spacing: 12) {
                Text("Hatch Me!")
                    .font(AppFont.largeTitleBold)
                    .foregroundColor(AppColor.secondary500Dark)
                
                Text("You almost there")
                    .font(AppFont.body)
                    .foregroundColor(AppColor.secondary500Dark)
            }
            .padding(.top, 80)
            .padding(.bottom, 180)
            
//                Spacer()
            
            HatchAnimationView(isPlaying: hasCompletedHatch == false) {
                hasCompletedHatch = true
            }
                .frame(width: 360, height: 203)
//                    .offset(y: 10)
            
            Spacer()
        }
    }
    
    private var hatchedPetContent: some View {
        VStack {
            Text("Congratulation")
                .font(AppFont.largeTitleBold)
                .foregroundStyle(AppColor.secondary500Dark)
            Text("you get your pet")
                .font(AppFont.body)
                .foregroundStyle(AppColor.secondary500Dark)
                .padding(.bottom, 75)
            Image("ChickIddle")
                .resizable()
                .scaledToFit()
                .frame(width: 270, height: 312.3)
                .scaleEffect(isChickVisible ? (isChickIdleAnimating ? 1.08 : 1) : 0.7)
                .opacity(isChickVisible ? 1 : 0)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.45)) {
                        isChickVisible = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            isChickIdleAnimating = true
                        }
                    }
                }
            Spacer()
        }
        .padding(.top, 128)
        .ignoresSafeArea()
    }
}

#Preview {
    HatchView()
}
