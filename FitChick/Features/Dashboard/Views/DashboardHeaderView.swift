//
//  DashboardHeaderView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI

struct DashboardHeaderView: View {
    let coinCount: Int
    
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
                    // some action to Gatcha page
                }
                
                IconButton(icon: Image(systemName: "jacket.fill")) {
                    // some action to Customization Pet Page
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
    }
}

#Preview {
    DashboardHeaderView(coinCount: 120)
}
