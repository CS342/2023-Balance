//
//  ChillView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/03/2023.
//

import SwiftUI

// swiftlint:disable closure_body_length
struct ChillView: View {
    var body: some View {
        ActivityLogContainer {
            HeaderBar(title: "Let's chill out")
//            NavigationStack {
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        NavigationLink(
                            destination: ActivityLogBaseView(
                                viewName: "Body sensations Feature",
                                isDirectChildToContainer: true,
                                content: {
//                                    Music()
                                }
                            )
                        ) {
                            NavView(image: "bodySensationIcon", text: "Body Sensations")
                        }
                        NavigationLink(
                            destination: ActivityLogBaseView(
                                viewName: "Breathing Feature",
                                isDirectChildToContainer: true,
                                content: {
//                                    MeditationView()
                                }
                            )
                        ) {
                            NavView(image: "breathIcon", text: "Breathing")
                        }
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
                        NavigationLink(
                            destination: ActivityLogBaseView(
                                viewName: "Write Something Feature",
                                isDirectChildToContainer: true,
                                content: {
//                                    DiaryHomeView()
                                }
                            )
                        ) {
                            NavView(image: "writeIcon", text: "Write Something")
                        }
                    }
                    .padding(10)
                    .ignoresSafeArea(.all)
                }
//            }.accentColor(.white)
        }
    }
}

struct ChillView_Previews: PreviewProvider {
    static var previews: some View {
        ChillView()
    }
}
