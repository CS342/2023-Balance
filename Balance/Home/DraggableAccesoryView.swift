//
//  DraggableAccesoryView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/11/2023.
//

import SwiftUI

struct DraggableAccesoryView: View {
    @State private var isDragging = false
    @State private var location: CGPoint
    
    private let imageName: String
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                self.location = value.location
                self.isDragging = true
            }
        
            .onEnded { _ in
                self.isDragging = false
                UserDefaults.standard.setValue(self.location.x, forKey: accesoryX)
                UserDefaults.standard.setValue(self.location.y, forKey: accesoryY)
            }
    }
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
            .background(Color.clear)
            .foregroundColor(isDragging ? .blue : .black)
            .position(location)
            .gesture(dragGesture)
            .accessibility(hidden: true)
            .clipped()
    }
    
    init(location: CGPoint, imageName: String) {
        self.location = location
        self.imageName = imageName
    }
}
