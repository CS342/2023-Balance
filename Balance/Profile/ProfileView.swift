//
//  ProfileView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 25/04/2023.
//

import Account
import FirebaseAccount
import class FHIR.FHIR
import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    @SceneStorage(StorageKeys.onboardingFlowStep)
    private var onboardingSteps: [OnboardingFlow.Step] = []
    @State private var showingAvatarSheet = false
    @EnvironmentObject var account: Account
    @EnvironmentObject var firebaseAccountConfiguration: FirebaseAccountConfiguration<FHIR>
    @EnvironmentObject var authModel: AuthViewModel
    @State private var displayName = ""
    @State private var avatar = ""

    var body: some View {
        ActivityLogContainer {
            ZStack {
                VStack(alignment: .center, spacing: 0) {
                    HeaderMenu(title: "")
                        .background(primaryColor)
                    avatarChangeView
                    Spacer().frame(height: 50)
                    Text(self.displayName)
                        .font(.custom("Nunito-Bold", size: 36))
                        .foregroundColor(darkBlueColor)
                    Spacer().frame(height: 10)
                    Text(firebaseAccountConfiguration.user?.email ?? "Mail")
                        .font(.custom("Montserrat-Thin", size: 20))
                        .foregroundColor(darkBlueColor)
                    Spacer().frame(height: 20)
                    cellsView
                    Spacer()
                }
            }
            .onAppear {
                loadUser()
            }
            .onReceive(account.objectWillChange) {
                if account.signedIn {
                    completedOnboardingFlow = true
                } else {
                    completedOnboardingFlow = false
                }
            }
            .onChange(of: authModel.profile) { profile in
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.displayName = profile?.displayName ?? ""
                    self.avatar = profile?.avatar ?? ""
                }
            }
        }
    }
    
    var cellsView: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                infoOption
                updateOption
                logoutOption
            }
            .padding(10)
            .ignoresSafeArea(.all)
        }
    }
    
    var avatarChangeView: some View {
        Button(action: {
            showingAvatarSheet.toggle()
            print("avatarView")
        }) {
            profileView
        }.sheet(isPresented: $showingAvatarSheet) {
            AvatarSelectionView(onboardingSteps: $onboardingSteps, firstLoad: false).environmentObject(authModel)
        }
    }
    
    var infoOption: some View {
        NavigationLink(
            destination: PersonalDataView().environmentObject(authModel)
        ) {
            ProfileCellView(image: "info", text: "Personal Data")
        }
    }
    
    var updateOption: some View {
        NavigationLink(
            destination: PasswordUpdateView()
        ) {
            ProfileCellView(image: "directcurrent", text: "Change password")
        }
    }
    
    var logoutOption: some View {
        Button {
            print("Logout")
            dismiss()
            account.signedIn = false
            completedOnboardingFlow = false
            authModel.signOut()
        } label: {
            ProfileCellView(image: "figure.walk.motion", text: "Logout")
        }
    }
    
    var profileView: some View {
        ZStack(alignment: .top) {
            splitBackgroundView
            avatarView
        }
    }
    
    var splitBackgroundView: some View {
        Rectangle()
            .foregroundColor(primaryColor)
            .edgesIgnoringSafeArea(.top)
            .frame(height: 100)
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
    }
    
    var avatarView: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(self.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .accessibilityLabel("avatar")
                .shadow(color: darkGrayColor, radius: 6)
            plusIcon
        }
    }
    
    var placeholderImage: some View {
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .tint(.gray)
            .background(Color.white)
            .clipShape(Circle())
            .frame(width: 180, height: 180)
            .accessibilityLabel("avatarPlaceholder")
            .shadow(color: darkGrayColor, radius: 6)
            .overlay(
                Circle()
                    .strokeBorder(Color.white, lineWidth: 6)
            )
    }
    
    var plusIcon: some View {
        Image(systemName: "plus")
            .foregroundColor(.white)
            .frame(width: 25, height: 25)
            .background(Color.blue)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            .accessibilityLabel("profilePlus")
    }
    
    func loadUser() {
        authModel.listenAuthentificationState()
        UserProfileRepository.shared.fetchCurrentProfile { profileUser, error in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                authModel.profile = profileUser
                self.displayName = authModel.profile?.displayName ?? ""
                self.avatar = authModel.profile?.avatar ?? ""
                print("PROFILEVIEW User: " + (profileUser?.description() ?? "-"))
            }
        }
    }
}
