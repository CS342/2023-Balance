//
//  ChillView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/03/2023.
//

import SwiftUI

// swiftlint:disable closure_body_length
// swiftlint:disable line_length
struct DistractionView: View {
    var body: some View {
        ActivityLogContainer {
            HeaderBar(title: "Distraction")
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        NavigationLink(
                            destination: ActivityLogBaseView(
                                viewName: "Look at pictures Feature",
                                isDirectChildToContainer: true,
                                content: {
//                                    Music()
                                }
                            )
                        ) {
                            DistractionCellView(image: "bodySensationIcon", text: "Look at pictures", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")
                        }
                        NavigationLink(
                            destination: ActivityLogBaseView(
                                viewName: "Listen music Feature",
                                isDirectChildToContainer: true,
                                content: {
                                    Music()
                                }
                            )
                        ) {
                            DistractionCellView(image: "breathIcon", text: "Listen to music", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")
                        }
                        NavigationLink(
                            destination: ActivityLogBaseView(
                                viewName: "Look Videos Feature",
                                isDirectChildToContainer: true,
                                content: {
                                    MeditationView()
                                }
                            )
                        ) {
                            DistractionCellView(image: "meditationIcon", text: "Look videos", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")
                        }
                        NavigationLink(
                            destination: ActivityLogBaseView(
                                viewName: "Random notes Feature",
                                isDirectChildToContainer: true,
                                content: {
//                                    DiaryHomeView()
                                }
                            )
                        ) {
                            DistractionCellView(image: "writeIcon", text: "Random notes", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")
                        }
                        NavigationLink(
                            destination: ActivityLogBaseView(
                                viewName: "Sudoku Feature",
                                isDirectChildToContainer: true,
                                content: {
//                                    DiaryHomeView()
                                }
                            )
                        ) {
                            DistractionCellView(image: "writeIcon", text: "Sudoko", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")
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
                            DistractionCellView(image: "writeIcon", text: "Write something", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")
                        }
                    }
                    .padding(10)
                    .ignoresSafeArea(.all)
                }
        }
    }
}

struct DistractionView_Previews: PreviewProvider {
    static var previews: some View {
        DistractionView()
    }
}
