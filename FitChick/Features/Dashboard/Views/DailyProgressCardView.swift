//
//   DailyProgressCardView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI

struct DailyProgressCardView: View {
    let countText: String
    let goalText: String
    let unit: String
    let count: Double
    let goal: Double
    let rewardAmount: Int
    let onCollect: () -> Void

    init(
        count: Double,
        goal: Double,
        unit: String,
        rewardAmount: Int = 10,
        countText: String? = nil,
        goalText: String? = nil,
        onCollect: @escaping () -> Void = {}
    ) {
        self.count = count
        self.goal = goal
        self.unit = unit
        self.rewardAmount = rewardAmount
        self.countText = countText ?? DailyProgressCardView.formattedNumber(count)
        self.goalText = goalText ?? DailyProgressCardView.formattedNumber(goal)
        self.onCollect = onCollect
    }

    init(
        stepCount: Int,
        stepGoal: Int,
        rewardAmount: Int = 10,
        onCollect: @escaping () -> Void = {}
    ) {
        self.init(
            count: Double(stepCount),
            goal: Double(stepGoal),
            unit: "steps",
            rewardAmount: rewardAmount,
            countText: "\(stepCount)",
            goalText: "\(stepGoal)",
            onCollect: onCollect
        )
    }

    init(
        distanceCount: Double,
        distanceGoal: Double,
        rewardAmount: Int = 10,
        onCollect: @escaping () -> Void = {}
    ) {
        self.init(
            count: distanceCount,
            goal: distanceGoal,
            unit: "km",
            rewardAmount: rewardAmount,
            countText: DailyProgressCardView.formattedDistance(distanceCount),
            goalText: DailyProgressCardView.formattedDistance(distanceGoal),
            onCollect: onCollect
        )
    }

    private var progress: Double {
        guard goal > 0 else {
            return 0
        }

        return min(count / goal, 1)
    }

    private var isComplete: Bool {
        goal > 0 && count >= goal
    }

    private var progressStatus: String {
        if isComplete {
            return "Complete"
        }

        return "\(Int(progress * 100))%"
    }

    private var progressLabel: String {
        "\(countText) / \(goalText) \(unit)"
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack {
                    Text(progressLabel)
                        .font(AppFont.bodyBold)
                        .foregroundStyle(AppColor.neutral0)

                    Spacer()

                    Text(progressStatus)
                        .font(AppFont.bodyBold)
                        .foregroundStyle(AppColor.neutral0)
                }

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(AppColor.success50Surface)

                        Capsule()
                            .fill(AppColor.success300Main)
                            .frame(width: proxy.size.width * progress)
                    }
                }
                .frame(height: 10)
            }

            HStack {
                Spacer()

                CollectButton(amount: rewardAmount, isDisabled: !isComplete) {
                    onCollect()
                }
                .padding(.bottom, 8)
            }
        }
        .padding(16)
//        .padding(.vertical, 16)
        .frame(maxWidth: 354)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColor.primary300Main)
        }
    }

    private static func formattedNumber(_ value: Double) -> String {
        let roundedValue = value.rounded()

        guard roundedValue != value else {
            return "\(Int(roundedValue))"
        }

        return String(format: "%.1f", value)
    }

    private static func formattedDistance(_ value: Double) -> String {
        let roundedValue = (value * 10).rounded() / 10

        guard roundedValue != roundedValue.rounded() else {
            return "\(Int(roundedValue))"
        }

        return String(format: "%.1f", roundedValue)
    }
}

#Preview {
    VStack(spacing: 16) {
        DailyProgressCardView(stepCount: 4200, stepGoal: 8000)
        DailyProgressCardView(distanceCount: 2.4, distanceGoal: 5)
    }
    .padding()
    .background(AppColor.secondary50Surface)
}
