//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import FHIR
import FHIRToFirestoreAdapter
import FirebaseAccount
import class FirebaseFirestore.FirestoreSettings
import FirestoreDataStorage
import FirestoreStoragePrefixUserIdAdapter
import HealthKit
import HealthKitDataSource
import HealthKitToFHIRAdapter
import Questionnaires
import Scheduler
import SwiftUI

class BalanceAppDelegate: CardinalKitAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: FHIR()) {
#if !DEMO
            if !FeatureFlags.disableFirebase {
                if FeatureFlags.useFirebaseEmulator {
                    FirebaseAccountConfiguration(emulatorSettings: (host: "localhost", port: 9099))
                } else {
                    FirebaseAccountConfiguration()
                }
                firestore
            }
            if HKHealthStore.isHealthDataAvailable() {
                healthKit
            }
            FirebaseAccountConfiguration()
#endif
        }
    }
    
    private var firestore: Firestore<FHIR> {
        let settings = FirestoreSettings()
        if FeatureFlags.useFirebaseEmulator {
            settings.host = "localhost:8080"
            settings.isPersistenceEnabled = false
            settings.isSSLEnabled = false
        }
        
        return Firestore(
            adapter: {
                FHIRToFirestoreAdapter()
                FirestoreStoragePrefixUserIdAdapter()
            },
            settings: settings
        )
    }
    
    
    private var healthKit: HealthKit<FHIR> {
        HealthKit {
            CollectSample(
                HKQuantityType(.stepCount),
                deliverySetting: .anchorQuery(.afterAuthorizationAndApplicationWillLaunch)
            )
        } adapter: {
            HealthKitToFHIRAdapter()
        }
    }


    func application(
      _ application: UIApplication,
      configurationForConnecting connectingSceneSession: UISceneSession,
      options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}
