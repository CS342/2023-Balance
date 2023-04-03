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

struct HomeView: View {
    var clipsToBounds = false

    var body: some View {
        ActivityLogContainer {
            NavigationStack {
                VStack {
                    HeaderHome(name: "Home", avatar: "BalanceLogo", userID: "00007")
                    ScrollView(.vertical) {
                        VStack(spacing: 20) {
                            distractOption
                            chillOption
                            fealingLearningOption
                            diaryOption
                        }
                        .padding(10)
                        .ignoresSafeArea(.all)
                    }
                    Spacer()
                }
                .navigationTitle("")
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .ignoresSafeArea()
                .accentColor(nil)
            }
        }
    }
    
    var diaryOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Diary Feature",
                isDirectChildToContainer: true,
                content: {
                    DiaryHomeView()
                }
            )
        ) {
            NavView(image: "diaryIcon", text: "Diary")
        }
    }
    
    var fealingLearningOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Feeling learning Feature",
                isDirectChildToContainer: true,
                content: {
                    ChillView()
                }
            )
        ) {
            NavView(image: "learningIcon", text: "Feeling learning")
        }
    }
    
    var chillOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Let's chill out Feature",
                isDirectChildToContainer: true,
                content: {
                    MeditationView()
                }
            )
        ) {
            NavView(image: "chillIcon", text: "Let's chill out")
        }
    }
    
    var distractOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Distraction Music Feature",
                isDirectChildToContainer: true,
                content: {
                    DistractionView()
                }
            )
        ) {
            NavView(image: "distractMeIcon", text: "Distract me")
        }
    }
}
#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(BalanceScheduler())
            .environmentObject(MockDataStorageProvider())
    }
}
#endif
