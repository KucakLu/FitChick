//
//  NamePetView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI

struct NamePetView: View {
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
                .scaleEffect(1.3)
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
    NamePetView()
}
