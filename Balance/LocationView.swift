//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import BalanceContacts
import BalanceMockDataStorageProvider
import BalanceSchedule
import BalanceSharedContext
import SwiftUI

//// swiftlint:disable closure_body_length
//struct HomeView: View {
//    enum Tabs: String {
//        case schedule
//        case contact
//        case meditation
//        case mockUpload
//        case diary
//        case music
//    }
//    var clipsToBounds = false
//
//    var body: some View {
//        ActivityLogContainer {
//            NavigationStack {
//                HeaderMenu(title: "Home")
//                ScrollView(.vertical) {
//                    VStack(spacing: 20) {
//                        NavigationLink(
//                            destination: ActivityLogBaseView(
//                                viewName: "Diary Feature",
//                                isDirectChildToContainer: true,
//                                content: {
//                                    DiaryHomeView()
//                                }
//                        )
//                        ) {
//                            NavView(image: "Diary", text: "Diary")
//                        }
//                        NavigationLink(
//                            destination: ActivityLogBaseView(
//                                viewName: "Meditation Feature",
//                                isDirectChildToContainer: true,
//                                content: {
//                                    MeditationView()
//                                }
//                        )
//                        ) {
//                            NavView(image: "Meditation", text: "Meditation")
//                        }
//                        NavigationLink(
//                            destination: ActivityLogBaseView(
//                                viewName: "Distraction Music Feature",
//                                isDirectChildToContainer: true,
//                                content: {
//                                    Music()
//                                }
//                        )
//                        ) {
//                            NavView(image: "DistractImage", text: "Distraction")
//                        }
//                    }
//                    .padding(10)
//                    .ignoresSafeArea(.all)
//                }
//            }
//            .background(Color(#colorLiteral(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)))
// swiftlint:disable closure_body_length

struct LocationView: View {
    var clipsToBounds = false
    
    var body: some View {
        ActivityLogContainer {
            VStack(spacing: 20) {
                Spacer()
                Text("Where are you at?")
                    .foregroundColor(.purple)
                    .font(.largeTitle)
                Spacer()
                NavigationLink(
                    destination: ActivityLogBaseView(
                        viewName: "Hospital Selection",
                        isDirectChildToContainer: true,
                        content: {
                            HomeView()
                        }
                    )
                ) {
                    NavView(image: "hospitalIcon", text: "Hospital")
                }
                NavigationLink(
                    destination: ActivityLogBaseView(
                        viewName: "Home Selection",
                        isDirectChildToContainer: true,
                        content: {
                            HomeView()
                        }
                    )
                ) {
                    NavView(image: "homeIcon", text: "Home")
                }
                Spacer()
                Button(action: {
                    //define action
                }) {
                    Text("Next")
                        .font(.system(.title2))
                        .padding(.horizontal, 10.0)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44.0)
                }
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .background(Color(#colorLiteral(red: 0.30, green: 0.79, blue: 0.94, alpha: 1.00)))
                .cornerRadius(10)
                .padding(.horizontal, 20.0)
            }
        }
    }
}
#if DEBUG
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
            .environmentObject(BalanceScheduler())
            .environmentObject(MockDataStorageProvider())
    }
}
#endif
