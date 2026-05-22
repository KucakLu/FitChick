//
//  HatchPage4s.swift
//  FitChick
//
//  Created by Hendra Irawan on 20/05/26.
//

import SwiftUI

struct HatchPage4s: View {
    @State private var isChickVisible = false
    @State private var isChickIdleAnimating = false
    @State private var isRotating: Bool = false
    
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
            
            
            VStack() {
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
                    .frame(width: 300, height: 347)
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
        .ignoresSafeArea()
    }
}

#Preview {
    HatchPage4s()
}
