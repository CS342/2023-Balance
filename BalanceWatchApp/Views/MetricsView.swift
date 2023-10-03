/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The workout metrics view.
 */

import HealthKit
import SwiftUI

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool
    
    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else {
                return nil
            }
            return baseSchedule.next()
        }
    }
}

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var animationAmount: CGFloat = 1

    var body: some View {
        TimelineView(
            MetricsTimelineSchedule(
                from: workoutManager.builder?.startDate ?? Date(),
                isPaused: workoutManager.session?.state == .paused
            )
        ) { context in
                VStack(alignment: .center) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .accessibilityHidden(true)
                        .scaleEffect(animationAmount)
                        .animation(
                            .linear(duration: 0.1)
                            .delay(0.2)
                            .repeatForever(autoreverses: true),
                            value: animationAmount
                        )
                        .onAppear {
                            animationAmount = 1.2
                        }
                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                        .foregroundStyle(.yellow)
                    //                Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                    //                    .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                    Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                    //                Text(Measurement(value: workoutManager.distance, unit: UnitLength.meters).formatted(.measurement(width: .abbreviated, usage: .road)))
                }
                .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                .frame(maxWidth: .infinity, alignment: .center)
                .ignoresSafeArea(edges: .bottom)
                .scenePadding()
        }
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView().environmentObject(WorkoutManager())
    }
}
