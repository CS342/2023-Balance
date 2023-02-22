//
//  SpotifyView.swift
//  Balance
//
//  Created by Vishnu Ravi on 2/22/23.
//

import UIKit
import SwiftUI

struct SpotifyView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        SpotifyViewController.shared
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
