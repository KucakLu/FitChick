//
//  DashboardHeaderView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI

struct DashboardHeaderView: View {
    let coinCount: Int
    let onBoxTapped: () -> Void
    let onClosetTapped: () -> Void

    init(
        coinCount: Int,
        onBoxTapped: @escaping () -> Void = {},
        onClosetTapped: @escaping () -> Void = {}
    ) {
        self.coinCount = coinCount
        self.onBoxTapped = onBoxTapped
        self.onClosetTapped = onClosetTapped
    }
    
    var body: some View {
        HStack {
            HStack {
                Image("RewardCoin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36)
                
                Text("\(coinCount)")
                    .font(AppFont.title1Bold)
                    .foregroundColor(AppColor.secondary500Dark)
            }
            
            Spacer()
            
            HStack {
                IconButton(icon: Image(systemName: "shippingbox.fill")) {
                    onBoxTapped()
                }
                
                IconButton(icon: Image(systemName: "jacket.fill")) {
                    onClosetTapped()
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
    }
}

#Preview {
    DashboardHeaderView(
        coinCount: 120,
        onBoxTapped: {
            print("Bag tapped")
        },
        onClosetTapped: {
            print("Closet tapped")
        }
    )
}
