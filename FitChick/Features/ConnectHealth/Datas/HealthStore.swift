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

    func stepCountUpdates() -> AsyncStream<Double> {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return emptyQuantityUpdates()
        }

        return dailyQuantityUpdates(for: stepCountType, unit: .count())
    }

    // Fetch walking and running distance data from HealthKit in kilometers.
    func fetchWalkingRunningDistance() async throws -> Double {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            throw HealthStoreError.missingWalkingRunningDistanceType
        }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) {
                _, result, error in
                if let error = error as? HKError, error.code == .errorNoData {
                    continuation.resume(returning: 0)
                    return
                }

                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                let distance = result?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo)) ?? 0
                continuation.resume(returning: distance)
            }

            healthStore.execute(query)
        }
    }

    func walkingRunningDistanceUpdates() -> AsyncStream<Double> {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return emptyQuantityUpdates()
        }

        return dailyQuantityUpdates(for: distanceType, unit: .meterUnit(with: .kilo))
    }

    private func dailyQuantityUpdates(for quantityType: HKQuantityType, unit: HKUnit) -> AsyncStream<Double> {
        AsyncStream { continuation in
            var interval = DateComponents()
            interval.day = 1

            let query = HKStatisticsCollectionQuery(
                quantityType: quantityType,
                quantitySamplePredicate: nil,
                options: .cumulativeSum,
                anchorDate: Calendar.current.startOfDay(for: Date()),
                intervalComponents: interval
            )

            query.initialResultsHandler = { _, collection, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }

                guard let collection else {
                    continuation.yield(0)
                    return
                }

                continuation.yield(Self.todayQuantityValue(from: collection, unit: unit))
            }

            query.statisticsUpdateHandler = { _, statistics, collection, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }

                if let collection {
                    continuation.yield(Self.todayQuantityValue(from: collection, unit: unit))
                    return
                }

                if let statistics {
                    continuation.yield(statistics.sumQuantity()?.doubleValue(for: unit) ?? 0)
                    return
                }

                continuation.yield(0)
            }

            healthStore.execute(query)

            continuation.onTermination = { [weak self] _ in
                self?.healthStore.stop(query)
            }
        }
    }

    private func emptyQuantityUpdates() -> AsyncStream<Double> {
        AsyncStream { continuation in
            continuation.finish()
        }
    }

    private static func todayQuantityValue(from collection: HKStatisticsCollection, unit: HKUnit) -> Double {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        var total = 0.0

        collection.enumerateStatistics(from: startOfDay, to: Date()) { statistics, _ in
            total += statistics.sumQuantity()?.doubleValue(for: unit) ?? 0
        }

        return total
    }
}
