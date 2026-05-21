//
//  DashboardView.swift
//  FitChick
//
//  Created by Hendra Irawan on 21/05/26.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        ZStack {
            AppColor.dashboardBackground.edgesIgnoringSafeArea(.all)
        
            dashboardHeader()
            
            
        }
    }
}

private func dashboardHeader() -> some View {
    HStack {
        HStack {
            Image("RewardCoin")
                .resizable()
                .scaledToFit()
                .frame(width: 36)
            
            //Text("\(User.current.points)")
            Text("897")
                .font(AppFont.title1Bold)
                .foregroundColor(AppColor.secondary500Dark)
        }
        Spacer()
        HStack {
            IconButton(icon: Image(systemName: "shippingbox.fill")) {
                //some action to Gatcha page
            }
            IconButton(icon: Image(systemName: "jacket.fill")) {
                //some action to Customization Pet Page
            }
        }
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 8)
}

private func bubbleChat() -> some View {
    VStack{
        
    }
}


#Preview {
    DashboardView()
}

