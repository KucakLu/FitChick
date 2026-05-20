//
//  Onboarding.swift
//  FitChick
//
//  Created by Hendra Irawan on 19/05/26.
//

import SwiftUI

struct Onboarding3: View {
    var body: some View {
        ZStack {
            AppColor.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                Image("ChickHappy2")
                Text("""
                    Enjoy the journey
                    """)
                .multilineTextAlignment(.center)
                .font(AppFont.title1Bold)
                Text("""
                    Let every step unlock something
                    delightful as you go.
                    """)
                .multilineTextAlignment(.center)
                .font(AppFont.body)
                .foregroundColor(.neutral600Subtext)
                PrimaryButton(title: "Next") {
                    print("Next tapped")
                }
            }
            .padding(.bottom, 64)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    Onboarding3()
}
