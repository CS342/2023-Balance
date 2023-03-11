//
//  ActivityLogViewController.swift
//  Balance
//
//  Created by Alexis Lowber on 3/10/23.
//

import Foundation

// Views utilizing UIViewController can inherit this to have activity loggin functionality
class ActivityLogViewController: UIViewController {
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
