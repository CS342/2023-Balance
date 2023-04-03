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
    
    var body: some View {
        HeaderMenu(title: "Guided Meditation")
        VStack(alignment: .center, spacing: 10) {
            highlightsTitle
            Spacer()
            ScrollView(.horizontal) {
                HStack {
                    videosArrayView
                }
            }
            categoriesTitle
            tagsView
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
            Spacer()
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
    }
    
    var highlightsTitle: some View {
        Text("Highlights").font(.custom("Nunito-Bold", size: 25))
            .foregroundColor(Color(#colorLiteral(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
            .offset(x: -110)
    }
    
    var categoriesTitle: some View {
        Text("Categories").font(.custom("Nunito-Bold", size: 20))
            .foregroundColor(Color(#colorLiteral(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
            .offset(x: -110)
    }
    
    var videosArrayView: some View {
        ForEach(videoIDArray, id: \.self) { vidID in
            // enable logging for a specific video being selected
            VideoView(videoID: vidID)
                .frame(width: 360, height: 200)
                .cornerRadius(20)
                .padding()
        }
    }
    
    var tagsView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 24) {
                selfGuidedButton
                youtubeButton
                sleepButton
            }
        }
        .padding()
    }
    
    var selfGuidedButton: some View {
        Button(action: {
            showingGuided = true
            showingYoutube = false
            showingSleep = false
        }) {
            Text("Self Guided")
                .font(.custom("Nunito", size: 18))
                .frame(width: 120, height: 30)
                .foregroundColor(.white)
                .background(Color(#colorLiteral(red: 0.45, green: 0.04, blue: 0.72, alpha: 1.00)))
                .cornerRadius(20)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "Viewing Self Guided Meditations"))
    }
    
    var youtubeButton: some View {
        Button(action: {
            showingGuided = false
            showingYoutube = true
            showingSleep = false
        }) {
            Text("Youtube")
                .font(.custom("Nunito", size: 18))
                .frame(width: 120, height: 30)
                .foregroundColor(.white)
                .background(Color(#colorLiteral(red: 0.45, green: 0.04, blue: 0.72, alpha: 1.00)))
                .cornerRadius(20)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "Viewing Youtube Meditations"))
    }
    
    var sleepButton: some View {
        Button(action: {
            showingGuided = false
            showingYoutube = false
            showingSleep = true
        }) {
            Text("Sleep")
                .font(.custom("Nunito", size: 18))
                .frame(width: 120, height: 30)
                .foregroundColor(.white)
                .background(Color(#colorLiteral(red: 0.45, green: 0.04, blue: 0.72, alpha: 1.00)))
                .cornerRadius(20)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "Viewing Sleep Meditations"))
    }
}

#if DEBUG
struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationView()
    }
}
#endif
