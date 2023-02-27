//
//  MeditationView.swift
//  Balance
//
//  Created by Daniel Guo on 2/26/23.
//

import SwiftUI

struct MeditationView: View {
    var body: some View {
        NavigationView {
            HeaderMenu(title: "Guided Meditation")
            ScrollView (.horizontal) {
                HStack{
                    VideoView(videoID: "0ZKqLcWdG-4")
                        .frame(width: 400, height: 250)
                    VideoView(videoID: "iN6g2mr0p3Q")
                        .frame(width: 400, height: 250)
                    VideoView(videoID: "F0WYFXxhPGY")
                        .frame(width: 400, height: 250)
                    VideoView(videoID: "vQxTUQhVbg4")
                        .frame(width: 400, height: 250)
                }
            }
        }
    }
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationView()
    }
}
