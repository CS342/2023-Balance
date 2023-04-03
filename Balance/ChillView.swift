//
//  ChillView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/03/2023.
//

import SwiftUI

struct ChillView: View {
    var body: some View {
        ActivityLogContainer {
            HeaderMenu(title: "Let's chill out")
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    bodySensationOption
                    breathingOption
                    guidedMeditationOption
                    writeSomethingOption
                }
                .padding(10)
                .ignoresSafeArea(.all)
            }
        }
    }
    
    var writeSomethingOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Write Something Feature",
                isDirectChildToContainer: true,
                content: {
                    // define action
                }
            )
        ) {
            NavView(image: "writeIcon", text: "Write Something")
        }
    }
    
    var guidedMeditationOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Guided meditation Feature",
                isDirectChildToContainer: true,
                content: {
                    MeditationView()
                }
            )
        ) {
            NavView(image: "meditationIcon", text: "Guided Meditation")
        }
    }
    
    var breathingOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Breathing Feature",
                isDirectChildToContainer: true,
                content: {
                    // define action
                }
            )
        ) {
            NavView(image: "breathIcon", text: "Breathing")
        }
    }
    
    var bodySensationOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Body sensations Feature",
                isDirectChildToContainer: true,
                content: {
                    // define action
                }
            )
        ) {
            NavView(image: "bodySensationIcon", text: "Body Sensations")
        }
    }
}

#if DEBUG
struct ChillView_Previews: PreviewProvider {
    static var previews: some View {
        ChillView()
    }
}
#endif
