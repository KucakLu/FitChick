//
//  DashboardView.swift
//  FitChick
//
//  Created by Hendra Irawan on 21/05/26.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    private let stepGoal = 8000
    private let healthStore = HealthStore()
    
    @Query private var users: [UserAccount]
    @AppStorage("coinCount") private var coinCount = 0
    @State private var petMessageIndex = 0
    @State private var stepCount = 0
    
    private var petMessages: [String] {
        [
            "Hallo my name is \(currentPetName)",
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
        ZStack(alignment: .top) {
            AppColor.dashboardBackground.edgesIgnoringSafeArea(.all)
            Image("Spotlight")
                .ignoresSafeArea()
            
            VStack {
                DashboardHeaderView(coinCount: coinCount)
                BubbleChatView(message: currentPetMessage)
                
                PetPreviewCard()
                    .frame(width: 360, height: 260)
//                    .padding(.bottom, 8)
                
                DailyProgressSectionView(stepCount: stepCount, stepGoal: stepGoal)
            }
            
            
        }
        .task {
            await fetchTodayStepCount()
            await rotatePetMessages()
        }
    }
    
    private func fetchTodayStepCount() async {
        do {
            let steps = try await healthStore.fetchStepCount()
            stepCount = Int(steps)
        } catch {
            print(error.localizedDescription)
        }
    }
    
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
}



#Preview {
    let container = try! ModelContainer(
        for: UserAccount.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    DashboardView()
        .modelContainer(container)
}
