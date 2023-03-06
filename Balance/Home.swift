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
            MeditationView()
                .tag(Tabs.meditation)
                .tabItem {
                    Label("Meditation", systemImage: "list.clipboard")
                }
            DiaryHomeView()
                .tag(Tabs.diary)
                .tabItem {
                    Label("Diary", systemImage: "book")
                }
            Music()
                .tag(Tabs.music)
                .tabItem {
                    Label("Music", systemImage: "music.note")
                }
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
