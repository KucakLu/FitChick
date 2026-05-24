//
//  SkipView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 24/05/26.
//

import SwiftUI

struct SkipView: View {
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
                                .font(AppFont.body)
                                .foregroundColor(AppColor.neutral600Subtext)
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
                            print("Login tapped")
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
    }
}

#Preview {
    SkipView()
}
