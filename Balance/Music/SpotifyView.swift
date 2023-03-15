//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import UIKit


struct SpotifyView: UIViewControllerRepresentable {
    @EnvironmentObject var activityLogEntry: ActivityLogEntry
    
    func makeUIViewController(context: Context) -> SpotifyViewController {
        let spotifyViewController = SpotifyViewController.shared
        spotifyViewController.activityLogEntry = activityLogEntry
        return spotifyViewController
    }
    
    func updateUIViewController(_ uiViewController: SpotifyViewController, context: Context) {}
}
