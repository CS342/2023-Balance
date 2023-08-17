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
    @EnvironmentObject var coloringStore: ColoringStore
    var draw: Draw

    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboar = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboar.instantiateViewController(withIdentifier: "Home") as! ViewController
        controller.coloringStore = coloringStore
        controller.draw = draw
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

struct DrawSketch: View {
    var draw: Draw

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                HeaderMenu(title: "Coloring Something")
                Storyboardview(draw: draw).edgesIgnoringSafeArea(.all)
            }
        }
    }
}
