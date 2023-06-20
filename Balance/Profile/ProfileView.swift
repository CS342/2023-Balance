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

// swiftlint:disable type_body_length
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
    @EnvironmentObject var noteStore: NoteStore
    @EnvironmentObject var drawStore: DrawStore
    @EnvironmentObject var coloringStore: ColoringStore
    #if DEMO
    @EnvironmentObject var logStore: ActivityLogStore
    #endif
    @State private var displayName = ""
    @State private var avatar = ""
    @State private var email = ""
    @State private var patientID = ""

    var body: some View {
        ActivityLogContainer {
            ZStack {
                VStack(alignment: .center, spacing: 0) {
                    HeaderMenu(title: "")
                        .background(primaryColor)
                    avatarChangeView
                    userData
                    cellsView
                    Spacer()
                }
            }
            .onAppear {
#if DEMO
                loadUserLocal()
                loadLogs()
#else
                loadUser()
#endif
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
                    self.email = profile?.email ?? ""
                    self.patientID = profile?.id ?? "0000"
                    self.avatar = profile?.avatar ?? ""
                }
            }
        }
    }
    
    var userData: some View {
        Group {
            Spacer().frame(height: 50)
            Text(self.displayName)
                .font(.custom("Nunito-Bold", size: 36))
                .foregroundColor(darkBlueColor)
            Spacer().frame(height: 10)
            Text(self.email)
                .font(.custom("Montserrat-Thin", size: 20))
                .foregroundColor(darkBlueColor)
            Spacer().frame(height: 10)
            Text("PatientID: " + self.patientID)
                .font(.custom("Montserrat-Thin", size: 20))
                .foregroundColor(darkBlueColor)
            Spacer().frame(height: 20)
        }
    }
    
    var cellsView: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
#if !DEMO
                infoOption
                updateOption
#else
                //                resetOption
                shareOption
#endif
                logoutOption
            }
            .padding(10)
            .ignoresSafeArea(.all)
        }
    }
    
    var avatarChangeView: some View {
#if !DEMO
        Button(action: {
            showingAvatarSheet.toggle()
            print("avatarView")
        }) {
            profileView
        }.sheet(isPresented: $showingAvatarSheet) {
            AvatarSelectionView(onboardingSteps: $onboardingSteps, firstLoad: false).environmentObject(authModel)
        }
#else
        profileView
#endif
    }
    
    var resetOption: some View {
        NavigationLink(
            destination:
                EmptyView()
        ) {
            ProfileCellView(image: "info", text: "Reset user")
        }
    }
    
    var shareOption: some View {
        ShareLink(
            item: convertToCSV(),
            subject: Text("Balance Export"),
            message: Text("PatientID: " + self.patientID + " - " + self.displayName + " - " + self.email)
        ) {
            ProfileCellView(image: "directcurrent", text: "Share data")
        }
    }
    
    var infoOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "SECTION USER INFO",
                isDirectChildToContainer: true,
                content: {
                    PersonalDataView().environmentObject(authModel)
                }
            )
        ) {
            ProfileCellView(image: "info", text: "Personal Data")
        }
    }
    
    var updateOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "SECTION PASSWORD UPDATE",
                isDirectChildToContainer: true,
                content: {
                    PasswordUpdateView()
                }
            )
        ) {
            ProfileCellView(image: "directcurrent", text: "Change password")
        }
    }
    
    var logoutOption: some View {
        Button {
            print("Logout")
            logStore.removeStore()
            noteStore.removeStore()
            drawStore.removeStore()
            coloringStore.removeStore()
//            dismiss()
//            authModel.signOut()
//            completedOnboardingFlow = false
//            account.signedIn = false
//            NavigationUtil.popToRootView()

#if !DEMO
#endif
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
#if !DEMO
            plusIcon
#endif
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
                self.email = authModel.profile?.email ?? ""
                self.patientID = authModel.profile?.id ?? "0000"
                self.avatar = authModel.profile?.avatar ?? ""
                print("PROFILEVIEW User: " + (profileUser?.description() ?? "-"))
            }
        }
    }
    
    func loadUserLocal() {
        UserProfileRepositoryToLocal.shared.fetchCurrentProfile { profileUser, error in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                authModel.profile = profileUser
                self.displayName = authModel.profile?.displayName ?? ""
                self.email = authModel.profile?.email ?? ""
                self.patientID = authModel.profile?.id ?? "0000"
                self.avatar = authModel.profile?.avatar ?? ""
                print("PROFILEVIEW User: " + (profileUser?.description() ?? "-"))
            }
        }
    }
    
    func loadLogs() {
        ActivityLogStore.load { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let logs):
                logStore.logs = logs
            }
        }
    }
    
    func convertToCSV() -> String {
        var noteAsCSV = ""
        noteAsCSV.append(contentsOf: "time,dadescriptionte\n")
        
        for log in logStore.logs {
            for action in log.actions {
                noteAsCSV.append(contentsOf: "\"\(action.time)\",\"\(action.description)\"\n")
            }
        }
        
        return noteAsCSV
    }
}
