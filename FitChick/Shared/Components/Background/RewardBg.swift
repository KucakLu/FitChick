//
//  RewardBg.swift
//  FitChick
//
//  Created by Hendra Irawan on 23/05/26.
//

import SwiftUI

struct RewardBg: View {
    @State private var isRotating = false
    let imageName: String
    let scale: CGFloat

    init(imageName: String = "RewardBg", scale: CGFloat = 1.3) {
        self.imageName = imageName
        self.scale = scale
    }

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

            Image(imageName)
                .scaleEffect(scale)
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
        }
    }
}

#Preview {
    RewardBg()
}
