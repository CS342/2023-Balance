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


struct ActivityLogEntry {
    var startTime: Date
    var endTime: Date?
    var actions: [String]
}

class ActivityLogManager: UIViewController {
    var activityLogEntry: ActivityLogEntry!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        resetLog()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        endLog()
    }
    
    func resetLog() {
        activityLogEntry = ActivityLogEntry(startTime: Date.now, actions: [])
        print("view appeared: starting log")
    }
    
    func recordAction(actionStr: String) {
        activityLogEntry.actions.append(actionStr)
    }
    
    func endLog() {
        print("view disappeared, ending/sending log")
        activityLogEntry.endTime = Date.now
        ActivityStorageManager.shared.uploadActivity(activityLogEntry: activityLogEntry)
    }
}


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
    
    func uploadActivity(activityLogEntry: ActivityLogEntry) {
        //Authorize User: users should be signed in to use the app
        guard let user = Auth.auth().currentUser else {
            //TODO: switch to logging statement
            print("Error finding current user (FIRUser)")
            return
        }
        let userID = user.uid
        
        
        //create log entry
        guard activityLogEntry.endTime != nil else {
            print("cannot create activity log without value for end time ")
            return
        }
        
        let (activityID, activityStr) = generateActivityLogString(activityLogEntry: activityLogEntry)
        
        guard let activityData = activityStr.data(using: .utf8) else {
            //TODO: switch to logging statement
            print("Error generating Data object from activity log")
            return
        }

        //prepare storage
        let storage = Storage.storage()
        let metadata = StorageMetadata()
        metadata.contentType = "activity/txt"
        
        let storageRef = storage.reference().child("users/\(userID)/activity/\(activityID).txt")

        storageRef.putData(activityData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error while uploading file: ", error)
            }

            if let metadata = metadata {
                print("Metadata: ", metadata)
            }
        }
    }
    
    func generateActivityLogString(activityLogEntry: ActivityLogEntry) -> (String, String) {
        let duration = activityLogEntry.endTime!.timeIntervalSinceReferenceDate - activityLogEntry.startTime.timeIntervalSinceReferenceDate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.timeZone = .current
        
        let idStr = formatter.string(from: activityLogEntry.startTime)
        let startStr = "start: " + idStr
        let endStr = "end: " + formatter.string(from: activityLogEntry.endTime!)
        
        let actionsStr = activityLogEntry.actions.joined(separator: "\n")
        
        return (idStr, [startStr, actionsStr, endStr].joined(separator: "\n"))
    }
}
