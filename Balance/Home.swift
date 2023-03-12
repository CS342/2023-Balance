//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import BalanceContacts
import BalanceSchedule
import BalanceSharedContext
import SwiftUI
import BalanceMockDataStorageProvider


struct HomeView: View {
    enum Tabs: String {
        case schedule
        case contact
        case meditation
        case mockUpload
        case diary
        case music
    }
    
    
    @AppStorage(StorageKeys.homeTabSelection) var selectedTab = Tabs.schedule
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ActivityLogBaseView(viewName: "Meditation Feature", content: {
                MeditationView()
                    .tag(Tabs.meditation)
                    .tabItem {
                        Label("Meditation",
                              systemImage: "list.clipboard")
                    }
            })
            ActivityLogBaseView(viewName: "Diary Feature", content: {
                DiaryHomeView()
                    .tag(Tabs.diary)
                    .tabItem {
                        Label("Diary", systemImage: "book")
                    }
            })
            ActivityLogBaseView(viewName: "Distraction Music Feature", content: {
                Music()
                    .tag(Tabs.music)
                    .tabItem {
                        Label("Music", systemImage: "music.note")
                    }
            })
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
