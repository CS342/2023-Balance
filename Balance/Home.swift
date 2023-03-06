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
    @State var navigationPath = NavigationPath()
    
    enum Tabs: String {
        case schedule
        case contact
        case meditation
        case mockUpload
        case diary
        case music
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                NavigationLink{
                    DiaryHomeView()
                } label: {
                    Label("Diary", systemImage: "book")
                }
                NavigationLink{
                    MeditationView()
                } label: {
                    Label("Meditation", systemImage: "list.clipboard")
                }
                NavigationLink{
                    SpotifyView()
                } label: {
                    Label("Distraction", systemImage: "music.note")
                }
                
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
