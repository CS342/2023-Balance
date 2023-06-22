//
//  ActivityLogButtonStyle.swift
//  Balance
//
//  Created by Alexis Lowber on 3/11/23.
//

import SwiftUI
import UIKit

// This class only logs information when the user interacts with a button (or some selectable content). We don't care when the view appers or disappears.
struct ActivityLogButtonStyle: PrimitiveButtonStyle {
    @EnvironmentObject var activityLogEntry: ActivityLogEntry
    @EnvironmentObject var logStore: ActivityLogStore

    let activityDescription: String
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onTapGesture {
                configuration.trigger()
                activityLogEntry.addAction(actionDescription: activityDescription)
#if DEMO
                    logStore.saveLog(activityLogEntry)
                    ActivityLogStore.save(logs: logStore.logs) { result in
                        if case .failure(let error) = result {
                            print(error.localizedDescription)
                        }
                    }
#else
                    ActivityStorageManager.shared.uploadActivity(activityLogEntry: activityLogEntry)
#endif
                    // for debugging
                    let activityLogEntryString = activityLogEntry.toString()
#if DEBUG
                    print("Sending activity log to storage manager: \(activityLogEntryString)")
#endif
                
#if DEBUG
                print(activityDescription)
#endif
            }
    }
}
