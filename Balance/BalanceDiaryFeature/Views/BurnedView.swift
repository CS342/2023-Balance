//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// code based on: https://betterprogramming.pub/how-to-create-amazing-animations-in-swiftui-3c2970ee6e0
//
// SPDX-License-Identifier: MIT
//


import SwiftUI
import UIKit

struct BurnedView: View {
    @State var frameImage: String = ""
    @Binding var burningNote: Bool
    @Binding var showingEditor: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Image(frameImage)
                .resizable()
                .frame(width: 400, height: 875, alignment: .center)
                .aspectRatio(contentMode: .fill)
                .onAppear(perform: updateFrame)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    func updateFrame() {
        var frameIndex = 1
        let numFrames = 29
        let speed = 0.08
        
        _ = Timer.scheduledTimer(withTimeInterval: speed, repeats: true, block: { timer in
            frameImage = "burningPaper\(frameIndex)"
            frameIndex += 1
            if frameIndex > numFrames {
                timer.invalidate()
                burningNote.toggle()
                showingEditor.toggle()
            }
        })
    }
}

struct BurnedView_Previews: PreviewProvider {
    static var previews: some View {
        BurnedView(
            burningNote: .constant(true),
            showingEditor: .constant(false)
        )
    }
}
