//
//  StorageManager.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/04/2023.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Foundation

class UserProfileRepository: ObservableObject {
    static let shared = UserProfileRepository()

    func createProfile(profile: ProfileUser, completion: @escaping (_ profile: ProfileUser?, _
                                                                          error: Error?) -> Void) {
        // Authorize User: users should be signed in to use the app
        guard let user = Auth.auth().currentUser else {
#if DEBUG
            print("Error finding current user (FIRUser)")
#endif
            return
        }
        if profile.displayName.isEmpty {
            print("Error profile is nil")
            return
        }
        
        let userID = user.uid
        let database = Firestore.firestore()
        do {
            try database.collection("users").document("\(userID)/data/profile.txt").setData(from: profile, merge: true)
            completion(profile, nil)
        } catch {
            print("Error writing to Firestore: \(error)")
            completion(nil, error)
        }
    }
    
    func fetchProfile(userId: String, completion: @escaping (_ profile: ProfileUser?, _ error:
                                                                Error?) -> Void) {
        let database = Firestore.firestore()
        let userID = userId

        database.collection("users").document("\(userID)/data/profile.txt").getDocument { snapshot, error in
            let profile = try? snapshot?.data(as: ProfileUser.self)
            completion(profile, error)
        }
    }
    
    func fetchCurrentProfile(completion: @escaping (_ profile: ProfileUser?, _ error:
                                                                Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
#if DEBUG
            print("Error finding current user (FIRUser)")
#endif
            return
        }
        
        let userID = user.uid
        let database = Firestore.firestore()

        database.collection("users").document("\(userID)/data/profile.txt").getDocument { snapshot, error in
            let profile = try? snapshot?.data(as: ProfileUser.self)
            completion(profile, error)
        }
    }
}
