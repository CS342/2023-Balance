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

class ImageReviewRepository: ObservableObject {
    static let shared = ImageReviewRepository()

    func createPhoto(photo: Photo, completion: @escaping (_ photo: Photo?, _
                                                                          error: Error?) -> Void) {
        // Authorize User: users should be signed in to use the app
        guard let user = Auth.auth().currentUser else {
#if DEBUG
            print("Error finding current user (FIRUser)")
#endif
            return
        }
        if photo.name.isEmpty {
            print("Error photo is nil")
            return
        }
        
        let userID = user.uid
        let database = Firestore.firestore()
        let startID = Date.now
        
        do {
            try database.collection("users").document("\(userID)/imageReview/\(startID).txt").setData(from: photo, merge: false)
            completion(photo, nil)
        } catch {
            print("Error writing to Firestore: \(error)")
            completion(nil, error)
        }
    }
}
