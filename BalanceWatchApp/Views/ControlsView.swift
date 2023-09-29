/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout controls.
*/

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
        HStack {
            VStack {
                Button {
                    workoutManager.endWorkout()
                } label: {
                    Image(systemName: "xmark")
                        .accessibility(hidden: true)
                }
                .tint(.red)
                .font(.title2)
                Text("End")
            }.accessibilityElement(children: .ignore)
            VStack {
                Button {
                    workoutManager.togglePause()
                } label: {
                    Image(systemName: workoutManager.running ? "pause" : "play")
                        .accessibility(hidden: true)
                }
                .tint(.yellow)
                .font(.title2)
                Text(workoutManager.running ? "Pause" : "Resume")
            }.accessibilityElement(children: .ignore)
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView().environmentObject(WorkoutManager())
    }
}
