//
//  DashboardView.swift
//  FitChick
//
//  Created by Hendra Irawan on 21/05/26.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @EnvironmentObject private var appState: AppStateStore
    
    private let stepGoalMin = 4000
    private let stepGoalFine = 8000
    private let stepGoalGood = 10000
    private let stepGoalExcellent = 12000

    private let distanceGoalMin = 3.0
    private let distanceGoalFine = 6.0
    private let distanceGoalGood = 8.0
    private let distanceGoalExcellent = 10.0
    
    private let stepGoal = 8000
    private let distanceGoal = 5.0
    private let healthStore = HealthStore()
    
    @Query private var users: [UserAccount]
    @State private var dailyMissionCoordinator = DailyMissionCoordinator()
    @State private var petMessageIndex = 0
    @State private var stepCount = 0
    @State private var distanceCount = 0.0
    @State private var navigateToGachaPage = false
    @State private var navigateToDressUpPage = false
    @State private var pendingDailyMissionUpdate: Task<Void, Never>?
    
    private var petMessages: [String] {
        [
            "Hello my name is \(currentPetName)",
            "Let’s walk with me!",
            "You’re doing great!",
            "Ready to move with me?",
            "Let’s start our little adventure!",
            "Your walking buddy is here!",
            "Cluck cluck! I’m ready!",
            "Today feels like a good day to move!",
            "Let’s make today healthier!",
            "Just a short walk?",
            "Come on, let’s stretch a little!",
            "Your body needs a tiny boost!",
            "Let’s move before we get sleepy!",
            "I believe you can start small!",
            "Five minutes is enough to begin!",
            "Let’s shake off the lazy mood!",
        ]
    }

    private var currentPetMessage: String {
        petMessages[petMessageIndex]
    }

    private var currentPetName: String {
        let savedPetName = currentUser?.petName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let savedPetName, !savedPetName.isEmpty else {
            return "Chick"
        }

        return savedPetName
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                AppColor.dashboardBackground
                    .ignoresSafeArea()

                Image("Spotlight")
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    DashboardHeaderView(
                        coinCount: appState.coinCount,
                        onBoxTapped: {
                            PerformanceProbe.event("RouteDashboardToGacha")
                            navigateToGachaPage = true
                        },
                        onClosetTapped: {
                            PerformanceProbe.event("RouteDashboardToDressUp")
                            navigateToDressUpPage = true
                        }
                    )

                    BubbleChatView(message: currentPetMessage)

                   PetPreviewCard()
                        Spacer()
                    
                    DailyProgressSectionView(
                        stepCount: stepCount,
                        stepGoalMin: stepGoalMin,
                        stepGoalFine: stepGoalFine,
                        stepGoalGood: stepGoalGood,
                        stepGoalExcellent: stepGoalExcellent,
                        distanceCount: distanceCount,
                        distanceGoalMin: distanceGoalMin,
                        distanceGoalFine: distanceGoalFine,
                        distanceGoalGood: distanceGoalGood,
                        distanceGoalExcellent: distanceGoalExcellent
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.container, edges: .bottom)
            .navigationDestination(isPresented: $navigateToGachaPage) {
                GachaView()
            }
            .navigationDestination(isPresented: $navigateToDressUpPage) {
                // nanti ganti ke dress up page
                DressUpPageView()
                    .toolbar(.hidden, for: .navigationBar)
            }
            .onAppear {
                PerformanceProbe.event("DashboardAppear")
            }
            .onDisappear {
                PerformanceProbe.event("DashboardDisappear")
                pendingDailyMissionUpdate?.cancel()
                pendingDailyMissionUpdate = nil
            }
            
        }
        .task {
            await PerformanceProbe.measure("DashboardFetchTodayProgress") {
                await fetchTodayActivityProgress()
            }
        }
        .task {
            await PerformanceProbe.measure("DashboardObserveStepUpdates") {
                await observeStepCountUpdates()
            }
        }
        .task {
            await PerformanceProbe.measure("DashboardObserveDistanceUpdates") {
                await observeDistanceUpdates()
            }
        }
        .task {
            await PerformanceProbe.measure("DashboardRotatePetMessages") {
                await rotatePetMessages()
            }
        }
    }
    
    @MainActor
    private func fetchTodayActivityProgress() async {
        do {
            let steps = try await healthStore.fetchStepCount()
            stepCount = Int(steps)
        } catch {
            print(error.localizedDescription)
        }

        do {
            distanceCount = try await healthStore.fetchWalkingRunningDistance()
        } catch {
            print(error.localizedDescription)
        }

        await updateDailyMissionProgress()
    }

    @MainActor
    private func observeStepCountUpdates() async {
        for await steps in healthStore.stepCountUpdates() {
            PerformanceProbe.event("HealthStepUpdate")
            stepCount = Int(steps)
            scheduleDailyMissionProgressUpdate()
        }
    }

    @MainActor
    private func observeDistanceUpdates() async {
        for await distance in healthStore.walkingRunningDistanceUpdates() {
            PerformanceProbe.event("HealthDistanceUpdate")
            distanceCount = distance
            scheduleDailyMissionProgressUpdate()
        }
    }
    
    @MainActor
    private func rotatePetMessages() async {
        guard petMessages.count > 1 else {
            return
        }
        
        while !Task.isCancelled {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            
            guard !Task.isCancelled else {
                return
            }
            
            petMessageIndex = (petMessageIndex + 1) % petMessages.count
        }
    }

    private var currentUser: UserAccount? {
        guard let userId = KeychainManager.shared.retrieve(key: "appleUserId") else {
            return users.first
        }

        return users.first { $0.userId == userId } ?? users.first
    }

    private var stepTargets: [Int] {
        [
            stepGoalFine,
            stepGoalGood,
            stepGoalExcellent
        ]
    }

    private var distanceTargets: [Double] {
        [
            distanceGoalFine,
            distanceGoalGood,
            distanceGoalExcellent
        ]
    }

    @MainActor
    private func updateDailyMissionProgress() async {
        await PerformanceProbe.measure("DailyMissionHandleProgress") {
            await dailyMissionCoordinator.handleProgress(
                steps: stepCount,
                distance: distanceCount,
                stepTargets: stepTargets,
                distanceTargets: distanceTargets
            )
        }
    }

    @MainActor
    private func scheduleDailyMissionProgressUpdate() {
        pendingDailyMissionUpdate?.cancel()
        pendingDailyMissionUpdate = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 350_000_000)

            guard !Task.isCancelled else {
                return
            }

            await updateDailyMissionProgress()
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: UserAccount.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    DashboardView()
        .modelContainer(container)
        .environmentObject(AppStateStore.preview())
}
