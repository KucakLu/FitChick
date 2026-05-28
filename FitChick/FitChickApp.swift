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
    @UIApplicationDelegateAdaptor(FitChickAppDelegate.self) private var appDelegate
    @StateObject private var router = AppRouter()
    @StateObject private var appState = AppStateStore.shared

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(router)
                .environmentObject(appState)
                .task(priority: .utility) {
                    PerformanceProbe.measure("AppLaunchPreload") {
                        SoundManager.shared.preload()
                        GIFAnimationCache.shared.preloadBundleResources([
                            (name: "PetBlinkAnimation", fileExtension: "gif"),
                            (name: "BlackHatPetAnimation", fileExtension: "gif")
                        ])
                        GIFAnimationCache.shared.preloadDataAssets([
                            "HatchAnimation"
                        ])
                    }
                }
        }
        .modelContainer(for: UserAccount.self)
    }
}
