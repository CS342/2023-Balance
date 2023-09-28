/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The start view.
 */

import HealthKit
import SwiftUI

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var counter: Counter
    
    var workoutTypes: [HKWorkoutActivityType] = [.mindAndBody]
    
    var body: some View {
        List(workoutTypes) { workoutType in
            NavigationLink(
                workoutType.name,
                destination: SessionPagingView(),
                tag: workoutType,
                selection: $workoutManager.selectedWorkout
            )
            .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
        }
        .listStyle(.carousel)
        .navigationBarTitle("BALANCE")
        .onChange(of: workoutManager.heartRate, perform: { _ in
            counter.sendValue(val: workoutManager.heartRate)
        })
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }
    
    var name: String {
        switch self {
        case .mindAndBody:
            return "Mind&Body START"
        default:
            return ""
        }
    }
}
