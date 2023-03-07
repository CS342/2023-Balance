//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct MeditationView: View {
    @State private var showingGuided = true
    @State private var showingYoutube = false
    @State private var showingSleep = false

    let videoIDArray = [
        "0ZKqLcWdG-4",
        "iN6g2mr0p3Q",
        "F0WYFXxhPGY",
        "vQxTUQhVbg4"
    ]

    // swiftlint:disable closure_body_length
    var body: some View {
        VStack {
            HeaderMenu(title: "Guided Meditation")
            Text("Highlights").font(.custom("Nunito-Bold", size: 25))
                .foregroundColor(Color(#colorLiteral(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
                .padding()
                .offset(x: -110)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(videoIDArray, id: \.self) { vidID in
                        VideoView(videoID: vidID)
                            .frame(width: 360, height: 200)
                            .cornerRadius(40)
                            .padding()
                    }
                }
            }
            Text("Categories").font(.custom("Nunito-Bold", size: 25))
                .foregroundColor(Color(#colorLiteral(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
                .offset(x: -110)
            ScrollView(.horizontal) {
                HStack {
                    Button(action: {
                        showingGuided = true
                        showingYoutube = false
                        showingSleep = false
                    }) {
                        Text("Self Guided")
                            .frame(width: 120, height: 30)
                            .foregroundColor(.white)
                            .background(Color(#colorLiteral(red: 0.45, green: 0.04, blue: 0.72, alpha: 1.00)))
                            .cornerRadius(40)
                    }
                    Button(action: {
                        showingGuided = false
                        showingYoutube = true
                        showingSleep = false
                    }) {
                        Text("Youtube")
                            .frame(width: 120, height: 30)
                            .foregroundColor(.white)
                            .background(Color(#colorLiteral(red: 0.45, green: 0.04, blue: 0.72, alpha: 1.00)))
                            .cornerRadius(40)
                    }
                    Button(action: {
                        showingGuided = false
                        showingYoutube = false
                        showingSleep = true
                    }) {
                        Text("Sleep")
                            .frame(width: 120, height: 30)
                            .foregroundColor(.white)
                            .background(Color(#colorLiteral(red: 0.45, green: 0.04, blue: 0.72, alpha: 1.00)))
                            .cornerRadius(40)
                    }
                }
            }
            if showingGuided {
                MeditationSpotifyView()
                    .padding()
            } else if showingYoutube {
                YoutubeView()
                    .padding()
            } else if showingSleep {
                SleepView()
                    .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct MeditationView_Previews: PreviewProvider {
//    @State private static var navigationPath = NavigationPath()

    static var previews: some View {
//        NavigationStack {
            MeditationView()
//        }
    }
}
