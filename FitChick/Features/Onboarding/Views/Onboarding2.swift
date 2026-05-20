//
//  Onboarding.swift
//  FitChick
//
//  Created by Hendra Irawan on 19/05/26.
//

import SwiftUI

struct Onboarding2: View {
    @State private var isShowingOnboarding3 = false

    var body: some View {
        ZStack {
            AppColor.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                Image("ChickHappy")
                Text("""
                    Collect along the way
                    """)
                .multilineTextAlignment(.center)
                .font(AppFont.title1Bold)
                Text("""
                    The more you move, 
                    the more unique items you can discover.
                    """)
                .multilineTextAlignment(.center)
                .font(AppFont.body)
                .foregroundColor(.neutral600Subtext)
                PrimaryButton(title: "Next") {
                    isShowingOnboarding3 = true
                }
            }
            .padding(.bottom, 64)
            .ignoresSafeArea()
        }
        .navigationDestination(isPresented: $isShowingOnboarding3) {
            Onboarding3()
                .toolbar(.hidden, for: .navigationBar)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    Onboarding2()
}
