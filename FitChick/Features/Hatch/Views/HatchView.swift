//
//  HatchView.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 20/05/26.
//

import SwiftUI
import SwiftData
import UIKit

struct HatchView: View {
    @State private var hasCompletedHatch: Bool = false
    @State private var isNamePetCardVisible = false
    @State private var isChickVisible = false
    @State private var isChickIdleAnimating = false
    @State private var isKeyboardVisible = false

    private let namePetCardID = "namePetCard"

    var body: some View {
        ZStack {
            RewardBg(scale: hasCompletedHatch ? 1.1 : 1.3)

            if hasCompletedHatch {
                hatchedPetContent
                    .contentShape(Rectangle())
                    .onTapGesture(perform: showNamePetCard)
            } else {
                hatchAnimationContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            for await _ in NotificationCenter.default.notifications(named: UIResponder.keyboardWillShowNotification) {
                isKeyboardVisible = true
            }
        }
        .task {
            for await _ in NotificationCenter.default.notifications(named: UIResponder.keyboardWillHideNotification) {
                isKeyboardVisible = false
            }
        }
    }

    private func showNamePetCard() {
        guard isNamePetCardVisible == false else { return }

        withAnimation(.easeOut(duration: 0.25)) {
            isNamePetCardVisible = true
        }
    }

    private var hatchAnimationContent: some View {
        VStack {
            VStack(spacing: 12) {
                Text("Hatch Me!")
                    .font(AppFont.largeTitleBold)
                    .foregroundColor(AppColor.secondary500Dark)

                Text("You almost there")
                    .font(AppFont.body)
                    .foregroundColor(AppColor.secondary500Dark)
            }
            .padding(.top, 80)
            .padding(.bottom, 180)

            //                Spacer()

            HatchAnimationView(isPlaying: hasCompletedHatch == false) {
                hasCompletedHatch = true
            }
            .frame(width: 360, height: 203)
            //                    .offset(y: 10)

            Spacer()
        }
    }

    private var hatchedPetContent: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        Text("Congratulation")
                            .font(AppFont.largeTitleBold)
                            .foregroundStyle(AppColor.secondary500Dark)

                        Text("you get your pet")
                            .font(AppFont.body)
                            .foregroundStyle(AppColor.secondary500Dark)
                            .padding(.bottom, 75)

                        Image("ChickIddle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 270, height: 312.3)
                            .scaleEffect(isChickVisible ? (isChickIdleAnimating ? 1.08 : 1) : 0.7)
                            .opacity(isChickVisible ? 1 : 0)
                            .onAppear {
                                withAnimation(.easeOut(duration: 0.45)) {
                                    isChickVisible = true
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                        isChickIdleAnimating = true
                                        SoundManager.shared.playGetPetSound()
                                    }
                                }
                            }

                        Spacer()

                        if isNamePetCardVisible {
                            NamePetCard(autoFocus: false)
                                .id(namePetCardID)
                                .padding(.horizontal, 16)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .zIndex(1)
                        }
                    }
                    .frame(minHeight: geometry.size.height - 176)
                    .padding(.top, 128)
                    .padding(.bottom, isKeyboardVisible ? 180 : 56)
                    .frame(maxWidth: .infinity)
                    .offset(y: isKeyboardVisible ? -162 : 0)
                    .animation(.easeOut(duration: 0.25), value: isKeyboardVisible)
                    .animation(.easeOut(duration: 0.25), value: isNamePetCardVisible)
                }
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: isNamePetCardVisible) { _, isVisible in
                    guard isVisible else { return }

                    scrollToNamePetCard(with: proxy)
                }
                .onChange(of: isKeyboardVisible) { _, isVisible in
                    guard isVisible, isNamePetCardVisible else { return }

                    scrollToNamePetCard(with: proxy)
                }
            }
        }
    }

    private func scrollToNamePetCard(with proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo(namePetCardID, anchor: .bottom)
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: UserAccount.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    HatchView()
        .modelContainer(container)
}
