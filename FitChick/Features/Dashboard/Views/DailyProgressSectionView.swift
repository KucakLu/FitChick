//
//  DailyProgressSectionView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI

struct DailyProgressSectionView: View {
    @EnvironmentObject private var appState: AppStateStore

    let stepCount: Int
    let stepGoalMin: Int
    let stepGoalFine: Int
    let stepGoalGood: Int
    let stepGoalExcellent: Int
    let distanceCount: Double
    let distanceGoalMin: Double
    let distanceGoalFine: Double
    let distanceGoalGood: Double
    let distanceGoalExcellent: Double

    private let rewardAmount = 10
    
    var body: some View {
        Rectangle()
            .fill(AppColor.secondary50Surface)
            .frame(maxWidth: .infinity)
            .frame(height: 354)
            .overlay(alignment: .top) {
                VStack(spacing: 16) {
                    VStack {
                        HStack {
                            Text("Your Daily Progress")
                                .font(AppFont.title1Bold)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Small steps, big changes")
                                .font(AppFont.subheadline)
                                .foregroundColor(AppColor.neutral600Subtext)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            if !visibleStepGoals.isEmpty {
                                HStack {
                                    Text("Step")
                                        .font(AppFont.title3)
                                    Spacer()
                                }
                                .padding(.top, 8)
                                .padding(.horizontal, 24)
                                
                                VStack(spacing: 16) {
                                    ForEach(visibleStepGoals) { goal in
                                        DailyProgressCardView(
                                            count: goal.currentValue,
                                            goal: goal.targetValue,
                                            unit: goal.unit,
                                            rewardAmount: goal.rewardAmount
                                        ) {
                                            collectReward(for: goal)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 16)
                            }
                            
                            if !visibleDistanceGoals.isEmpty {
                                HStack {
                                    Text("Distance")
                                        .font(AppFont.title3)
                                    Spacer()
                                }
                                .padding(.top, visibleStepGoals.isEmpty ? 8 : 0)
                                .padding(.horizontal, 24)
                                
                                VStack(spacing: 16) {
                                    ForEach(visibleDistanceGoals) { goal in
                                        DailyProgressCardView(
                                            count: goal.currentValue,
                                            goal: goal.targetValue,
                                            unit: goal.unit,
                                            rewardAmount: goal.rewardAmount
                                        ) {
                                            collectReward(for: goal)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 32)
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.container, edges: .bottom)
    }

    private var stepGoals: [DailyProgressGoal] {
        [
            DailyProgressGoal(kind: .step, currentValue: Double(stepCount), targetValue: Double(stepGoalMin), rewardAmount: rewardAmount),
            DailyProgressGoal(kind: .step, currentValue: Double(stepCount), targetValue: Double(stepGoalFine), rewardAmount: rewardAmount),
            DailyProgressGoal(kind: .step, currentValue: Double(stepCount), targetValue: Double(stepGoalGood), rewardAmount: rewardAmount),
            DailyProgressGoal(kind: .step, currentValue: Double(stepCount), targetValue: Double(stepGoalExcellent), rewardAmount: rewardAmount)
        ]
    }

    private var distanceGoals: [DailyProgressGoal] {
        [
            DailyProgressGoal(kind: .distance, currentValue: distanceCount, targetValue: distanceGoalMin, rewardAmount: rewardAmount),
            DailyProgressGoal(kind: .distance, currentValue: distanceCount, targetValue: distanceGoalFine, rewardAmount: rewardAmount),
            DailyProgressGoal(kind: .distance, currentValue: distanceCount, targetValue: distanceGoalGood, rewardAmount: rewardAmount),
            DailyProgressGoal(kind: .distance, currentValue: distanceCount, targetValue: distanceGoalExcellent, rewardAmount: rewardAmount)
        ]
    }

    private var visibleStepGoals: [DailyProgressGoal] {
        stepGoals.filter { !isCollected($0) }
    }

    private var visibleDistanceGoals: [DailyProgressGoal] {
        distanceGoals.filter { !isCollected($0) }
    }

    private func collectReward(for goal: DailyProgressGoal) {
        guard goal.isComplete else {
            return
        }

        guard !isCollected(goal) else {
            markRewardCollected(for: goal)
            return
        }

        appState.addCoins(goal.rewardAmount)
        markRewardCollected(for: goal)
    }

    private func markRewardCollected(for goal: DailyProgressGoal) {
        appState.markDailyRewardCollected(id: goal.id, todayKey: todayKey)
    }

    private func isCollected(_ goal: DailyProgressGoal) -> Bool {
        appState.isDailyRewardCollected(id: goal.id, todayKey: todayKey)
    }

    private var todayKey: String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return [
            components.year,
            components.month,
            components.day
        ]
        .compactMap { $0 }
        .map(String.init)
        .joined(separator: "-")
    }
}

private struct DailyProgressGoal: Identifiable {
    enum Kind {
        case step
        case distance
    }

    let kind: Kind
    let currentValue: Double
    let targetValue: Double
    let rewardAmount: Int

    var id: String {
        switch kind {
        case .step:
            return "step-\(Int(targetValue.rounded()))"
        case .distance:
            return "distance-\(Int((targetValue * 10).rounded()))"
        }
    }

    var unit: String {
        switch kind {
        case .step:
            return "steps"
        case .distance:
            return "km"
        }
    }

    var isComplete: Bool {
        targetValue > 0 && currentValue >= targetValue
    }
}

#Preview {
    DailyProgressSectionView(
        stepCount: 2400,
        stepGoalMin: 4000,
        stepGoalFine: 8000,
        stepGoalGood: 10000,
        stepGoalExcellent: 12000,
        distanceCount: 2.3,
        distanceGoalMin: 3,
        distanceGoalFine: 6,
        distanceGoalGood: 8,
        distanceGoalExcellent: 10
    )
    .environmentObject(AppStateStore.preview())
}
