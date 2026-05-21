//
//  DashboardView.swift
//  FitChick
//
//  Created by Hendra Irawan on 21/05/26.
//

import SwiftUI

struct DashboardView: View {
    private let petMessages = [
        "Let’s walk with me!",
        "Keep going!",
        "You’re doing great!"
    ]
    private let stepGoal = 8000
    private let healthStore = HealthStore()
    
    @AppStorage("coinCount") private var coinCount = 0
    @State private var petMessageIndex = 0
    @State private var stepCount = 0
    
    private var currentPetMessage: String {
        petMessages[petMessageIndex]
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
                    .padding(.bottom, 24)
                
                DailyProgressSectionView(stepCount: stepCount, stepGoal: stepGoal)
            }
            
            
        }
        .task {
            fetchTodayStepCount()
            await rotatePetMessages()
        }
    }
    
    private func fetchTodayStepCount() {
        healthStore.fetchStepCount { steps, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            
            stepCount = Int(steps)
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
}



#Preview {
    DashboardView()
}
