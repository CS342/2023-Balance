//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct SleepView: View {
    @Environment(\.openURL) var openURL
    
    // FOLLOWED A SPOTIFY YOUTUBE TUTORIAL
    struct Song: Identifiable {
        var id: String { title }
        let title: String
        let artist: String
        let coverString: String
        let spotifyURL: String
    }
    
    let songs = [
        Song(title: "Sleep 1", artist: "To help you sleep", coverString:"meditationThumbnail 1", spotifyURL: "https://open.spotify.com/track/2sr8v2aNZ7lZ8tV3eAR5qt?si=bbbfa9d35a104ec7"),
        Song(title: "Sleep 2", artist: "To help you sleep", coverString:"meditationThumbnail 2", spotifyURL: "https://open.spotify.com/track/475L4j7qFaZE0jlcvrsScN?si=04f4eb003ce94c66"),
        Song(title: "Sleep 3", artist: "To help you sleep", coverString:"meditationThumbnail 3", spotifyURL: "https://open.spotify.com/track/0N5NNIaNs3YVhiyt22ZYhG?si=5ecc0e2fc507461f"),
        Song(title: "Sleep 4", artist: "To help you sleep", coverString:"meditationThumbnail 1", spotifyURL: "https://open.spotify.com/track/0CMYUXTTTmI6Lwc0opH2XG?si=3399143e6a154fb9"),
        Song(title: "Sleep 5", artist: "To help you sleep", coverString:"meditationThumbnail 2", spotifyURL:  "https://open.spotify.com/track/5F820xSuKiMLpGOV04Xs3c?si=8601ea70e87744d8"),
        Song(title: "Sleep 6", artist: "To help you sleep", coverString:"meditationThumbnail 3", spotifyURL: "https://open.spotify.com/track/6MePLoqcI97WjWyx5Sq2JV?si=6cee5d6e859542ad"),
        Song(title: "Sleep 7", artist: "To help you sleep", coverString:"meditationThumbnail 1", spotifyURL: "https://open.spotify.com/track/1SucXU3xTOCyBAAqE22E8B?si=3147950d3de04a52"),
        Song(title: "Sleep 8", artist: "To help you sleep", coverString:"meditationThumbnail 2", spotifyURL:  "https://open.spotify.com/track/5NWOEqOSCqHebuRMjYEn1i?si=bc627872f8d14624")
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(songs) { song in
                    if let url = URL(string: song.spotifyURL) {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }){
                            HStack {
                                Image(song.coverString)
                                    .resizable()
                                    .frame(width: 130, height: 130, alignment: .leading)
                                    .aspectRatio(contentMode: .fill)
                                VStack(alignment: .leading) {
                                    Text(song.title).font(.custom("Nunito-Bold", size: 15))
                                    Text(song.artist).font(.custom("Nunito-Bold", size: 10))
                                }
                            }
                            .frame(width: 360, height: 120, alignment: .leading)
                            .foregroundColor(Color(#colorLiteral(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
                            .background(Color(#colorLiteral(red: 0.30, green: 0.79, blue: 0.94, alpha: 0.05)))
                            .cornerRadius(40)
                            .padding()
                        }
                    }
                }
            }
        }
    }
}

struct SleepView_Previews: PreviewProvider {
    static var previews: some View {
        SleepView()
    }
}
