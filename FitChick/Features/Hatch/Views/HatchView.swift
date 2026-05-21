//
//  HatchView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 20/05/26.
//

import SwiftUI
internal import Combine

struct HatchView: View {
    @State private var currentStage = 0
    @State private var isRotating: Bool = false
    
    let eggStages = ["EggStage1", "EggStage2", "EggStage3", "EggStage4"]
    let timer = Timer.publish(every: 2.0, on: .main, in: .common).autoconnect()
    
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
            
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    Text("Hatch Me!")
                        .font(AppFont.largeTitleBold)
                        .foregroundColor(AppColor.secondary500Dark)
                    
                    Text("You almost there")
                        .font(AppFont.body)
                        .foregroundColor(AppColor.secondary500Dark)
                }
                .padding(.top, 80)
                
                Spacer()
                
                ZStack(alignment: .bottom) {
                    Image("Nest")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 153)
                        .offset(y: 23)
                    
                    Image(eggStages[currentStage])
                        .resizable()
                        .scaledToFill()
                        .offset(y: -20)
                        .frame(width: 345, height: 340)
                        .zIndex(1)
                        .id(currentStage)
                        .transition(.opacity)
                }
                
                Spacer()
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 1)) {
                if currentStage < eggStages.count - 1 {
                    currentStage += 1
                } else {
                    // muncul pet nya deh
                }
            }
        }
    }
}

#Preview {
    HatchView()
}
