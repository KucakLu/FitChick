//
//  NamePetView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI
import SwiftData
import UIKit

struct NamePetView: View {
    @State private var isKeyboardVisible = false

    var body: some View {
        ZStack {
            RewardBg()

            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Text("Congratulation")
                            .font(AppFont.largeTitleBold)
                            .foregroundStyle(AppColor.secondary500Dark)
                        Text("you get your pet")
                            .font(AppFont.body)
                            .foregroundStyle(AppColor.secondary500Dark)
                            .padding(.bottom, 64)
                        Image("ChickIddle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 270, height: 312.3)
                        Spacer()
                        NamePetCard()
                    }
                    .frame(minHeight: geometry.size.height - 176)
                    .padding(.top, 120)
                    .padding(.bottom, isKeyboardVisible ? 180 : 56)
                    .frame(maxWidth: .infinity)
                    .offset(y: isKeyboardVisible ? -132 : 0)
                    .animation(.easeOut(duration: 0.25), value: isKeyboardVisible)
                }
                .scrollIndicators(.hidden)
            }
        }
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
}


#Preview {
    let container = try! ModelContainer(
        for: UserAccount.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    NamePetView()
        .modelContainer(container)
}
