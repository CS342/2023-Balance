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
    @Published var isLoggedIn = false
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
                //                self.loadPersonalData(uid: user?.uid ?? "")
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
                print("an error occured: \(error.localizedDescription)")
                return
            } else {
                print("LOGIN OK: " + (result?.description ?? ""))
                
                guard let user = result?.user else {
                    return
                }
                print("User \(user.uid) signed in.")
                
                self.loadPersonalData(uid: user.uid)
            }
        }
    }
    
    func signUp(userData: ProfileUser) {
        Auth.auth().createUser(withEmail: userData.email, password: userData.password) { result, error in
            if let error = error {
                print("an error occured: \(error.localizedDescription)")
                return
            } else {
                print("SINGUP OK: " + (result?.description ?? ""))
                guard let user = result?.user else {
                    return
                }
                print("User \(user.uid) signed up.")
                
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
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    func loadPersonalData(uid: String) {
        UserProfileRepository.shared.fetchProfile(userId: uid) { profile, error in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                print("User: " + (profile?.description() ?? "-"))
                self.profile = profile
            }
        }
    }
    
    //    func compressImage(image: UIImage) -> UIImage {
    //        let resizedImage = image.aspectFittedToHeight(200)
    //        resizedImage.jpegData(compressionQuality: 0.2)
    //        return resizedImage
    //    }
    
    //    func updatePhotoURL(photoURL: URL) {
    //        print(Auth.auth().currentUser?.photoURL ?? "")
    //        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    //        changeRequest?.photoURL = photoURL
    //        changeRequest?.commitChanges(completion: { err in
    //            if let err = err {
    //                print(err.localizedDescription)
    //            }
    //            Auth.auth().currentUser?.reload(completion: { err in
    //                if let err = err {
    //                    print(err.localizedDescription)
    //                }
    //                print(Auth.auth().currentUser?.photoURL ?? "")
    //            })
    //        })
    //        Auth.auth().currentUser?.reload()
    //    }
    
    deinit {
        unbind()
    }
}
