//
//  AvatarPreviewView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 14/04/2023.
//

import Account
import BalanceSharedContext
import FirebaseAccount
import class FHIR.FHIR
import Onboarding
import SwiftUI

struct AvatarPreviewView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firebaseAccountConfiguration: FirebaseAccountConfiguration<FHIR>
    @EnvironmentObject var authModel: AuthViewModel
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @Binding private var avatarSelection: Avatar
    @Binding private var accesorySelection: Accesory
    @State private var profile = ProfileUser()
    @State private var loading = false
    private var firstLoad: Bool
    
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer().frame(height: 50)
                    titlePreview
                    Spacer()
                    avatarSelected
                    Spacer()
                    saveButton
                    cancelButton
                }
                if loading {
                    loadingView
                        .ignoresSafeArea()
                }
            }
            .disabled(loading)
            .onAppear {
                authModel.listenAuthentificationState()
                self.profile = authModel.profile ?? ProfileUser()
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
            Image("stars2")
                .resizable()
                .frame(width: 50.0, height: 50.0)
                .clipped()
                .accessibilityLabel("star2")
                .offset(x: -100, y: -50)
            Image(avatarSelection.name)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipped()
                .accessibilityLabel("avatarPreview")
            //            if !firstLoad {
            //                Image(accesorySelection?.name ?? "acc_1")
            //                    .resizable()
            //                    .scaledToFit()
            //                    .frame(width: 130, height: 130)
            //                    .clipped()
            //                    .accessibilityLabel("accesoryPreview")
            //                    .offset(x: 80, y: 80)
            //            }
            Image("stars1")
                .resizable()
                .frame(width: 50.0, height: 50.0)
                .clipped()
                .accessibilityLabel("star1")
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
            },
            label: {
                Text("Select")
                    .font(.custom("Montserrat-SemiBold", size: 17))
                    .padding(.horizontal, 10.0)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44.0)
            }
        )
        .overlay( RoundedRectangle(cornerRadius: 10)
            .stroke(primaryColor, lineWidth: 2))
        .background(primaryColor)
        .padding(.horizontal, 20.0)
    }
    
    var cancelButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Change")
                .font(.custom("Montserrat-SemiBold", size: 17))
                .padding(.horizontal, 10.0)
                .foregroundColor(primaryColor)
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
        }
        .overlay( RoundedRectangle(cornerRadius: 10)
            .stroke(primaryColor, lineWidth: 2))
        .background(.white)
        .padding(.horizontal, 20.0)
    }
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>, avatarSelection: Binding<Avatar>, accesorySelection: Binding<Accesory>, firstLoad: Bool) {
        self._onboardingSteps = onboardingSteps
        self._avatarSelection = avatarSelection
        self._accesorySelection = accesorySelection
        self.firstLoad = firstLoad
    }
    
    func updateData(profile: ProfileUser) {
        if firstLoad {
//            dismiss()
            onboardingSteps.remove(at: 1)
            onboardingSteps.remove(at: 0)
        } else {
            withAnimation(.easeInOut(duration: 1.0)) {
                self.profile = profile
                loading = false
            }
            dismiss()
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
}
