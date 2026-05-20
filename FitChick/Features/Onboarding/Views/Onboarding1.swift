//
//  Onboarding.swift
//  FitChick
//
//  Created by Hendra Irawan on 19/05/26.
//

import SwiftUI

struct Onboarding1: View {
    @State private var isShowingOnboarding2 = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    Image("ChickWink")
                    Text("""
                        Every step brings a surprise
                        """)
                    .multilineTextAlignment(.center)
                    .font(AppFont.title1Bold)
                    Text("""
                        Turn your daily walks 
                        into a fun journey filled with little rewards.
                        """)
                    .multilineTextAlignment(.center)
                    .font(AppFont.body)
                    .foregroundColor(.neutral600Subtext)
                    PrimaryButton(title: "Next") {
                        isShowingOnboarding2 = true
                    }
                }
                .padding(.bottom, 64)
                .ignoresSafeArea()
            }
            .navigationDestination(isPresented: $isShowingOnboarding2) {
                Onboarding2()
                    .toolbar(.hidden, for: .navigationBar)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    Onboarding1()
}
