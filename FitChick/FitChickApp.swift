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
        }
        .modelContainer(for: UserAccount.self)
    }
}
