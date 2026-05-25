//
//  RewardItem.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 22/05/26.
//

import SwiftUI

struct RewardItem: View {
    @State private var isRotating: Bool = true
    @State private var navigateToDashboard: Bool = false
    
    let item: CollectionItem
    
    var body: some View {
        ZStack {
            RewardAnimation()
            
            VStack {
                Text("Congratulations\nyou got a")
                    .font(AppFont.largeTitleBold)
                    .foregroundColor(AppColor.secondary500Dark)
                    .padding(.bottom, 130)
                    .multilineTextAlignment(.center)
                
                ZStack {
                    VStack {
                        Image(item.svgAssetName)
                            .resizable()
                            .frame(width: 234, height: 234)
                            .rotationEffect(isRotating ? Angle(degrees: 25) : Angle(degrees: -25))
                            .animation(
                                .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                                value: isRotating
                            )
                    }
                }
                .padding(.bottom, 100)
                
                Text(item.name.capitalized)
                    .font(AppFont.largeTitleBold)
                    .foregroundColor(AppColor.secondary500Dark)
                
                CollectRewardButton(title: "Tap to collect") {
                    navigateToDashboard = true
                }
                .fullScreenCover(isPresented: $navigateToDashboard) {
                    DashboardView()
                }
                .padding(.top, 20)
            }
            .onAppear {
                isRotating.toggle()
            }
        }
    }
}

#Preview {
    let sampleItem = CollectionData.items[0]
    
    return RewardItem(item: sampleItem)
}
