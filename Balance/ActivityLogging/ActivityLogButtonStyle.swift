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
    
    let activityDescription: String
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onTapGesture {
                configuration.trigger()
                activityLogEntry.addAction(actionDescription: activityDescription)
#if DEBUG
                print(activityDescription)
#endif
            }
    }
}
