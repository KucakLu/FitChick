//
//  DashboardView.swift
//  FitChick
//
//  Created by Hendra Irawan on 21/05/26.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    
    
    private let stepGoalFine = 8000
    private let stepGoalGood = 10000
    private let stepGoalExcellent = 12000

    
    private let distanceGoalFine = 6.0
    private let distanceGoalGood = 8.0
    private let distanceGoalExcellent = 10.0
    
    private let stepGoal = 8000
    private let distanceGoal = 5.0
    private let healthStore = HealthStore()
    
    @Query private var users: [UserAccount]
    @AppStorage("coinCount") private var coinCount = 0
    @State private var dailyMissionCoordinator = DailyMissionCoordinator()
    @State private var petMessageIndex = 0
    @State private var stepCount = 0
    @State private var distanceCount = 0.0
    @State private var navigateToGachaPage = false
    @State private var navigateToDressUpPage = false
    
    private var petMessages: [String] {
        [
            "Hello my name is \(currentPetName)",
            "Let’s walk with me!",
            "Keep going!",
            "You’re doing great!"
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
                        coinCount: coinCount,
                        onBoxTapped: {
                            navigateToGachaPage = true
                        },
                        onClosetTapped: {
                            navigateToDressUpPage = true
                        }
                    )

                    BubbleChatView(message: currentPetMessage)

                   PetPreviewCard()
                        Spacer()
                    
                    DailyProgressSectionView(
                        stepCount: stepCount,
                        stepGoalFine: stepGoalFine,
                        stepGoalGood: stepGoalGood,
                        stepGoalExcellent: stepGoalExcellent,
                        distanceCount: distanceCount,
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
            
        }
        .task {
            await fetchTodayActivityProgress()
        }
        .task {
            await observeStepCountUpdates()
        }
        .task {
            await observeDistanceUpdates()
        }
        .task {
            await rotatePetMessages()
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
            stepCount = Int(steps)
            await updateDailyMissionProgress()
        }
    }

    @MainActor
    private func observeDistanceUpdates() async {
        for await distance in healthStore.walkingRunningDistanceUpdates() {
            distanceCount = distance
            await updateDailyMissionProgress()
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
        await dailyMissionCoordinator.handleProgress(
            steps: stepCount,
            distance: distanceCount,
            stepTargets: stepTargets,
            distanceTargets: distanceTargets
        )
    }
}

#Preview {
    let container = try! ModelContainer(
        for: UserAccount.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    DashboardView()
        .modelContainer(container)
}
