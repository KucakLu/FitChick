//
//  Onboarding.swift
//  FitChick
//
//  Created by Hendra Irawan on 20/05/26.
//

import SwiftUI

struct Onboarding: View {
    @State private var isShowingOnboarding1 = false

    var body: some View {
        if isShowingOnboarding1 {
            Onboarding1()
                .transition(.opacity)
        } else {
            onboardingContent
                .transition(.opacity)
                .task {
                    await showNextPageAfterDelay()
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
            isShowingOnboarding1 = true
        }
    }
}

#Preview {
    Onboarding()
}
