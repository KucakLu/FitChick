//
//  Onboarding.swift
//  FitChick
//
//  Created by Hendra Irawan on 19/05/26.
//

import SwiftUI

struct Onboarding1: View {
    @State private var navigationPath: [OnboardingRoute] = []

    var body: some View {
        NavigationStack(path: $navigationPath) {
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
                        navigationPath.append(.onboarding2)
                    }
                }
                .padding(.bottom, 64)
                .ignoresSafeArea()
            }
            .navigationDestination(for: OnboardingRoute.self) { route in
                switch route {
                case .onboarding2:
                    Onboarding2 {
                        navigationPath.append(.onboarding3)
                    }
                    .toolbar(.hidden, for: .navigationBar)
                case .onboarding3:
                    Onboarding3()
                    .toolbar(.hidden, for: .navigationBar)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    Onboarding1()
}

private enum OnboardingRoute: Hashable {
    case onboarding2
    case onboarding3
}
