//
//  ProfileView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 25/04/2023.
//

import SwiftUI

// swiftlint:disable type_body_length
// swiftlint:disable file_length
struct ProfileView: View {
    @Environment(\.dismiss)
    private var dismiss
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    @SceneStorage(StorageKeys.onboardingFlowStep)
    private var onboardingSteps: [OnboardingFlow.Step] = []
    @State private var showingAvatarSheet = false
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
    @State private var sliderValue: Float = 0.0
    @State private var isEditing = false
    @State private var sliderStringValue: String = ""
//    @State private var postData = [PostCount]()
    @State private var valuesData = [Double]()
    @State private var namesData = [String]()
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                HeaderMenu(title: "")
                    .background(primaryColor)
                avatarChangeView
                userData
                bpmView
                cellsView
                Spacer()
            }
        }
        .onAppear {
            loadBPM()
#if DEMO
            loadUserLocal()
            loadLogs()
#else
            loadUser()
#endif
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
    
    var bpmView: some View {
        VStack(spacing: 20) {
            Text("BPM Alert at: \(sliderStringValue)")
                .font(.custom("Nunito-Bold", size: 20))
                .foregroundColor(darkBlueColor)
            Slider(value: $sliderValue, in: 0...4, step: 1) {
                Text("Slider")
            } minimumValueLabel: {
                Text("80")
                    .font(.custom("Montserrat-Thin", size: 20))
                    .foregroundColor(darkBlueColor)
            } maximumValueLabel: {
                Text("120")
                    .font(.custom("Montserrat-Thin", size: 20))
                    .foregroundColor(darkBlueColor)
            } onEditingChanged: { editing in
                isEditing = editing
                readBPM()
            }.tint(primaryColor)
                .padding(.horizontal, 50)
        }
    }
    
    var userData: some View {
        Group {
            Spacer().frame(height: 50)
            Text(self.displayName)
                .font(.custom("Nunito-Bold", size: 36))
                .foregroundColor(darkBlueColor)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
            Spacer().frame(height: 10)
            Text(self.email)
                .font(.custom("Montserrat-Thin", size: 20))
                .foregroundColor(darkBlueColor)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
            Spacer().frame(height: 10)
            Text("ParticipantID: " + self.patientID)
                .font(.custom("Montserrat-Thin", size: 20))
                .foregroundColor(darkBlueColor)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
            Spacer().frame(height: 20)
        }
    }
    
    var cellsView: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                Spacer().frame(height: 10)
#if !DEMO
                infoOption
                updateOption
#else
                statsView
                if logsIsEmpty == false {
                    shareOption
                    shareLink
                }
                resetOption
#endif
                logoutOption
            }
            .padding(10)
            .ignoresSafeArea(.all)
        }
    }
    
    var statsView: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Stats View",
                isDirectChildToContainer: true,
                content: {
                    StatsView(valuesData: valuesData, namesData: namesData)
                }
            )
        ) {
            ProfileCellView(image: "chart.pie", text: "How I used the App")
        }.simultaneousGesture(TapGesture().onEnded {
//            self.postData = topActions()
//            
//            for val in postData {
//                self.valuesData.append(Double(val.count))
//                self.namesData.append(val.eventName)
//            }
            topActions()
        })
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
            
            UserDefaults.standard.removeObject(forKey: accesoryX)
            UserDefaults.standard.removeObject(forKey: accesoryY)
            UserDefaults.standard.setValue(defaultBPM, forKey: bpmKEY)
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
                .accessibility(hidden: true)
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
            .accessibility(hidden: true)
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
            .accessibility(hidden: true)
    }
    
    func saveBPM() {
        var value = 100.0
        switch sliderValue {
        case 0:
            value = 80.0
        case 1:
            value = 90.0
        case 2:
            value = 100.0
        case 3:
            value = 110.0
        case 4:
            value = 120.0
        default:
            value = 100.0
        }
        UserDefaults.standard.set(value, forKey: bpmKEY)
    }
    
    func readBPM() {
        switch sliderValue {
        case 0:
            sliderStringValue = "80"
        case 1:
            sliderStringValue = "90"
        case 2:
            sliderStringValue = "100"
        case 3:
            sliderStringValue = "110"
        case 4:
            sliderStringValue = "120"
        default:
            sliderStringValue = "100"
        }
        saveBPM()
    }
    
    func loadBPM() {
        switch UserDefaults.standard.float(forKey: bpmKEY) {
        case 80.0:
            sliderValue = 0
            sliderStringValue = "80"
        case 90.0:
            sliderValue = 1
            sliderStringValue = "90"
        case 100.0:
            sliderValue = 2
            sliderStringValue = "100"
        case 110.0:
            sliderValue = 3
            sliderStringValue = "110"
        case 120.0:
            sliderValue = 4
            sliderStringValue = "120"
        default:
            sliderValue = 2
            sliderStringValue = "100"
        }
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
    
    func topActions() {
        var byEvent: [PostCount] = []
        var logActions = [String]()
        var counts: [String: Int] = [:]

        for log in logs {
            for action in log.actions {
                logActions.append(action.description)
            }
        }
        for item in logActions {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        for (key, value) in counts {
            byEvent.append(PostCount(eventName: key, count: value))
        }
        
        let sortedEvents = byEvent.sorted {
            $0.count > $1.count
        }
        
        for val in sortedEvents.first(elementCount: 5) {
            self.valuesData.append(Double(val.count))
            self.namesData.append(val.eventName)
        }
        return
//        return sortedEvents.first(elementCount: 5)
    }
}
