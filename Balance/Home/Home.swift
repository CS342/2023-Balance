//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Account
import SwiftUI
import class FHIR.FHIR
import FirebaseAccount
import WatchConnectivity

struct HomeView: View {
    @EnvironmentObject var authModel: AuthViewModel
    @State var showMe = false
    @State var profile = ProfileUser()
    @StateObject var counter = Counter()

    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                NavigationStack {
                    VStack(spacing: 0) {
                        HeaderHome().environmentObject(counter)
                        menuOptions
                        Spacer()
                    }
                    .navigationTitle("")
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .ignoresSafeArea()
                    .accentColor(nil)
#if !DEMO
                    .overlay(loadingOverlay)
#endif
                }
            }
            .onChange(of: authModel.profile) { _ in
                withAnimation(.easeInOut(duration: 1.0)) {
                    loadUser()
                }
            }
            .onChange(of: counter.count, perform: { _ in
                if counter.count > UserDefaults.standard.double(forKey: bpmKEY) {
                    print(counter.count)
                    alertHeartRate()
                }
            })
            .onAppear {
                localNotification()
            }
        }
    }
    
    @ViewBuilder private var loadingOverlay: some View {
        let user = authModel.user
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
                            .accessibility(hidden: true)
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
    
    var menuOptions: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .bottomLeading) {
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        distractOption
                        chillOption
                        fealingLearningOption
                        diaryOption
                    }
                    .padding(20)
                    .ignoresSafeArea(.all)
                }
                .zIndex(1)
                Spacer()
            }
            accesoryImage.zIndex(2)
        }
    }
    
    var accesoryImage: some View {
        var accX = UserDefaults.standard.double(forKey: accesoryX)
        var accY = UserDefaults.standard.double(forKey: accesoryY)

        if UserDefaults.standard.object(forKey: accesoryX) == nil {
            accX = accesoryDefaultX
            accY = accesoryDefaultY
        }
        
        return DraggableAccesoryView(location: CGPoint(x: accX, y: accY), imageName: profile.accesory)
    }
    
    var cloudImage: some View {
        Image("cloud")
            .accessibility(hidden: true)
            .clipped()
            .background(Color.clear)
    }
    
    var sosButton: some View {
        VStack {
            Button(action: {
                print("SOS!")
// #if !DEMO
//                let user = firebaseAccountConfiguration.user
//                let isFirstLoadKey = (user?.uid ?? "0") + "isFirstLoad"
//                UserDefaults.standard.set(true, forKey: isFirstLoadKey)
// #endif
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
            }.buttonStyle(ActivityLogButtonStyle(activityDescription: "SOS ACTION CALLED"))
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
                viewName: "All the feels Feature",
                isDirectChildToContainer: true,
                content: {
                    FeelingView()
                }
            )
        ) {
            NavView(image: "learningIcon", text: "All the feels")
        }
    }
    
    var chillOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Let's chill out Feature",
                isDirectChildToContainer: true,
                content: {
                    ChillView()
                }
            )
        ) {
            NavView(image: "chillIcon", text: "Let's chill out")
        }
    }
    
    var distractOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Distraction Feature",
                isDirectChildToContainer: true,
                content: {
                    DistractionView()
                }
            )
        ) {
            NavView(image: "distractMeIcon", text: "Distract me")
        }
    }
    
    func alertHeartRate() {
        let content = UNMutableNotificationContent()
        content.title = "Find some Balance"
        content.subtitle = "Heads Up!"
        content.body = "Your ❤️ heart's racing—time to find your Balance!"
        content.badge = 1

         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

         let requestIdentifier = "BALANCENotification"
         let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)

         UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
             print("LocalNotification error: \(String(describing: error))")
         })
    }
    
    func loadUser() {
#if !DEMO
        UserProfileRepository.shared.fetchCurrentProfile { profileUser, error in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                print("User: " + (profileUser?.description() ?? "-"))
                self.profile = profileUser
            }
        }
#else
        UserProfileRepositoryToLocal.shared.fetchCurrentProfile { profileUser, error in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                print("User: " + (profileUser?.description() ?? "-"))
                self.profile = profileUser ?? ProfileUser()
            }
        }
#endif
    }
    
    func localNotification() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [[.alert, .sound, .badge]],
            completionHandler: { granted, error in
                if error != nil {
                    print("LocalNotification error: \(String(describing: error))")
                } else {
                    print("LocalNotification access granted...\( granted.description)")
                }
            }
        )
    }
}
