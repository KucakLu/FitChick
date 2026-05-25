//
//  Onboarding.swift
//  FitChick
//
//  Created by Hendra Irawan on 20/05/26.
//

import SwiftUI

struct Onboarding: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    private enum Screen {
        case splash
        case onboarding1
        case dashboard
    }
    
    @State private var currentScreen: Screen = .splash

    var body: some View {
        Group {
            switch currentScreen {
            case .splash:
                onboardingContent
                    .transition(.opacity)
                    .task {
                        await showNextPageAfterDelay()
                    }
            case .onboarding1:
                Onboarding1()
                    .transition(.opacity)
            case .dashboard:
                DashboardView()
                    .transition(.opacity)
            }
        }
    }

    private var onboardingContent: some View {
        ZStack {
            AppColor.appBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image("FitChick")
                Text("""
                    Turn your daily activities into an exciting adventure
                    with your favorite chick!
                    """)
                .multilineTextAlignment(.center)
                .font(AppFont.body)
            }
            .padding()
        }
    }

    @MainActor
    private func showNextPageAfterDelay() async {
        try? await Task.sleep(nanoseconds: 3_000_000_000)

        withAnimation(.easeInOut(duration: 0.3)) {
            if isLoggedIn {
                currentScreen = .dashboard
            } else {
                currentScreen = .onboarding1
            }
        }
    }
}

#Preview {
    Onboarding()
}
