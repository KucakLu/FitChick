//
//  DailyMissionLiveActivity.swift
//  DailyMissionWidget
//
//  Created by Codex on 26/05/26.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct DailyMissionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DailyMissionActivityAttributes.self) { context in
            DailyMissionLockScreenView(context: context)
                .activityBackgroundTint(Color(red: 1.0, green: 0.94, blue: 0.74))
                .activitySystemActionForegroundColor(Color(red: 0.25, green: 0.18, blue: 0.10))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    ChickBadge()
                }

                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.trailingText(for: context.attributes))
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .monospacedDigit()
                }

                DynamicIslandExpandedRegion(.bottom) {
                    DailyMissionExpandedView(context: context)
                }
            } compactLeading: {
                ChickBadge(size: 24)
            } compactTrailing: {
                Text(context.state.compactText(for: context.attributes))
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .monospacedDigit()
            } minimal: {
                Text("🐥")
            }
            .keylineTint(Color(red: 1.0, green: 0.77, blue: 0.23))
        }
    }
}

struct DailyMissionLockScreenView: View {
    let context: ActivityViewContext<DailyMissionActivityAttributes>

    var body: some View {
        HStack(spacing: 12) {
            ChickBadge(size: 42)

            DailyMissionExpandedView(context: context)
        }
        .padding(16)
    }
}

struct DailyMissionExpandedView: View {
    let context: ActivityViewContext<DailyMissionActivityAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(.headline, design: .rounded, weight: .bold))

            Text(progressText)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .monospacedDigit()

            Text(detailText)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
    }

    private var title: String {
        switch context.state.phase {
        case .completed:
            return "Mission complete!"
        case .kickoff, .nearGoal:
            return "Daily Mission"
        }
    }

    private var progressText: String {
        switch context.state.phase {
        case .completed, .kickoff:
            return context.state.message
        case .nearGoal:
            return "\(context.attributes.kind.formattedValue(context.state.currentValue)) / \(context.attributes.kind.formattedValue(context.attributes.targetValue)) \(context.attributes.kind.unitText)"
        }
    }

    private var detailText: String {
        switch context.state.phase {
        case .completed:
            return "\(context.state.message) 🎉"
        case .kickoff:
            return context.state.message
        case .nearGoal:
            let remainingText = context.state.remainingText(for: context.attributes.kind)
            return "\(remainingText) \(context.attributes.kind.unitText) lagi untuk +\(context.attributes.rewardCoin) coin"
        }
    }
}

struct ChickBadge: View {
    var size: CGFloat = 32

    var body: some View {
        Text("🐥")
            .font(.system(size: size * 0.68))
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(Color(red: 1.0, green: 0.83, blue: 0.31))
            )
            .overlay(
                Circle()
                    .stroke(Color(red: 0.76, green: 0.46, blue: 0.12), lineWidth: 1)
            )
    }
}

struct DailyMissionPushNotificationPreview: View {
    let title: String
    let notificationBody: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ChickBadge(size: 36)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded, weight: .bold))

                Text(notificationBody)
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 8)
        }
        .padding(14)
        .frame(maxWidth: 360)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding()
        .background(Color.black)
    }
}

private extension DailyMissionActivityAttributes.ContentState {
    func remainingText(for kind: DailyMissionKind) -> String {
        kind.formattedValue(remainingValue)
    }

    func trailingText(for attributes: DailyMissionActivityAttributes) -> String {
        switch phase {
        case .completed:
            return "+\(attributes.rewardCoin)"
        case .kickoff:
            return "Go!"
        case .nearGoal:
            return remainingText(for: attributes.kind)
        }
    }

    func compactText(for attributes: DailyMissionActivityAttributes) -> String {
        switch phase {
        case .completed:
            return "+\(attributes.rewardCoin)"
        case .kickoff:
            return "Go!"
        case .nearGoal:
            return compactRemainingText(for: attributes.kind)
        }
    }

    private func compactRemainingText(for kind: DailyMissionKind) -> String {
        switch kind {
        case .step:
            return kind.formattedValue(remainingValue)
        case .distance:
            return "\(kind.formattedValue(remainingValue))km"
        }
    }
}

private extension DailyMissionActivityAttributes {
    static var stepPreview: DailyMissionActivityAttributes {
        DailyMissionActivityAttributes(
            missionID: "preview-step-8000",
            kind: .step,
            targetValue: 8_000,
            rewardCoin: 10,
            startedAt: Date(),
            duration: 10 * 60
        )
    }
}

private extension DailyMissionActivityAttributes.ContentState {
    static var kickoffPreview: DailyMissionActivityAttributes.ContentState {
        DailyMissionActivityAttributes.ContentState(
            currentValue: 4_250,
            remainingValue: 0,
            message: "Nice! Kamu sudah mulai jalan.",
            phase: .kickoff,
            updatedAt: Date()
        )
    }

    static var nearGoalPreview: DailyMissionActivityAttributes.ContentState {
        DailyMissionActivityAttributes.ContentState(
            currentValue: 7_500,
            remainingValue: 500,
            message: "Ayo, 500 langkah lagi untuk dapat 10 coin!",
            phase: .nearGoal,
            updatedAt: Date()
        )
    }

    static var completedPreview: DailyMissionActivityAttributes.ContentState {
        DailyMissionActivityAttributes.ContentState(
            currentValue: 8_000,
            remainingValue: 0,
            message: "You earn 10 coin",
            phase: .completed,
            updatedAt: Date()
        )
    }
}

#Preview("Lock Screen Live Activity", as: .content, using: DailyMissionActivityAttributes.stepPreview) {
    DailyMissionLiveActivity()
} contentStates: {
    DailyMissionActivityAttributes.ContentState.nearGoalPreview
    DailyMissionActivityAttributes.ContentState.completedPreview
}

#Preview("Dynamic Island Compact", as: .dynamicIsland(.compact), using: DailyMissionActivityAttributes.stepPreview) {
    DailyMissionLiveActivity()
} contentStates: {
    DailyMissionActivityAttributes.ContentState.nearGoalPreview
    DailyMissionActivityAttributes.ContentState.kickoffPreview
    DailyMissionActivityAttributes.ContentState.completedPreview
}

#Preview("Dynamic Island Expanded", as: .dynamicIsland(.expanded), using: DailyMissionActivityAttributes.stepPreview) {
    DailyMissionLiveActivity()
} contentStates: {
    DailyMissionActivityAttributes.ContentState.nearGoalPreview
    DailyMissionActivityAttributes.ContentState.completedPreview
}

#Preview("Dynamic Island Minimal", as: .dynamicIsland(.minimal), using: DailyMissionActivityAttributes.stepPreview) {
    DailyMissionLiveActivity()
} contentStates: {
    DailyMissionActivityAttributes.ContentState.nearGoalPreview
}

#Preview("Push Notification") {
    DailyMissionPushNotificationPreview(
        title: "Daily Mission",
        notificationBody: "Ayo, 500 langkah lagi untuk dapat 10 coin!"
    )
}
