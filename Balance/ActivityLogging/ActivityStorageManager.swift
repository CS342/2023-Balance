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

// swiftlint:disable all

struct LogAction {
    let sessionID: String
    let sessionStartTime: Date
    let sessionEndTime: Date
    let sessionDuration: Int
    let description: String
    let startTime: Date
    let endTime: Date
    let duration: Int
}

struct Action: Codable {
    var id = UUID().uuidString
    let description: String
    let startTime: Date
    var endTime = Date.now
    var duration: Int = 0
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
    var startTime = Date()
    var endTime = Date.now
    var duration: Int = 0
    var actions: [Action] = []
    
    func reset() {
        id = UUID().uuidString
        startTime = Date()
        endTime = startTime
        duration = 0
        actions = []
    }
    
    func isEmpty() -> Bool {
        return getDuration() == 0
    }
    
    func addAction(actionDescription: String) {
        let currentDate = Date.now
        actions.append(Action(description: actionDescription, startTime: currentDate))
    }
    
    func addActionButton(actionDescription: String) {
        let currentDate = Date.now
        actions.append(
            Action(
                description: actionDescription,
                startTime: currentDate,
                endTime: currentDate,
                duration: 0
            )
        )
        // set start time if this is the first action
        startTime = currentDate
        endTime = currentDate

        duration = 0
    }
    
    func endLog(actionDescription: String) {
        let currentEndDate = Date.now
        let startAction = actions.last(where: {
            $0.description == actionDescription.replacingOccurrences(of: "Closed", with: "Opened")
        })
        
        if startAction == nil {
            return
        }
        let interval = currentEndDate - startAction!.startTime
        actions.append(
            Action(
                description: actionDescription.replacingOccurrences(of: "Closed ", with: ""),
                startTime: startAction!.startTime,
                endTime: currentEndDate,
                duration: interval.second ?? 0
            )
        )
        actions = actions.filter( {
            $0.id != startAction?.id
        })
        
        if actionDescription.contains("Closed Image Highlight") ||
            actionDescription.contains("Closed Image Selected") ||
            actionDescription.contains("Closed Video Highlight") ||
            actionDescription.contains("Closed Video Selected") ||
            actionDescription.contains("Closed Sudoku Game") ||
            actionDescription.contains("Closed Crossover Game") ||
            actionDescription.contains("Closed Guess the Emotion") ||
            actionDescription.contains("Closed How is your mood") ||
            actionDescription.contains("Closed New Draw") ||
            actionDescription.contains("Closed Mandala Selected") ||
            actionDescription.contains("Closed Coloring Saved") ||
            actionDescription.contains("Closed Draw Saved") ||
            actionDescription.contains("Closed Playing Spotify") ||
            actionDescription.contains("Closed Body sensations Part") ||
            actionDescription.contains("Closed Breathing Feature") ||
            actionDescription.contains("Closed Guided meditation Feature") {
            if (interval.second ?? 0)  > coinsTime {
                NotificationCenter.default.post(name: Notification.Name.coinsUpdate, object: nil)
            }
        }
        
        print(interval.second ?? 0)
        startTime = actions.first!.startTime
        endTime = actions.last!.endTime
        let intervalSession = endTime - startTime
        duration = intervalSession.second ?? 0
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
