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
    typealias UIViewControllerType = UIViewController
    

    func makeUIViewController(context: Context) -> UIViewController {
        SpotifyViewController.shared
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
