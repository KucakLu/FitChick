//
//  DailyMissionActivityAttributes.swift
//  DailyMissionWidget
//
//  Created by Codex on 26/05/26.
//

import ActivityKit
import Foundation

enum DailyMissionKind: String, Codable, Hashable {
    case step
    case distance

    var unitText: String {
        switch self {
        case .step:
            return "langkah"
        case .distance:
            return "km"
        }
    }

    func formattedValue(_ value: Double) -> String {
        switch self {
        case .step:
            return Self.formattedStepValue(Int(value.rounded()))
        case .distance:
            return String(format: "%.1f", value)
        }
    }

    private static func formattedStepValue(_ value: Int) -> String {
        let digits = String(value)
        let reversedGroups = stride(from: digits.count, to: 0, by: -3).map { endIndex in
            let startIndex = max(endIndex - 3, 0)
            let start = digits.index(digits.startIndex, offsetBy: startIndex)
            let end = digits.index(digits.startIndex, offsetBy: endIndex)
            return String(digits[start..<end])
        }

        return reversedGroups.reversed().joined(separator: ".")
    }
}

enum DailyMissionActivityPhase: String, Codable, Hashable {
    case kickoff
    case nearGoal
    case completed
}

struct DailyMissionActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var currentValue: Double
        var remainingValue: Double
        var message: String
        var phase: DailyMissionActivityPhase
        var updatedAt: Date
    }

    var missionID: String
    var kind: DailyMissionKind
    var targetValue: Double
    var rewardCoin: Int
    var startedAt: Date
    var duration: TimeInterval
}
