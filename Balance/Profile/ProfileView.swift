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
    @Environment(\.dismiss)
    private var dismiss
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
    @EnvironmentObject var activityLogEntry: ActivityLogEntry
#if DEMO
    @EnvironmentObject var logStore: ActivityLogStore
#endif
    @State private var displayName = ""
    @State private var avatar = ""
    @State private var email = ""
    @State private var patientID = ""
    @State private var showAlert = false
    @State private var logs = [ActivityLogEntry]()
    @State private var logsIsEmpty = true
    
    var body: some View {
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
            Text("ParticipantID: " + self.patientID)
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
                resetOption
                if logsIsEmpty == false {
                    shareOption
                    shareLink
                }
#endif
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
            AvatarSelectionView(onboardingSteps: $onboardingSteps, firstLoad: false, accesoryLoad: false).environmentObject(authModel)
        }
    }
    
    var resetOption: some View {
        Button {
            showAlert = true
        } label: {
            ProfileCellView(image: "info", text: "Reset user")
        }.confirmationDialog("Reset User", isPresented: $showAlert) {
            Button("Canel", role: .cancel) {
                showAlert = false
            }
            Button("Reset") {
                activityLogEntry.reset()
                // NotificationCenter.default.post(name: Notification.Name.goBackground, object: nil)
                self.logs.removeAll()
                logsIsEmpty = true
                UserImageCache.remove(key: self.patientID.appending("UploadedArray"))
                UserImageCache.remove(key: self.patientID.appending("RemovedArray"))
                UserImageCache.remove(key: self.patientID.appending("FavoritesArray"))
                logStore.removeStore()
                noteStore.removeStore()
                drawStore.removeStore()
                coloringStore.removeStore()
            }
        }
    }
    
    var shareOption: some View {
        Button(action: {
            EmailHelper.shared.send(
                subject: "Balance Export",
                body: "ParticipantID: " + self.patientID + "\n",
                file: convertToCSV(),
                fileName: self.patientID + ".csv",
                plainText: convertToPlainText(),
                to: ["cmirand@stanford.edu"]
            )
        }) {
            ProfileCellView(image: "mail", text: "E-Mail data")
        }
    }
    
    var shareLink: some View {
        ShareLink(
            item: convertToCSV(),
            subject: Text("Balance Export: ParticipantID: " + self.patientID)
        ) {
            ProfileCellView(image: "square.and.arrow.up", text: "Share data")
        }
    }
    
    var infoOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Section user Info",
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
                viewName: "Section password update",
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
            // #if DEMO
            //            UserImageCache.remove(key: self.patientID.appending("UploadedArray"))
            //            UserImageCache.remove(key: self.patientID.appending("RemovedArray"))
            //            UserImageCache.remove(key: self.patientID.appending("FavoritesArray"))
            //            logStore.removeStore()
            //            noteStore.removeStore()
            //            drawStore.removeStore()
            //            coloringStore.removeStore()
            // #endif
            //            dismiss()
            authModel.signOut()
            completedOnboardingFlow = false
            //            account.signedIn = false
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
                self.logs = logs
                if self.logs.isEmpty {
                    logsIsEmpty = true
                } else {
                    logsIsEmpty = false
                }
            }
        }
    }
    
    func convertToCSV() -> URL {
        var logActions = [LogAction]()
        var noteAsCSV = "sessionID, sessionStartTime, sessionEndTime, sessionDuration, description, startTime, endTime, duration\n"
        for log in logs {
            for action in log.actions {
                logActions.append(
                    LogAction(
                        sessionID: log.id,
                        sessionStartTime: log.startTime,
                        sessionEndTime: log.endTime,
                        sessionDuration: log.duration,
                        description: action.description,
                        startTime: action.startTime,
                        endTime: action.endTime,
                        duration: action.duration
                    )
                )
            }
        }
        
        for action in logActions.sorted(by: { $0.startTime.compare($1.startTime) == .orderedAscending }) {
            noteAsCSV.append(contentsOf: "\"\(action.sessionID)\",\"\(DateFormatter.sharedDateFormatter.string(from: action.sessionStartTime))\",\"\(DateFormatter.sharedDateFormatter.string(from: action.sessionEndTime))\",\"\(action.sessionDuration)\",\"\(action.description)\",\"\(DateFormatter.sharedDateFormatter.string(from: action.startTime))\",\"\(DateFormatter.sharedDateFormatter.string(from: action.endTime))\",\"\(action.duration)\"\n")
        }
        
        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent(self.patientID + ".csv")
            try noteAsCSV.write(to: fileURL, atomically: true, encoding: .utf8)
            
            return fileURL
        } catch {
            print("error creating file")
        }
        return URL(fileURLWithPath: "")
    }
    
    func convertToPlainText() -> String {
        var noteAsCSV = "ParticipantID: " + self.patientID + "\n"
        noteAsCSV.append(contentsOf: "sessionID, sessionStartTime, sessionEndTime, sessionDuration, description, startTime, endTime, duration\n")
        
        var logActions = [LogAction]()
        for log in logs {
            for action in log.actions {
                logActions.append(
                    LogAction(
                        sessionID: log.id,
                        sessionStartTime: log.startTime,
                        sessionEndTime: log.endTime,
                        sessionDuration: log.duration,
                        description: action.description,
                        startTime: action.startTime,
                        endTime: action.endTime,
                        duration: action.duration
                    )
                )
            }
        }
        
        for action in logActions.sorted(by: { $0.startTime.compare($1.startTime) == .orderedAscending }) {
            noteAsCSV.append(contentsOf: "\"\(action.sessionID)\",\"\(DateFormatter.sharedDateFormatter.string(from: action.sessionStartTime))\",\"\(DateFormatter.sharedDateFormatter.string(from: action.sessionEndTime))\",\"\(action.sessionDuration)\",\"\(action.description)\",\"\(DateFormatter.sharedDateFormatter.string(from: action.startTime))\",\"\(DateFormatter.sharedDateFormatter.string(from: action.endTime))\",\"\(action.duration)\"\n")
        }
        return noteAsCSV
    }
}
