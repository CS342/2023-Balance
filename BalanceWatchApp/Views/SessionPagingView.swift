/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The paging view to switch between controls, metrics, and now playing views.
*/

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    enum Tab {
        case controls, metrics
    }
    
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.isLuminanceReduced)
    var isLuminanceReduced
    @State private var selection: Tab = .metrics

    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            MetricsView().tag(Tab.metrics)
        }
        .navigationTitle(workoutManager.selectedWorkout?.name ?? "")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
        .onChange(of: workoutManager.running) { _ in
            displayMetricsView()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .onChange(of: isLuminanceReduced) { _ in
            displayMetricsView()
        }
    }

    private func displayMetricsView() {
        withAnimation {
            selection = .metrics
        }
    }
}

struct PagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView().environmentObject(WorkoutManager())
    }
}
