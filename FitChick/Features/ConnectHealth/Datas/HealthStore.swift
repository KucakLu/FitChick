//
//  HealthStore.swift
//  FitChick
//
//  Created by Syahra Zulya Shania Maghfiroh on 20/05/26.
//

import HealthKit

class HealthStore {
    let healthStore = HKHealthStore()
    
    // request permissions
    func requestAuthorization(completion: @escaping(Bool, Error?)-> Void){
        let StepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let StepDistanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        let typesToRead: Set = [StepCountType, StepDistanceType]
        
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { (success, error) in
            completion(success, error)
        }
        
    }
    
    // Fetch Step count data from healthkit
    func fetchStepCount(completion: @escaping(Double, Error?)-> Void){
        let StepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let startOfDay = Calendar.current.startOfDay(for: Date()) // todays date
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: StepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) {
            _, result, _ in
            let stepCount = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            DispatchQueue.main.async {
                completion(stepCount, nil)
            }
        }
        
        healthStore.execute(query)
    }
}
