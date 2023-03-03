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
        case mockUpload
        case music
        case diary
    }
    
    
    @AppStorage(StorageKeys.homeTabSelection) var selectedTab = Tabs.schedule
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ScheduleView()
                .tag(Tabs.schedule)
                .tabItem {
                    Label("SCHEDULE_TAB_TITLE", systemImage: "list.clipboard")
                }
            Contacts()
                .tag(Tabs.contact)
                .tabItem {
                    Label("CONTACTS_TAB_TITLE", systemImage: "person.fill")
                }
            Music()
                .tag(Tabs.music)
                .tabItem {
                    Label("Music", systemImage: "music.note")
                }
            MockUploadList()
                .tag(Tabs.mockUpload)
            DiaryHomeView()
                .tag(Tabs.diary)
                .tabItem {
                    Label("Diary", systemImage: "book")
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
