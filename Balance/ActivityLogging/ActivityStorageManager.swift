//
//  StorageManager.swift
//  Balance
//
//  Created by Alexis Lowber on 3/5/23.
//  

import Foundation
import FirebaseAuth
import FirebaseStorage

//need activity loggers to run in background? want one instantiated pr class or a shared logger? bc u can nav to other pages while still playing meditation music. but you can also turn off spotify...
//currently: we have individual tracks (so length based on length of tracks unless user pauses

//Structure:
/*
Feature
    start timestamp (view appears)
    action (button press)
    action (button press)
    end timestamp (view disappears)
    total duration:
*/

//views can't keep their own logs
//turn spotify off when: app registers pause

//NOTE: spotify distraction feature: goes to safari quickly to login then reroutes to app

//make custom button class? (nav can just use on view appear/disappear)
import Foundation


class ActivityLogEntry {
    //TODO: add getter?
    var startTime: Date
    var endTime: Date?
    var actions: [(Date, String)] = []
    
    init() {
        self.restart()
    }
    
    func restart() {
        startTime = Date.now
        endTime = nil
        actions = []
    }
    
    func addActivity(actionDescription: String) {
        let currentDate = Date.now
        actions.append((currentDate, actionDescription))
    }
    
    func endLog() {
        endTime = Date.now
    }
    
    func toString() -> (String, String) {
        
        let duration = endTime!.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
        
        let idStr = dateToString(date: startTime)
        let startStr = "start: " + idStr
        let endStr = "end: " + dateToString(date: endTime!)
        
        // actions.joined(separator: "\n")
        
        var actionsStr = ""
        
        for (timestamp, action) in actions {
            actionsStr.append(dateToString(date: timestamp) + " " + action)
        }
        
        return (idStr, [startStr, actionsStr, endStr].joined(separator: "\n"))
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.timeZone = .current
        
        return formatter.string(from: date)
    }
}

/*protocol ActivityLog {
    var activityLogEntry: ActivityLogEntry { get set }
    func sendActivityLog()
    
}*/

class ActivityStorageManager {
    static let shared = ActivityStorageManager()
    
    //view disappears --> alert activity storage manager
    //button clicked --> alert activity storage manager
    
    //storage manager
    /*
     distraction: spotify playing in app --> user clicks pause to stop it
     meditation: spotify navigates outside of app (does view disappear?? --> user has to navigate back to app to end session (view appears) ?? or selects back button
        - so view appears upon start and stop?
        - we don't know excatly how long the user is listening to a song? (they could just open a different app (instead of listening to music)
     */
    
    //when to publish a doc (when action is complete) ??
    //publush upon entering and separately publish upon completion ???
    
    //hold times in this class in case app is closed ->  can publish all times contained in this class
    
    func uploadActivity(startID: String, activityLogEntryString: String) {
        //Authorize User: users should be signed in to use the app
        guard let user = Auth.auth().currentUser else {
            //TODO: switch to logging statement
            print("Error finding current user (FIRUser)")
            return
        }
        let userID = user.uid

        //prepare data
        guard let activityData = activityLogEntryString.data(using: .utf8) else {
            //TODO: switch to logging statement
            print("Error generating Data object from activity log")
            return
        }

        //prepare storage
        let storage = Storage.storage()
        let metadata = StorageMetadata()
        metadata.contentType = "activity/txt"
        
        let storageRef = storage.reference().child("users/\(userID)/activity/\(startID).txt")

        storageRef.putData(activityData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error while uploading file: ", error)
            }

            if let metadata = metadata {
                print("Metadata: ", metadata)
            }
        }
    }
}
