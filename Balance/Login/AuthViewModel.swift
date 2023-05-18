//
//  AuthViewModel.swift
//  FireLogin
//
//  Created by sdecarli on 5/8/22.
//

import Account
import Combine
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI

struct User {
    var uid: String
    var email: String?
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}

final class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()
    @Published var isLoggedIn = false
    @Published var authError: String = ""
    @Published var profile: ProfileUser?
    @Published var session: User? {
        didSet {
            self.didChange.send(self)
        }
    }
    var handle: AuthStateDidChangeListenerHandle?
    private var didChange = PassthroughSubject<AuthViewModel, Never>()
    
    var user: User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    func listenAuthentificationState() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                if let user = user {
                    self.session = User(uid: user.uid, email: user.email)
                    self.isLoggedIn = true
                } else {
                    self.session = nil
                    self.isLoggedIn = false
                }
                print(auth)
            } else {
                self.isLoggedIn = false
            }
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signIn(
        emailAddress: String,
        password: String
    ) {
        Auth.auth().signIn(withEmail: emailAddress, password: password) { result, error in
            if let error = error {
                self.authError = error.localizedDescription
                print("SIGNIN an error occured: \(error.localizedDescription)")
                return
            } else {
                print("LOGIN OK: " + (result?.description ?? ""))
                
                guard let user = result?.user else {
                    return
                }
                print("User \(user.uid) signed in.")
                
                self.loadPersonalData(uid: user.uid)
                self.authError = ""
            }
        }
    }
    
    func signUp(userData: ProfileUser) {
        Auth.auth().createUser(withEmail: userData.email, password: userData.password) { result, error in
            if let error = error {
                self.authError = error.localizedDescription
                print("SIGNUP an error occured: \(error.localizedDescription)")
                return
            } else {
                print("SINGUP OK: " + (result?.description ?? ""))
                guard let user = result?.user else {
                    return
                }
                print("User \(user.uid) signed up.")
                self.authError = ""
                let profileUser = ProfileUser(
                    id: user.uid,
                    displayName: userData.displayName,
                    email: userData.email,
                    parentEmail: userData.parentEmail,
                    birthday: userData.birthday,
                    country: userData.country,
                    phone: userData.phone,
                    avatar: userData.avatar,
                    password: ""
                )
                
                UserProfileRepository.shared.createProfile(profile: profileUser) { profile, error in
                    if let error = error {
                        print("Error while fetching the user profile: \(error)")
                        return
                    } else {
                        print("User: " + (profile?.description() ?? "-"))
                        self.profile = profile
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
            self.profile = nil
        } catch let signOutError as NSError {
            print("SIGNOUT Error signing out: %@", signOutError)
        }
    }
    
    func signOut(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        do {
            try Auth.auth().signOut()
            self.session = nil
            self.profile = nil
            onSuccess()
        } catch let signOutError as NSError {
            print("SIGNOUT Error signing out: %@", signOutError)
            onError(signOutError.localizedDescription)
        }
    }
    
    func updatePassword(password: String) {
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            if let error = error as NSError? {
                print("UPDATEPASSWORD error occured: \(error.localizedDescription)")
                self.authError = error.localizedDescription
            } else {
                print("UPDATEPASSWORD OK")
                self.authError = "OK"
            }
        }
    }
    
    func passwordReset(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error as NSError? {
                print("RESETPASSWORD error occured: \(error.localizedDescription)")
                onError(error.localizedDescription)
            } else {
                print("UPDATEPASSWORD OK")
                onSuccess()
            }
        }
    }
    
    func deleteUser(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().currentUser?.delete(completion: { error in
            if let error = error as NSError? {
                print("DELETEUSER error occured: \(error.localizedDescription)")
                onError(error.localizedDescription)
            } else {
                print("DELETEUSER OK")
                onSuccess()
            }
        })
    }
    
    func loadPersonalData(uid: String) {
        UserProfileRepository.shared.fetchProfile(userId: uid) { profile, error in
            if let error = error {
                print("LOADPERSONALDATA Error while fetching the user profile: \(error)")
                return
            } else {
                print("User: " + (profile?.description() ?? "-"))
                self.profile = profile
            }
        }
    }
    
    
    deinit {
        unbind()
    }
}
