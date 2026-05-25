//
//  FitChickApp.swift
//  FitChick
//
//  Created by Hendra Irawan on 19/05/26.
//

import SwiftUI
import SwiftData

@main
struct FitChickApp: App {
    var body: some Scene {
        WindowGroup {
            Onboarding()
//            ZStack {
//                Color.clear
//                    .contentShape(Rectangle())
//                    .ignoresSafeArea()
//                    .onTapGesture {
//                        UIApplication.shared.sendAction(
//                            #selector(UIResponder.resignFirstResponder),
//                            to: nil,
//                            from: nil,
//                            for: nil
//                        )
//                    }
//
//                NamePetCard()
//            }
        }
        .modelContainer(for: UserAccount.self)
    }
}
