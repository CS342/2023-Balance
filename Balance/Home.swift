//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Account
import BalanceContacts
import BalanceMockDataStorageProvider
import BalanceSchedule
import BalanceSharedContext
import SwiftUI
import class FHIR.FHIR
import FirebaseAccount

struct HomeView: View {
    @EnvironmentObject var account: Account
    @EnvironmentObject var firebaseAccountConfiguration: FirebaseAccountConfiguration<FHIR>
    @State var showMe = false
    
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
                .overlay(loadingOverlay)
            }
        }
    }
    
    @ViewBuilder private var loadingOverlay: some View {
        //        if account.signedIn {
        let user = firebaseAccountConfiguration.user
        let isFirstLoadKey = (user?.uid ?? "0") + "isFirstLoad"
        let isFirstLoad = UserDefaults.standard.bool(forKey: isFirstLoadKey)
        if !isFirstLoad {
            Group {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.8)
                VStack {
                    HStack {
                        Spacer()
                        sosButton
                            .offset(x: 8, y: -20)
                    }
                    ZStack {
                        Image("popHelp")
                            .accessibilityLabel("popHelp")
                            .offset(y: -40)
                        Text("You can use it when you need help, we will guide you to help you control the emotions you are feeling at the moment.")
                            .font(.custom("Nunito", size: 18))
                            .padding()
                            .offset(y: -30)
                    }
                    Spacer()
                }
            }.opacity(showMe ? 0 : 1)
        }
    }
    
    var sosButton: some View {
        VStack {
            Button(action: {
                print("SOS!")
                let user = firebaseAccountConfiguration.user
                let isFirstLoadKey = (user?.uid ?? "0") + "isFirstLoad"
                withAnimation(Animation.spring().speed(0.2)) {
                    showMe.toggle()
                }
            }) {
                Text("SOS")
                    .font(.custom("Nunito-Bold", size: 14))
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.white)
                    .background(Color.pink)
                    .clipShape(Circle())
            }
        }
        .frame(width: 40, height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 4)
                .allowsHitTesting(false)
        )
        .shadow(color: .gray, radius: 2, x: 0, y: 1)
        .padding()
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
