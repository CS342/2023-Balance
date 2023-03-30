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
            HeaderMenu(title: "Distraction")
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
                            DistractionCellView(image: "picturesIcon", text: "Look at pictures", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
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
                            DistractionCellView(image: "musicIcon", text: "Listen to music", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
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
                            DistractionCellView(image: "videosIcon", text: "Look videos", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
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
                            DistractionCellView(image: "notesIcon", text: "Random notes", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
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
                            DistractionCellView(image: "sudokoIcon", text: "Sudoko", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
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
                            DistractionCellView(image: "writesIcon", text: "Write something", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
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
