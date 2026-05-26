//
//  DailyMissionCoordinator.swift
//  FitChick
//
//  Created by Codex on 26/05/26.
//

import ActivityKit
import Foundation
import UserNotifications

@MainActor
final class DailyMissionCoordinator {
    private struct StepSample {
        let date: Date
        let steps: Int
    }

    private struct DistanceSample {
        let date: Date
        let distance: Double
    }

    private struct ActiveMission {
        let missionID: String
        let target: DailyMissionTarget
        let phase: DailyMissionActivityPhase
        let expiresAt: Date
    }

    private enum Constants {
        static let rewardCoin = 10
        static let nearStepThreshold = 500.0
        static let nearDistanceThreshold = 1.0
        static let stepMomentumThreshold = 500
        static let distanceMomentumThreshold = 0.5
        static let rollingWindow: TimeInterval = 10 * 60
        static let nearGoalActivityDuration: TimeInterval = 10 * 60
        static let kickoffActivityDuration: TimeInterval = 2 * 60
        static let completedActivityDismissalDelay: TimeInterval = 15
    }

    private let defaults: UserDefaults
    private let notificationCenter: UNUserNotificationCenter
    private let calendar: Calendar

    private var stepSamples: [StepSample] = []
    private var distanceSamples: [DistanceSample] = []
    private var activeMissions: [String: ActiveMission] = [:]
    private var currentActivity: Activity<DailyMissionActivityAttributes>?
    private var activityTimeoutTasks: [String: Task<Void, Never>] = [:]
    private var didRequestNotificationAuthorization = false

    init(
        defaults: UserDefaults = .standard,
        notificationCenter: UNUserNotificationCenter = .current(),
        calendar: Calendar = .current
    ) {
        self.defaults = defaults
        self.notificationCenter = notificationCenter
        self.calendar = calendar
    }

    func start(
        steps: Int,
        distance: Double,
        stepTargets: [Int],
        distanceTargets: [Double]
    ) async {
        await requestNotificationAuthorizationIfNeeded()
        restoreCurrentActivityIfNeeded()
        await handleProgress(
            steps: steps,
            distance: distance,
            stepTargets: stepTargets,
            distanceTargets: distanceTargets
        )
    }

    func handleProgress(
        steps: Int,
        distance: Double,
        stepTargets: [Int],
        distanceTargets: [Double]
    ) async {
        await requestNotificationAuthorizationIfNeeded()
        restoreCurrentActivityIfNeeded()
        await updateCurrentActivity(steps: steps, distance: distance)
        await handleActiveMissionCompletionIfNeeded(steps: steps, distance: distance)
        await handleStepMomentumIfNeeded(currentSteps: steps)
        await handleDistanceMomentumIfNeeded(currentDistance: distance)
        await handleNearTargetsIfNeeded(
            targets: stepTargets.map {
                DailyMissionTarget(
                    kind: .step,
                    value: Double($0),
                    threshold: Constants.nearStepThreshold,
                    rewardCoin: Constants.rewardCoin
                )
            },
            currentValue: Double(steps)
        )
        await handleNearTargetsIfNeeded(
            targets: distanceTargets.map {
                DailyMissionTarget(
                    kind: .distance,
                    value: $0,
                    threshold: Constants.nearDistanceThreshold,
                    rewardCoin: Constants.rewardCoin
                )
            },
            currentValue: distance
        )
    }

    private func handleActiveMissionCompletionIfNeeded(steps: Int, distance: Double) async {
        let now = Date()
        let expiredMissionIDs = activeMissions.values
            .filter { $0.expiresAt <= now }
            .map(\.missionID)

        expiredMissionIDs.forEach {
            activeMissions[$0] = nil
            cancelActivityTimeout(missionID: $0)
        }

        let activeNearGoalMissions = activeMissions.values.filter {
            $0.phase == .nearGoal
        }

        for mission in activeNearGoalMissions {
            let currentValue: Double

            switch mission.target.kind {
            case .step:
                currentValue = Double(steps)
            case .distance:
                currentValue = distance
            }

            guard currentValue >= mission.target.value else {
                continue
            }

            await completeMission(mission, currentValue: currentValue)
        }
    }

    private func requestNotificationAuthorizationIfNeeded() async {
        guard didRequestNotificationAuthorization == false else {
            return
        }

        didRequestNotificationAuthorization = true
        let settings = await notificationCenter.notificationSettings()

        guard settings.authorizationStatus == .notDetermined else {
            return
        }

        do {
            _ = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Daily mission notification authorization failed: \(error.localizedDescription)")
        }
    }

    private func handleNearTargetsIfNeeded(
        targets: [DailyMissionTarget],
        currentValue: Double
    ) async {
        for target in targets {
            let remainingValue = target.value - currentValue

            guard remainingValue > 0, remainingValue <= target.threshold else {
                continue
            }

            let triggerKey = "dailyMission.nearGoal.\(target.id)"

            guard hasTriggeredToday(triggerKey) == false else {
                continue
            }

            markTriggeredToday(triggerKey)
            let body = nearGoalMessage(for: target)
            await sendLocalNotification(
                identifier: "\(triggerKey).\(todayKey)",
                title: "Daily Mission",
                body: body
            )
            await startOrUpdateActivity(
                target: target,
                currentValue: currentValue,
                remainingValue: remainingValue,
                message: body,
                phase: .nearGoal,
                duration: Constants.nearGoalActivityDuration
            )
        }
    }

    private func handleStepMomentumIfNeeded(currentSteps: Int) async {
        let now = Date()
        let cutoffDate = now.addingTimeInterval(-Constants.rollingWindow)
        stepSamples.removeAll { $0.date < cutoffDate }

        if stepSamples.last?.steps != currentSteps {
            stepSamples.append(StepSample(date: now, steps: currentSteps))
        }

        guard let baselineSample = stepSamples.first else {
            return
        }

        let stepIncrease = currentSteps - baselineSample.steps

        guard stepIncrease >= Constants.stepMomentumThreshold else {
            return
        }

        let triggerKey = "dailyMission.stepMomentum"

        guard hasTriggeredToday(triggerKey) == false else {
            return
        }

        markTriggeredToday(triggerKey)

        let target = DailyMissionTarget(
            kind: .step,
            value: Double(currentSteps),
            threshold: Constants.nearStepThreshold,
            rewardCoin: Constants.rewardCoin
        )

        await startOrUpdateActivity(
            target: target,
            currentValue: Double(currentSteps),
            remainingValue: 0,
            message: "Nice! Kamu sudah mulai jalan.",
            phase: .kickoff,
            duration: Constants.kickoffActivityDuration
        )
    }

    private func handleDistanceMomentumIfNeeded(currentDistance: Double) async {
        let now = Date()
        let cutoffDate = now.addingTimeInterval(-Constants.rollingWindow)
        distanceSamples.removeAll { $0.date < cutoffDate }

        if distanceSamples.last?.distance != currentDistance {
            distanceSamples.append(DistanceSample(date: now, distance: currentDistance))
        }

        guard let baselineSample = distanceSamples.first else {
            return
        }

        let distanceIncrease = currentDistance - baselineSample.distance

        guard distanceIncrease >= Constants.distanceMomentumThreshold else {
            return
        }

        let triggerKey = "dailyMission.distanceMomentum"

        guard hasTriggeredToday(triggerKey) == false else {
            return
        }

        markTriggeredToday(triggerKey)

        let target = DailyMissionTarget(
            kind: .distance,
            value: currentDistance,
            threshold: Constants.distanceMomentumThreshold,
            rewardCoin: Constants.rewardCoin
        )

        await startOrUpdateActivity(
            target: target,
            currentValue: currentDistance,
            remainingValue: 0,
            message: "Nice! Kamu sudah mulai jalan.",
            phase: .kickoff,
            duration: Constants.kickoffActivityDuration
        )
    }

    private func startOrUpdateActivity(
        target: DailyMissionTarget,
        currentValue: Double,
        remainingValue: Double,
        message: String,
        phase: DailyMissionActivityPhase,
        duration: TimeInterval
    ) async {
        let missionID = "\(target.id).\(todayKey).\(phase.rawValue)"
        let expiresAt = Date().addingTimeInterval(duration)
        let contentState = DailyMissionActivityAttributes.ContentState(
            currentValue: currentValue,
            remainingValue: max(remainingValue, 0),
            message: message,
            phase: phase,
            updatedAt: Date()
        )
        let content = ActivityContent(
            state: contentState,
            staleDate: expiresAt
        )
        let nextActiveMission = ActiveMission(
            missionID: missionID,
            target: target,
            phase: phase,
            expiresAt: expiresAt
        )

        if let activity = currentActivity, activity.attributes.missionID == missionID {
            activeMissions[missionID] = nextActiveMission
            await activity.update(content)
            scheduleActivityTimeout(missionID: missionID, duration: duration)
            return
        }

        await endCurrentActivity(clearActiveMissions: false)
        activeMissions[missionID] = nextActiveMission
        scheduleActivityTimeout(missionID: missionID, duration: duration)

        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            return
        }

        do {
            currentActivity = try Activity.request(
                attributes: DailyMissionActivityAttributes(
                    missionID: missionID,
                    kind: target.kind,
                    targetValue: target.value,
                    rewardCoin: target.rewardCoin,
                    startedAt: Date(),
                    duration: duration
                ),
                content: content,
                pushType: nil
            )
        } catch {
            print("Daily mission Live Activity failed: \(error.localizedDescription)")
        }
    }

    private func completeMission(_ mission: ActiveMission, currentValue: Double) async {
        activeMissions[mission.missionID] = nil
        cancelActivityTimeout(missionID: mission.missionID)
        let rewardKey = "dailyMission.reward.\(mission.target.id)"

        guard hasTriggeredToday(rewardKey) == false else {
            if currentActivity?.attributes.missionID == mission.missionID {
                await endCurrentActivity(clearActiveMissions: false)
            }
            return
        }

        markTriggeredToday(rewardKey)
        let updatedCoinCount = defaults.integer(forKey: "coinCount") + mission.target.rewardCoin
        defaults.set(updatedCoinCount, forKey: "coinCount")
        await showCompletedActivity(for: mission, currentValue: currentValue)
    }

    private func showCompletedActivity(for mission: ActiveMission, currentValue: Double) async {
        let completedState = DailyMissionActivityAttributes.ContentState(
            currentValue: currentValue,
            remainingValue: 0,
            message: "You earn \(mission.target.rewardCoin) coin",
            phase: .completed,
            updatedAt: Date()
        )
        let finalContent = ActivityContent(
            state: completedState,
            staleDate: Date().addingTimeInterval(Constants.completedActivityDismissalDelay)
        )

        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            return
        }

        if let activity = currentActivity, activity.attributes.missionID == mission.missionID {
            await activity.update(finalContent)
            await activity.end(
                finalContent,
                dismissalPolicy: .after(Date().addingTimeInterval(Constants.completedActivityDismissalDelay))
            )
            currentActivity = nil
            return
        }

        await endCurrentActivity(clearActiveMissions: false)

        do {
            let completedActivity = try Activity.request(
                attributes: DailyMissionActivityAttributes(
                    missionID: mission.missionID,
                    kind: mission.target.kind,
                    targetValue: mission.target.value,
                    rewardCoin: mission.target.rewardCoin,
                    startedAt: Date(),
                    duration: Constants.completedActivityDismissalDelay
                ),
                content: finalContent,
                pushType: nil
            )
            await completedActivity.end(
                finalContent,
                dismissalPolicy: .after(Date().addingTimeInterval(Constants.completedActivityDismissalDelay))
            )
        } catch {
            print("Daily mission completion activity failed: \(error.localizedDescription)")
        }
    }

    private func updateCurrentActivity(steps: Int, distance: Double) async {
        guard let activity = currentActivity else {
            return
        }

        let currentValue: Double

        switch activity.attributes.kind {
        case .step:
            currentValue = Double(steps)
        case .distance:
            currentValue = distance
        }

        let remainingValue = max(activity.attributes.targetValue - currentValue, 0)
        let contentState = DailyMissionActivityAttributes.ContentState(
            currentValue: currentValue,
            remainingValue: remainingValue,
            message: activity.content.state.message,
            phase: activity.content.state.phase,
            updatedAt: Date()
        )
        let content = ActivityContent(
            state: contentState,
            staleDate: Date().addingTimeInterval(activity.attributes.duration)
        )

        await activity.update(content)
    }

    private func endCurrentActivity(clearActiveMissions: Bool = true) async {
        if clearActiveMissions {
            activeMissions.removeAll()
            cancelAllActivityTimeouts()
        }

        guard let activity = currentActivity else {
            return
        }

        let finalContent: ActivityContent<DailyMissionActivityAttributes.ContentState>? = nil
        await activity.end(finalContent, dismissalPolicy: .immediate)
        currentActivity = nil
    }

    private func scheduleActivityTimeout(missionID: String, duration: TimeInterval) {
        cancelActivityTimeout(missionID: missionID)
        activityTimeoutTasks[missionID] = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            await self?.endActivityIfNeeded(missionID: missionID)
        }
    }

    private func endActivityIfNeeded(missionID: String) async {
        let didHaveActiveMission = activeMissions[missionID] != nil
        activeMissions[missionID] = nil
        cancelActivityTimeout(missionID: missionID)

        guard didHaveActiveMission || currentActivity?.attributes.missionID == missionID else {
            return
        }

        if currentActivity?.attributes.missionID == missionID {
            await endCurrentActivity(clearActiveMissions: false)
        }
    }

    private func cancelActivityTimeout(missionID: String) {
        activityTimeoutTasks[missionID]?.cancel()
        activityTimeoutTasks[missionID] = nil
    }

    private func cancelAllActivityTimeouts() {
        activityTimeoutTasks.values.forEach { $0.cancel() }
        activityTimeoutTasks.removeAll()
    }

    private func restoreCurrentActivityIfNeeded() {
        guard currentActivity == nil else {
            return
        }

        currentActivity = Activity<DailyMissionActivityAttributes>.activities.first

        guard
            let activity = currentActivity,
            activity.content.state.phase != .completed,
            activeMissions[activity.attributes.missionID] == nil
        else {
            return
        }

        let expiresAt = activity.attributes.startedAt.addingTimeInterval(activity.attributes.duration)

        guard Date() < expiresAt else {
            return
        }

        activeMissions[activity.attributes.missionID] = ActiveMission(
            missionID: activity.attributes.missionID,
            target: DailyMissionTarget(
                kind: activity.attributes.kind,
                value: activity.attributes.targetValue,
                threshold: activity.attributes.kind == .step
                    ? Constants.nearStepThreshold
                    : Constants.nearDistanceThreshold,
                rewardCoin: activity.attributes.rewardCoin
            ),
            phase: activity.content.state.phase,
            expiresAt: expiresAt
        )
    }

    private func sendLocalNotification(identifier: String, title: String, body: String) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: nil
        )

        do {
            try await notificationCenter.add(request)
        } catch {
            print("Daily mission notification failed: \(error.localizedDescription)")
        }
    }

    private func nearGoalMessage(for target: DailyMissionTarget) -> String {
        let remainingText = target.kind.formattedValue(target.threshold)
        return "Ayo, \(remainingText) \(target.kind.unitText) lagi untuk dapat \(target.rewardCoin) coin!"
    }

    private func hasTriggeredToday(_ key: String) -> Bool {
        defaults.string(forKey: key) == todayKey
    }

    private func markTriggeredToday(_ key: String) {
        defaults.set(todayKey, forKey: key)
    }

    private var todayKey: String {
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
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
