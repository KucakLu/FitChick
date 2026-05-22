//
//  HealthStore.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 20/05/26.
//

import HealthKit

class HealthStore {
    let healthStore = HKHealthStore()

    enum HealthStoreError: Error {
        case healthDataUnavailable
        case missingStepCountType
        case missingWalkingRunningDistanceType
    }

    // request permissions
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthStoreError.healthDataUnavailable
        }

        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw HealthStoreError.missingStepCountType
        }

        guard let stepDistanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            throw HealthStoreError.missingWalkingRunningDistanceType
        }

        let typesToRead: Set = [stepCountType, stepDistanceType]

        try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
    }

    // Fetch Step count data from healthkit
    func fetchStepCount() async throws -> Double {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw HealthStoreError.missingStepCountType
        }

        let startOfDay = Calendar.current.startOfDay(for: Date()) // todays date
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) {
                _, result, error in
                if let error = error as? HKError, error.code == .errorNoData {
                    continuation.resume(returning: 0)
                    return
                }
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                let stepCount = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                continuation.resume(returning: stepCount)
            }

            healthStore.execute(query)
        }
    }
}
