/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A class that wraps the data and operations related to workout.
*/

import Foundation
import os
import HealthKit

@MainActor
class WorkoutManager: NSObject, ObservableObject {
    struct SessionSateChange {
        let newState: HKWorkoutSessionState
        let date: Date
    }
    /**
     The workout session live states that the UI observes.
     */
    @Published var sessionState: HKWorkoutSessionState = .notStarted
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var speed: Double = 0
    @Published var power: Double = 0
    @Published var cadence: Double = 0
    @Published var distance: Double = 0
    @Published var water: Double = 0
    @Published var elapsedTimeInterval: TimeInterval = 0
    /**
     SummaryView (watchOS) changes from Saving Workout to the metric summary view when
     a workout changes from nil to a valid value.
     */
    @Published var workout: HKWorkout?
    /**
     HealthKit data types to share and read.
     */
    let typesToShare: Set = [HKQuantityType.workoutType(),
                             HKQuantityType(.dietaryWater)]
    let typesToRead: Set = [
        HKQuantityType(.heartRate),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.cyclingSpeed),
        HKQuantityType(.cyclingPower),
        HKQuantityType(.cyclingCadence),
        HKQuantityType(.distanceCycling),
        HKQuantityType(.dietaryWater),
        HKQuantityType.workoutType(),
        HKObjectType.activitySummaryType()
    ]
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    #if os(watchOS)
    /**
     The live workout builder that is only available on watchOS.
     */
    var builder: HKLiveWorkoutBuilder?
    #else
    /**
     A date for synchronizing the elapsed time between iOS and watchOS.
     */
    var contextDate: Date?
    #endif
    /**
     Creates an async stream that buffers a single newest element, and the stream's continuation to yield new elements synchronously to the stream.
     The Swift actors don't handle tasks in a first-in-first-out way. Use AsyncStream to make sure that the app presents the latest state.
     */
    let asynStreamTuple = AsyncStream.makeStream(of: SessionSateChange.self, bufferingPolicy: .bufferingNewest(1))
    /**
     WorkoutManager is a singleton.
     */
    static let shared = WorkoutManager()
    
    /**
     Kick off a task to consume the async stream. The next value in the stream can't start processing
     until "await consumeSessionStateChange(value)" returns and the loop enters the next iteration, which serializes the asynchronous operations.
     */
    private override init() {
        super.init()
        Task {
            for await value in asynStreamTuple.stream {
                await consumeSessionStateChange(value)
            }
        }
    }
    /**
     Consume the session state change from the async stream to update sessionState and finish the workout.
     */
    private func consumeSessionStateChange(_ change: SessionSateChange) async {
        sessionState = change.newState
        /**
          Wait for the session to transition states before ending the builder.
         */
        #if os(watchOS)
        /**
         Send the elapsed time to the iOS side.
         */
        let elapsedTimeInterval = session?.associatedWorkoutBuilder().elapsedTime(at: change.date) ?? 0
        let elapsedTime = WorkoutElapsedTime(timeInterval: elapsedTimeInterval, date: change.date)
        if let elapsedTimeData = try? JSONEncoder().encode(elapsedTime) {
            await sendData(elapsedTimeData)
        }

        guard change.newState == .stopped, let builder else {
            return
        }

        let finishedWorkout: HKWorkout?
        do {
            try await builder.endCollection(at: change.date)
            finishedWorkout = try await builder.finishWorkout()
            session?.end()
        } catch {
            Logger.shared.log("Failed to end workout: \(error))")
            return
        }
        workout = finishedWorkout
        #endif
    }
}

// MARK: - Workout session management
//
extension WorkoutManager {
    func resetWorkout() {
        #if os(watchOS)
        builder = nil
        #endif
        workout = nil
        session = nil
        activeEnergy = 0
        heartRate = 0
        distance = 0
        water = 0
        power = 0
        cadence = 0
        speed = 0
        sessionState = .notStarted
    }
    
    func sendData(_ data: Data) async {
        do {
            try await session?.sendData(toRemoteWorkoutSession: data)
        } catch {
            Logger.shared.log("Failed to send data: \(error)")
        }
    }
}

// MARK: - Workout statistics
//
extension WorkoutManager {
    func updateForStatistics(_ statistics: HKStatistics) {
        switch statistics.quantityType {
        case HKQuantityType.quantityType(forIdentifier: .heartRate):
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            
        case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
            let energyUnit = HKUnit.kilocalorie()
            activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            
        case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
            HKQuantityType.quantityType(forIdentifier: .distanceCycling):
            let meterUnit = HKUnit.meter()
            distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            
        case HKQuantityType(.cyclingSpeed):
            let speedUnit = HKUnit.mile().unitDivided(by: HKUnit.hour())
            speed = statistics.mostRecentQuantity()?.doubleValue(for: speedUnit) ?? 0
            
        case HKQuantityType(.cyclingPower):
            let powerUnit = HKUnit.watt()
            power = statistics.mostRecentQuantity()?.doubleValue(for: powerUnit) ?? 0
            
        case HKQuantityType(.cyclingCadence):
            let cadenceUnit = HKUnit.count().unitDivided(by: .minute())
            cadence = statistics.mostRecentQuantity()?.doubleValue(for: cadenceUnit) ?? 0
            
        default:
            return
        }
    }
}

// MARK: - HKWorkoutSessionDelegate
// HealthKit calls the delegate methods on an anonymous serial background queue,
// so the methods need to be nonisolated explicitly.
//
extension WorkoutManager: HKWorkoutSessionDelegate {
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                                    didChangeTo toState: HKWorkoutSessionState,
                                    from fromState: HKWorkoutSessionState,
                                    date: Date) {
        Logger.shared.log("Session state changed from \(fromState.rawValue) to \(toState.rawValue)")
        /**
         Yield the new state change to the async stream synchronously.
         asynStreamTuple is a constant, so it's nonisolated.
         */
        let sessionSateChange = SessionSateChange(newState: toState, date: date)
        asynStreamTuple.continuation.yield(sessionSateChange)
    }
        
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                                    didFailWithError error: Error) {
        Logger.shared.log("\(#function): \(error)")
    }
    
    /**
     HealthKit calls this method when it determines that the mirrored workout session is invalid.
     */
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                                    didDisconnectFromRemoteDeviceWithError error: Error?) {
        Logger.shared.log("\(#function): \(error)")
    }
    
    /**
     HealthKit calls this method when the session receives data from its remote counterpart.
     */
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                                    didReceiveDataFromRemoteDevice data: Data) {
        Logger.shared.log("\(#function): \(data.debugDescription)")
        Task { @MainActor in
            do {
                try handleReceivedData(data)
            } catch {
                Logger.shared.log("Failed to handle received data: \(error))")
            }
        }
    }
}

// MARK: - A structure for synchronizing the elapsed time.
//
struct WorkoutElapsedTime: Codable {
    var timeInterval: TimeInterval
    var date: Date
}

// MARK: - Convenient workout state
//
extension HKWorkoutSessionState {
    var isActive: Bool {
        self != .notStarted && self != .ended
    }
}
