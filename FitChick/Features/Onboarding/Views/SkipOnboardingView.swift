//
//  SkipView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 24/05/26.
//

import SwiftUI

struct SkipOnboardingView: View {
    @State private var showLoginSheet = false
    @State private var shouldNavigateToConnectHealth = false
    @State private var navigateToConnectHealth = false

    var body: some View {
        ZStack(alignment: .top) {
            AppColor.dashboardBackground
                .ignoresSafeArea()

            Image("Spotlight")
                .ignoresSafeArea()

            VStack(spacing: 0) {

                DashboardHeaderView(coinCount: 0)

                Spacer(minLength: 15)

                ZStack {
                    Image("ShadowSpotlight")
                        .offset(y: 100)

                    Image("EggStage1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270, height: 300)
                        .hatchingEggWiggle()
                        .offset(y: -10)
                }

                Spacer(minLength: 24)

                VStack(alignment: .leading, spacing: 20) {

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Your Daily Progress")
                            .font(AppFont.title1Bold)
                            .foregroundStyle(AppColor.neutral800Text)

                        Text("Small steps, big changes")
                            .font(AppFont.subhead)
                            .foregroundColor(AppColor.neutral600Subtext)
                    }

                    VStack(spacing: 16) {

                        VStack(spacing: 12) {

                            Text("Your egg is waiting to hatch!")
                                .font(AppFont.bodyBold)
                                .foregroundColor(AppColor.neutral800Text)
                                .multilineTextAlignment(.center)

                            Text("""
                            Sign in and connect your Health
                            data to unlocking your first pet
                            and get the exciting collectible items!
                            """)
                            .font(AppFont.body)
                            .foregroundColor(AppColor.neutral600Subtext)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white)
                        )

                        SecondaryButton(title: "Login") {
                            showLoginSheet = true
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColor.primary300Main)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppColor.appBackground)
            }
        }
        .toolbar(.hidden, for: .navigationBar)

        .navigationDestination(isPresented: $navigateToConnectHealth) {
            ConnectHealthView()
                .toolbar(.hidden, for: .navigationBar)
        }

        .sheet(isPresented: $showLoginSheet, onDismiss: {
            guard shouldNavigateToConnectHealth else { return }

            shouldNavigateToConnectHealth = false
            PerformanceProbe.event("RouteSkipToConnectHealth")
            navigateToConnectHealth = true
        }) {
            LoginSheetView {
                shouldNavigateToConnectHealth = true
            }
            .presentationDetents([.height(290), .medium])
            .presentationDragIndicator(.visible)
        }
    }
}

private struct EggWiggleValues {
    var rotationDegrees = 0.0
    var horizontalOffset = 0.0
}

private extension View {
    func hatchingEggWiggle() -> some View {
        keyframeAnimator(initialValue: EggWiggleValues(), repeating: true) { content, value in
            content
                .rotationEffect(.degrees(value.rotationDegrees), anchor: .bottom)
                .offset(x: value.horizontalOffset)
        } keyframes: { _ in
            KeyframeTrack(\.rotationDegrees) {
                CubicKeyframe(-1.4, duration: 0.35)
                CubicKeyframe(1.2, duration: 0.45)
                CubicKeyframe(-1.6, duration: 0.50)
                CubicKeyframe(1.4, duration: 0.50)
                CubicKeyframe(-1.0, duration: 0.45)
                CubicKeyframe(0.8, duration: 0.40)
                CubicKeyframe(0.0, duration: 0.35)
                LinearKeyframe(0.0, duration: 1.05)
                CubicKeyframe(-2.5, duration: 0.18)
                CubicKeyframe(3.0, duration: 0.17)
                CubicKeyframe(-7.5, duration: 0.12)
                CubicKeyframe(7.0, duration: 0.13)
                CubicKeyframe(-8.5, duration: 0.12)
                CubicKeyframe(8.0, duration: 0.13)
                CubicKeyframe(-6.0, duration: 0.14)
                CubicKeyframe(5.0, duration: 0.14)
                CubicKeyframe(-2.6, duration: 0.18)
                CubicKeyframe(0.0, duration: 0.24)
            }

            KeyframeTrack(\.horizontalOffset) {
                CubicKeyframe(-0.8, duration: 0.35)
                CubicKeyframe(0.7, duration: 0.45)
                CubicKeyframe(-0.9, duration: 0.50)
                CubicKeyframe(0.8, duration: 0.50)
                CubicKeyframe(-0.6, duration: 0.45)
                CubicKeyframe(0.5, duration: 0.40)
                CubicKeyframe(0.0, duration: 0.35)
                LinearKeyframe(0.0, duration: 1.05)
                CubicKeyframe(-1.8, duration: 0.18)
                CubicKeyframe(2.0, duration: 0.17)
                CubicKeyframe(-5.0, duration: 0.12)
                CubicKeyframe(5.0, duration: 0.13)
                CubicKeyframe(-6.0, duration: 0.12)
                CubicKeyframe(6.0, duration: 0.13)
                CubicKeyframe(-4.0, duration: 0.14)
                CubicKeyframe(3.5, duration: 0.14)
                CubicKeyframe(-1.8, duration: 0.18)
                CubicKeyframe(0.0, duration: 0.24)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SkipOnboardingView()
    }
}
