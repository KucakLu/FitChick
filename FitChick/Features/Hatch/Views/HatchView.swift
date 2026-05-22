//
//  HatchView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 20/05/26.
//

import SwiftUI

struct HatchView: View {
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
            
            VStack{
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
                
                HatchAnimationView()
                    .frame(width: 360, height: 203)
//                    .offset(y: 10)
                
                Spacer()
            }
        }
    }
}

#Preview {
    HatchView()
}
