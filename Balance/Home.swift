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
    
    var body: some View {
        NavigationStack {
            HeaderMenu(title: "Home")
            ScrollView(.vertical) {
                VStack {
                    NavigationLink(destination: DiaryHomeView()) {
                        NavView(image: "BalanceLogo", text: "Diary")
                    }
                    NavigationLink(destination: MeditationView()) {
                        NavView(image: "BalanceLogo", text: "Meditation")
                    }
                    NavigationLink(destination: Music()) {
                        NavView(image: "BalanceLogo", text: "Distraction")
                    }
                }
                .ignoresSafeArea(.all)
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
