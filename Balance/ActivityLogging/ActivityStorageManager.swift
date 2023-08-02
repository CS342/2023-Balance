//
//  StorageManager.swift
//  Balance
//
//  Created by Alexis Lowber on 3/5/23.
//  

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
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
// swiftlint:disable untyped_error_in_catch

struct LogAction {
    let id: String
    let startTime: Date
    let endTime: Date
    let duration: TimeInterval
    let actionTime: Date
    let actionDesc: String
}

struct Action: Codable {
    var id = UUID().uuidString
    let description: String
    let startTime: Date
    var endTime = Date()
    var duration: TimeInterval = 0
}

class ActivityLogEntry: ObservableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case startTime
        case endTime
        case duration
        case actions
    }
    
    var id = UUID().uuidString
    var startTime = Date(timeIntervalSinceReferenceDate: 0)
    var endTime = Date(timeIntervalSinceReferenceDate: 0)
    var duration: TimeInterval = 0
    var actions: [Action] = []
    
    func reset() {
        id = UUID().uuidString
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
        actions.append(Action(description: actionDescription, startTime: currentDate))
        
        // set start time if this is the first action
        startTime = startTime == Date(timeIntervalSinceReferenceDate: 0) ? currentDate : startTime
    }
    
    func addActionButton(actionDescription: String) {
        let sessionID = UserDefaults.standard.string(forKey: "SessionID")

        let currentDate = Date.now
        actions.append(
            Action(
                description: actionDescription,
                startTime: Date.now,
                endTime: Date.now,
                duration: getDuration(endDate: Date.now, startDate: Date.now)
            )
        )
        id = sessionID!
        // set start time if this is the first action
        startTime = startTime == Date(timeIntervalSinceReferenceDate: 0) ? currentDate : startTime
        endTime = startTime
        duration = getDuration()
    }
    
    func endLog(actionDescription: String) {
        let currentEndDate = Date.now
        let startAction = actions.last(where: {
            $0.description == actionDescription.replacingOccurrences(of: "Closed", with: "Opened")
        })
        
        actions.append(
            Action(
                description: actionDescription.replacingOccurrences(of: "Closed", with: ""),
                startTime: startAction!.startTime,
                endTime: currentEndDate,
                duration:
                    getDuration(endDate: currentEndDate, startDate: startAction!.startTime)
            )
        )
        actions = actions.filter( {
            $0.id != startAction?.id
        })

        
        // set start time if this is the first action
//        startTime = startTime == Date(timeIntervalSinceReferenceDate: 0) ? currentDate : startTime
        
//        addAction(actionDescription: actionDescription)
        endTime = actions.last!.startTime
        duration = getDuration()
    }
    
    func getDuration(endDate: Date, startDate: Date) -> TimeInterval {
        return endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
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
            actionsStr.append("\(dateToString(date: action.startTime) + " " + action.description)\n")
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
#if DEBUG
            print("Error finding current user (FIRUser)")
#endif
            return
        }
        let userID = user.uid
        
        let database = Firestore.firestore()
        
        let startID = "\(activityLogEntry.dateToString(date: activityLogEntry.startTime))"
        
        do {
            try database.collection("users").document("\(userID)/activity/\(startID).txt").setData(from: activityLogEntry)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
}
