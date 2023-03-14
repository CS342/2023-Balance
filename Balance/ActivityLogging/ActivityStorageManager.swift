//
//  StorageManager.swift
//  Balance
//
//  Created by Alexis Lowber on 3/5/23.
//  

import FirebaseAuth
import FirebaseStorage
import Foundation

// Activity Log Structure:
/*
    start timestamp (view appears)
    action (button press)
    action (button press)
    end timestamp (view disappears)
    total duration:
*/

// swiftlint:disable implicit_return
// swiftlint:disable force_unwrapping
// swiftlint:disable todo
class ActivityLogEntry: ObservableObject {
    var startTime: Date?
    var endTime: Date?
    var actions: [(Date, String)] = []
    
    init() {
        startTime = nil
        endTime = nil
        actions = []
    }
    
    func reset() {
        startTime = nil
        endTime = nil
        actions = []
    }
    
    func isEmpty() -> Bool {
        return startTime == nil || endTime == nil
    }
    
    func addAction(actionDescription: String) {
        let currentDate = Date.now
        actions.append((currentDate, actionDescription))
        
        // set start time if this is the first action
        startTime = startTime == nil ? currentDate : startTime
    }
    
    func endLog(actionDescription: String) {
        addAction(actionDescription: actionDescription)
        endTime = actions.last!.0
    }
    
    func toString() -> (String, String)? {
        guard startTime != nil && endTime != nil else {
            // TODO: add logging instead of printing
            print("Waning: cannot convert ActivityLogEntry to string without both start time and end time.")
            return nil
        }
        
        let durationStr = "duration: \(endTime!.timeIntervalSinceReferenceDate - startTime!.timeIntervalSinceReferenceDate)"
        
        let idStr = dateToString(date: startTime!)
        let startStr = "start: " + idStr
        let endStr = "end: " + dateToString(date: endTime!)
        
        var actionsStr = ""
        
        for (timestamp, action) in actions {
            actionsStr.append(dateToString(date: timestamp) + " " + action)
        }
        
        return (idStr, [startStr, actionsStr, durationStr, endStr].joined(separator: "\n"))
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.timeZone = .current
        
        return formatter.string(from: date)
    }
}


class ActivityStorageManager {
    static let shared = ActivityStorageManager()
    
    func uploadActivity(startID: String, activityLogEntryString: String) {
        // Authorize User: users should be signed in to use the app
        guard let user = Auth.auth().currentUser else {
            // TODO: switch to logging statement
            print("Error finding current user (FIRUser)")
            return
        }
        let userID = user.uid

        // prepare data
        guard let activityData = activityLogEntryString.data(using: .utf8) else {
            // TODO: switch to logging statement
            print("Error generating Data object from activity log")
            return
        }

        // prepare storage
        let storage = Storage.storage()
        let metadata = StorageMetadata()
        metadata.contentType = "activity/txt"
        
        let storageRef = storage.reference().child("users/\(userID)/activity/\(startID).txt")

        storageRef.putData(activityData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error while uploading file: ", error)
            }

            if let metadata = metadata {
                print("Metadata: ", metadata)
            }
        }
    }
}
