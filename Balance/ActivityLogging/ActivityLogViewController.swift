//
//  ActivityLogViewController.swift
//  Balance
//
//  Created by Alexis Lowber on 3/10/23.
//

import Foundation

// Views utilizing UIViewController can inherit this to have activity loggin functionality
class ActivityLogViewController: UIViewController {
    var activityLogEntry: ActivityLogEntry
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityLogEntry.reset()
        print("view appeared: starting log")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        activityLogEntry.endLog()
        print("view disappeared, ending/sending log")
    }
    
    func sendActivityLog() {
        guard activityLogEntry.endTime != nil else {
            //TODO: use logging functonality
            print("Can't send log to storage because log is incomplete")
        }
        ActivityStorageManager.shared.uploadActivity(activityLogEntryString: activityLogEntry.toString())
    }

}
