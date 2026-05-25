//
//  Onboarding.swift
//  FitChick
//
//  Created by Hendra Irawan on 19/05/26.
//

import SwiftUI

struct Onboarding3: View {
    let onSkip: () -> Void
    
    @State private var showLoginSheet = false
    @State private var shouldNavigateToConnectHealth = false
    @State private var isShowingConnectHealth = false
    
    init(onSkip: @escaping () -> Void = {}) {
        self.onSkip = onSkip
    }
    
    var body: some View {
        Group {
            if isShowingConnectHealth {
                ConnectHealthView()
                    .toolbar(.hidden, for: .navigationBar)
            } else {
                onboardingContent
            }
        }
        .sheet(isPresented: $showLoginSheet, onDismiss: {
            navigateToConnectHealthIfNeeded()
        }) {
            LoginSheetView {
                shouldNavigateToConnectHealth = true

                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 300_000_000)
                    navigateToConnectHealthIfNeeded()
                }
            }
            .presentationDetents([.height(290), .medium])
            .presentationDragIndicator(.visible)
            .interactiveDismissDisabled()
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var onboardingContent: some View {
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
                VStack(spacing: 8) {
                    PrimaryButton(title: "Next") {
                        showLoginSheet = true
                    }
                    SecondaryButton(title: "Skip") {
                        onSkip()
                    }
                }
            }
            .padding(.bottom, 64)
            .ignoresSafeArea()
        }
    }

    private func navigateToConnectHealthIfNeeded() {
        guard shouldNavigateToConnectHealth else { return }

        shouldNavigateToConnectHealth = false
        isShowingConnectHealth = true
    }
}

#Preview {
    Onboarding3()
}
