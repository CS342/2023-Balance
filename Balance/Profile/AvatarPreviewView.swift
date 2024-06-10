//
//  AvatarPreviewView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 14/04/2023.
//

import SwiftUI

// swiftlint:disable type_body_length
struct AvatarPreviewView: View {
    @Environment(\.dismiss)
    private var dismiss
    @EnvironmentObject var authModel: AuthViewModel
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @Binding private var avatarSelection: Avatar
    @Binding private var accesorySelection: Accesory
    @State private var profile = ProfileUser()
    @State private var loading = false
    private var firstLoad: Bool
    private var accesoryBuy: Bool
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                titlePreview
                Spacer()
                avatarSelected
                Spacer()
                saveButton
                cancelButton
                Spacer().frame(height: 50)
            }
            if loading {
                loadingView
                    .ignoresSafeArea()
            }
        }
        .disabled(loading)
        .onAppear {
            loadUser()
#if !DEMO
            authModel.listenAuthentificationState()
#endif
        }
        .onChange(of: authModel.profile ?? ProfileUser()) { profile in
            updateData(profile: profile)
        }
        .onChange(of: authModel.authError) { value in
            if !value.isEmpty {
                loading = false
                //                    self.alertMessage = value
                //                    self.showingAlert = true
            }
        }
    }
    
    var loadingView: some View {
        ProgressView("Loading...")
            .tint(.white)
            .accentColor(.white)
            .foregroundColor(.white)
            .frame(width: 200, height: 200)
            .background(Color.black.opacity(0.8))
            .cornerRadius(20, corners: .allCorners)
    }
    
    var titlePreview: some View {
        Text("Well done, this is how your personal avatar looks like now")
            .foregroundColor(violetColor)
            .font(.custom("Nunito-Bold", size: 24))
            .multilineTextAlignment(.center)
            .lineLimit(3)
            .padding(.horizontal, 30.0)
    }
    
    var avatarSelected: some View {
        ZStack {
            backImageTop
            Image("stars2")
                .resizable()
                .frame(width: 50.0, height: 50.0)
                .clipped()
                .accessibility(hidden: true)
                .offset(x: -100, y: -50)
            if accesoryBuy {
                Image(profile.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipped()
                    .accessibility(hidden: true)
            } else {
                if avatarSelection.name.isEmpty {
                    Image(profile.avatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .accessibility(hidden: true)
                } else {
                    Image(avatarSelection.name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .accessibility(hidden: true)
                }
            }
            firsloadView
            backImageBottom
        }
    }
    var backImageTop: some View {
        Image("stars2")
            .resizable()
            .frame(width: 50.0, height: 50.0)
            .clipped()
            .accessibilityLabel("star2")
            .offset(x: -100, y: -50)
    }
    
    var backImageBottom: some View {
        Image("stars1")
            .resizable()
            .frame(width: 50.0, height: 50.0)
            .clipped()
            .accessibilityLabel("star1")
            .offset(x: 100, y: 50)
    }
    
    var firsloadView: some View {
        Group {
            if !firstLoad {
                if accesorySelection.name.isEmpty {
                    Image(profile.accesory)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .clipped()
                        .offset(x: 80, y: 80)
                        .accessibility(hidden: true)
                } else {
                    Image(accesorySelection.name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .clipped()
                        .offset(x: 80, y: 80)
                        .accessibility(hidden: true)
                }
            }
            Image("stars1")
                .resizable()
                .frame(width: 50.0, height: 50.0)
                .clipped()
                .accessibility(hidden: true)
                .offset(x: 100, y: 50)
        }
    }
    
    var saveButton: some View {
        Button(
            action: {
                loading = true
                if firstLoad {
                    var user = retrive()
                    user.avatar = avatarSelection.name
                    authModel.signUp(userData: user)
                } else {
#if DEMO
                    updateLocalProfile()
#else
                    updateProfile()
#endif
                }
            },
            label: {
                Text("Select")
                    .font(.custom("Montserrat-SemiBold", size: 17))
                    .padding(.horizontal, 10.0)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .frame(height: 44.0)
            }
        )
        .background(primaryColor)
        .cornerRadius(10)
    }
    
    var cancelButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Change")
                .font(.custom("Montserrat-SemiBold", size: 17))
                .padding(.horizontal, 10.0)
                .foregroundColor(primaryColor)
                .frame(width: 300)
                .frame(height: 44.0)
        }
        
        .overlay( RoundedRectangle(cornerRadius: 10)
            .stroke(primaryColor, lineWidth: 2))
        .background(.white)
    }
    
    init(
        onboardingSteps: Binding<[OnboardingFlow.Step]>,
        avatarSelection: Binding<Avatar>,
        accesorySelection: Binding<Accesory>,
        firstLoad: Bool,
        accesoryBuy: Bool
    ) {
        self._onboardingSteps = onboardingSteps
        self._avatarSelection = avatarSelection
        self._accesorySelection = accesorySelection
        self.firstLoad = firstLoad
        self.accesoryBuy = accesoryBuy
    }
    
    func updateData(profile: ProfileUser) {
        if firstLoad {
            onboardingSteps.remove(at: 1)
            onboardingSteps.remove(at: 0)
        } else {
            //            withAnimation(.easeInOut(duration: 1.0)) {
            //                self.profile = profile
            //                loading = false
            //            }
            //            NavigationUtil.dismiss(2)
        }
    }
    
    func retrive() -> ProfileUser {
        do {
            if let data = UserDefaults.standard.data(forKey: "user") {
                let user = try JSONDecoder().decode(ProfileUser.self, from: data)
                print(user)
                return user
            }
        } catch {
            print("Error decoding: \(error)")
        }
        return ProfileUser()
    }
    
    func loadUser() {
#if !DEMO
        UserProfileRepository.shared.fetchCurrentProfile { profileUser, error in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                print("User: " + (profileUser?.description() ?? "-"))
                authModel.profile = profileUser
                self.profile = profileUser
            }
        }
#else
        self.profile = authModel.profile ?? ProfileUser()
#endif
    }
    
    func updateLocalProfile() {
        print("User: " + profile.description())
        if !avatarSelection.name.isEmpty {
            profile.avatar = avatarSelection.name
        }
        if !accesorySelection.name.isEmpty {
            profile.accesory = accesorySelection.name
        }
        
        var coins = UserDefaults.standard.integer(forKey: "\(self.profile.id)_coins")
        coins -= accesorySelection.value
        
        if coins < 0 {
            print("No coins to buy accesory")
            NotificationCenter.default.post(name: Notification.Name.coinsAlert, object: nil)
            return
        }
        
        UserProfileRepositoryToLocal.shared.createProfile(profile: profile) { profile, error in
            loading = false
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                UserDefaults.standard.set(coins, forKey: "\(self.profile.id)_coins")
                NotificationCenter.default.post(name: Notification.Name.coinsRefresh, object: nil)
                self.profile = profile ?? ProfileUser()
                authModel.profile = profile
                print("User: " + (profile?.description() ?? "-"))
                NavigationUtil.dismiss(2)
            }
        }
    }
    
    func updateProfile() {
        UserProfileRepository.shared.fetchCurrentProfile { profileUser, error in
            if let error = error {
                loading = false
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                print("User: " + (profileUser?.description() ?? "-"))
                var loadExistenceProfile = profileUser ?? ProfileUser()
                loadExistenceProfile.avatar = avatarSelection.name
                UserProfileRepository.shared.createProfile(profile: loadExistenceProfile) { profile, error in
                    loading = false
                    if let error = error {
                        print("Error while fetching the user profile: \(error)")
                        return
                    } else {
                        self.profile = profile ?? ProfileUser()
                        authModel.profile = profile
                        print("User: " + (profile?.description() ?? "-"))
                        NavigationUtil.popToRootView()
                    }
                }
            }
        }
    }
}
