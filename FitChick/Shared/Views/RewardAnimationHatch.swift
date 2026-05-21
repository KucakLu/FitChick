//
//  RewardAnimationHatch.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 21/05/26.
//

import SwiftUI

struct RewardAnimationHatch: View {
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
            Image("OvalReward")
                .scaleEffect(1.6)
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
            
        }
    }
}

#Preview {
    RewardAnimationHatch()
}
