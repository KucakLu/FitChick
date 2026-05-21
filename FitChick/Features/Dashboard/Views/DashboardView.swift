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
            
            HStack {
                Image("RewardCoin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36)
                    
//                Text("\(User.current.points)")
                Text("897")
                    .font(AppFont.title1Bold)
                    .foregroundColor(AppColor.secondary500Dark)
            }
            
            
        }
    }
}

#Preview {
    DashboardView()
}

