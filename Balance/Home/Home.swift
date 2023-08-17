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

struct HomeView: View {
    @EnvironmentObject var authModel: AuthViewModel
    @State var showMe = false
    @State var profile = ProfileUser()
    
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                NavigationStack {
                    VStack(spacing: 0) {
                        HeaderHome()
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
//                cloudImage.zIndex(-1)
            }
            accesoryImage.zIndex(2)
        }
    }
    
    var accesoryImage: some View {
        Image(profile.accesory)
            .resizable()
            .accessibilityLabel("acc_icon")
            .scaledToFit()
            .clipped()
            .frame(width: 150, height: 150)
            .background(Color.clear)
            .offset(x: -30, y: -10)
    }
    
    var cloudImage: some View {
        Image("cloud")
            .accessibilityLabel("cloud")
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
                viewName: "Feeling learning Feature",
                isDirectChildToContainer: true,
                content: {
                    FeelingView()
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
}
