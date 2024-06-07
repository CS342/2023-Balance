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
import SwiftUI

class UserProfileRepositoryToLocal: ObservableObject {
    static let shared = UserProfileRepositoryToLocal()

    func createProfile(profile: ProfileUser, completion: @escaping (_ profile: ProfileUser?, _
                                                                    error: Error?) -> Void) {
        if profile.displayName.isEmpty {
            print("Error profile is nil")
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(profile)
            UserDefaults.standard.set(data, forKey: profile.id)
            UserDefaults.standard.set(profile.id, forKey: "lastPatient")
            completion(profile, nil)
        } catch {
            print("Unable to encode User (\(error))")
            completion(nil, error)
        }
    }
    
    func fetchProfile(userId: String, completion: @escaping (_ profile: ProfileUser?, _ error:
                                                                Error?) -> Void) {
        let userID = userId

        if let data = UserDefaults.standard.data(forKey: userID) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let profile = try decoder.decode(ProfileUser.self, from: data)
                UserDefaults.standard.set(profile.id, forKey: "lastPatient")
                completion(profile, nil)
            } catch {
                print("Unable to Decode User (\(error))")
                completion(nil, error)
            }
        }
        completion(nil, nil)
    }
    
    func existingProfile(userId: String) -> Bool {
        let userID = userId

        if UserDefaults.standard.data(forKey: userID) != nil {
            return true
        }
        return false
    }
    
    func fetchCurrentProfile(completion: @escaping (_ profile: ProfileUser?, _ error:
                                                        Error?) -> Void) {
        let userID = UserDefaults.standard.string(forKey: "lastPatient") ?? ""
        if userID.isEmpty {
            return
        }
        
        if let data = UserDefaults.standard.data(forKey: userID) {
            do {
                let decoder = JSONDecoder()
                let profile = try decoder.decode(ProfileUser.self, from: data)
                completion(profile, nil)
            } catch {
                print("Unable to Decode User (\(error))")
                completion(nil, error)
            }
        }
    }
        
    func removeCurrentProfile() {
        let userID = UserDefaults.standard.string(forKey: "lastPatient") ?? ""
        
        if userID.isEmpty {
            return
        }
        
        UserDefaults.standard.removeObject(forKey: "lastPatient")
    }
}
