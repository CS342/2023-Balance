//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI

// swiftlint:disable closure_body_length
@main
struct Balance: App {
    @UIApplicationDelegateAdaptor(BalanceAppDelegate.self)
    var appDelegate
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    @StateObject var noteStore = NoteStore()
    @StateObject var drawStore = DrawStore()
    @StateObject var coloringStore = ColoringStore()
    @StateObject var userModel = AuthViewModel.shared
#if DEMO
    @StateObject var logStore = ActivityLogStore()
#endif
    @StateObject var activityLogEntry = ActivityLogEntry()
    @StateObject var bannerManager = PresentBannerManager()
    
    @Environment(\.scenePhase)
    var scenePhase
    @State var heartAlert = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if completedOnboardingFlow {
                    HomeView()
                } else {
                    OnboardingFlow()
                }
                if bannerManager.isPresented {
                    GlobalBannerContent(bannerManager: bannerManager)
                }
            }
            .testingSetup()
            .cardinalKit(appDelegate)
            .environmentObject(noteStore)
            .environmentObject(drawStore)
            .environmentObject(coloringStore)
            .environmentObject(userModel)
#if DEMO
            .environmentObject(logStore)
#endif
            .environmentObject(activityLogEntry)
            .environmentObject(bannerManager)
            .onAppear(perform: {
                if !userModel.existLocalUser(uid: demoID) {
                    userModel.createDemoUser()
                }
                
                let bmpStep = UserDefaults.standard.value(forKey: bpmKEY)
                if bmpStep == nil {
                    UserDefaults.standard.setValue(defaultBPM, forKey: bpmKEY)
                }
            })
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    activeApp()
                case .background:
                    backgroundApp()
                case .inactive:
                    inactiveApp()
                @unknown default:
                    print("ScenePhase: unexpected state")
                }
            }
            .onReceive( NotificationCenter.default.publisher( for: Notification.Name.heartAlert)) { _ in
                self.heartAlert = true
                appEvent(description: "App Opened via Heart Rate notification")
            }
        }
    }
    
    func inactiveApp() { }
    
    func backgroundApp() {
        let value = UserDefaults.standard.bool(forKey: StorageKeys.spotifyConnect)
        if value == false {
            activityLogEntry.reset()
        }
        self.heartAlert = false
    }
    
    func activeApp() {
        if heartAlert == false {
            appEvent(description: "App Opened manually")
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.standard.set(false, forKey: StorageKeys.spotifyConnect)
    }
    
    func appEvent(description: String) {
        activityLogEntry.addActionButton(actionDescription: description)
#if DEMO
        logStore.saveLog(activityLogEntry)
        ActivityLogStore.save(logs: logStore.logs) { result in
            if case .failure(let error) = result {
                print(error.localizedDescription)
            }
        }
#else
        ActivityStorageManager.shared.uploadActivity(activityLogEntry: activityLogEntry)
#endif
    }
}
