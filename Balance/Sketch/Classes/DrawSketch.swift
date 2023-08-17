//
//  DrawSketch.swift
//  Balance
//
//  Created by Gonzalo Perisset on 16/08/2023.
//

import SwiftUI
import UIKit

// swiftlint: disable force_cast
struct Storyboardview: UIViewControllerRepresentable {
    var backgroundImage: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboar = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboar.instantiateViewController(withIdentifier: "Home") as! ViewController
        controller.backgroundImage = backgroundImage
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

struct DrawSketch: View {
    var backgroundImage: String
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                HeaderMenu(title: "Coloring Something")
                Storyboardview(backgroundImage: backgroundImage).edgesIgnoringSafeArea(.all)
            }
        }
    }
}
