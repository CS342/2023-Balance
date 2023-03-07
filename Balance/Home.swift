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
        VStack{
            NavigationStack {
                HeaderMenu(title: "Home")
                ScrollView(.vertical){
                    VStack{
                        NavigationLink(destination: DiaryHomeView()) {
                            HStack {
                                Image("BalanceLogo") //TO BE REPLACED LATER
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 20)
                                Text("Diary")
                            }
                            .frame(width: 360, height: 200)
                            .foregroundColor(Color(UIColor(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
                            .background(Color(UIColor(red: 0.30, green: 0.79, blue: 0.94, alpha: 0.05)))
                            .cornerRadius(40)
                            .padding()
                        }
                        NavigationLink(destination: MeditationView()) {
                            HStack {
                                Image("BalanceLogo") //TO BE REPLACED LATER
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 20)
                                Text("Meditation")
                            }
                            .frame(width: 360, height: 200)
                            .foregroundColor(Color(UIColor(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
                            .background(Color(UIColor(red: 0.30, green: 0.79, blue: 0.94, alpha: 0.05)))
                            .cornerRadius(40)
                            .padding()
                        }
                        NavigationLink(destination: Music()) {
                            HStack {
                                Image("BalanceLogo") //TO BE REPLACED LATER
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 20)
                                Text("Distraction")
                            }
                            .frame(width: 360, height: 200)
                            .foregroundColor(Color(UIColor(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
                            .background(Color(UIColor(red: 0.30, green: 0.79, blue: 0.94, alpha: 0.05)))
                            .cornerRadius(40)
                            .padding()
                        }
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
