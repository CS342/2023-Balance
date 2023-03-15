//
//  StorageManager.swift
//  Balance
//
//  Created by Alexis Lowber on 3/5/23.
//  

import FirebaseAuth
import Foundation
import FirebaseFirestore
import FirebaseCore


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
struct Action: Codable {
    let time: Date
    let description: String
}

class ActivityLogEntry: ObservableObject, Codable {
    var startTime: Date = Date(timeIntervalSinceReferenceDate: 0)
    var endTime: Date = Date(timeIntervalSinceReferenceDate: 0)
    var duration: TimeInterval = 0
    var actions: [Action] = []
    
    enum CodingKeys: String, CodingKey {
        case startTime
        case endTime
        case duration
        case actions
    }
    
    func reset() {
        startTime = Date(timeIntervalSinceReferenceDate: 0)
        endTime = startTime
        duration = 0
        actions = []
    }
    
    func isEmpty() -> Bool {
        return getDuration() == TimeInterval(0)
    }
    
    func addAction(actionDescription: String) {
        let currentDate = Date.now
        actions.append(Action(time: currentDate, description: actionDescription))
        
        // set start time if this is the first action
        startTime = startTime == Date(timeIntervalSinceReferenceDate: 0) ? currentDate : startTime
    }
    
    func endLog(actionDescription: String) {
        addAction(actionDescription: actionDescription)
        endTime = actions.last!.time
        duration = getDuration()
    }
    
    func getDuration() -> TimeInterval {
        return endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
    }
    
    func toString() -> (String, String) {
        let idStr = dateToString(date: startTime)
        
        let startStr = "start: " + idStr
        let endStr = endTime != Date(timeIntervalSinceReferenceDate: 0) ? "end: " + dateToString(date: endTime) : ""
        let durationStr = "duration: \(duration)"
        
        var actionsStr = ""
        
        for action in actions {
            actionsStr.append("\(dateToString(date: action.time) + " " + action.description)\n")
        }
        
        return (idStr, [startStr, actionsStr, durationStr, endStr].joined(separator: "\n"))
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = .current
        
        return formatter.string(from: date)
    }
}


class ActivityStorageManager {
    static let shared = ActivityStorageManager()
    
    func uploadActivity(activityLogEntry: ActivityLogEntry) {
        guard !activityLogEntry.isEmpty() else {
            // TODO: switch to logging statement
            print("Cannot send activity data without both start and end time fields")
            return
        }
        
        // Authorize User: users should be signed in to use the app
        guard let user = Auth.auth().currentUser else {
            // TODO: switch to logging statement
            print("Error finding current user (FIRUser)")
            return
        }
        let userID = user.uid
        
        let db = Firestore.firestore()
        
        let startID = "\(activityLogEntry.dateToString(date: activityLogEntry.startTime))"
        
        do {
            try db.collection("users").document("\(userID)/activity/\(startID).txt").setData(from: activityLogEntry)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
}
