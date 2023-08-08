//
// This source file is part of the CS342 2023 Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import UIKit

struct Song: Identifiable {
    var id: String { title }
    let title: String
    let artist: String
    let coverString: String
    let spotifyURL: String
}

struct MeditationSpotifyView: View {
    @Environment(\.openURL)
    private var openURL
    
    let songs = [
        Song(
            title: "Balancing Emotions",
            artist: "To calm you down",
            coverString: "meditationThumbnail 1",
            spotifyURL: "https://open.spotify.com/track/2JHBuWOMSGHOWCoLrXAriB?si=5f6d601ac0664d93"
        ),
        Song(
            title: "Blowin' Off Steam",
            artist: "To calm you down",
            coverString: "meditationThumbnail 2",
            spotifyURL: "https://open.spotify.com/track/46biZBPkwqTzB70Pabb9ks?si=a1fd50e708d04512"
        ),
        Song(
            title: "Recenter and Realign",
            artist: "To calm you down",
            coverString: "meditationThumbnail 3",
            spotifyURL: "https://open.spotify.com/track/3wdROXnP25gPoEKLyubpqc?si=e1400690922a48e4"
        ),
        Song(
            title: "Chillin' Out",
            artist: "To calm you down",
            coverString: "meditationThumbnail 1",
            spotifyURL: "https://open.spotify.com/track/1buvmZ3wdzJ2I7mqd1ifNs?si=da278ed097b64953"
        ),
        Song(
            title: "Peace of Mind",
            artist: "To calm you down",
            coverString: "meditationThumbnail 2",
            spotifyURL: "https://open.spotify.com/track/5aP4bQuGcZIWzSoGGQeN0S?si=e7730ac057c34bfa"
        ),
        Song(
            title: "Serenity",
            artist: "To calm you down",
            coverString: "meditationThumbnail 3",
            spotifyURL: "https://open.spotify.com/track/3fd1dXUQ92rRnxKWyqgwcx?si=44e40d0ffd384cd9"
        ),
        Song(
            title: "The Jedi Way",
            artist: "To calm you down",
            coverString: "meditationThumbnail 1",
            spotifyURL: "https://open.spotify.com/track/1buvmZ3wdzJ2I7mqd1ifNs?si=da278ed097b64953"
        ),
        Song(
            title: "Hold yo Horses: Being Stable",
            artist: "To calm you down",
            coverString: "meditationThumbnail 2",
            spotifyURL: "https://open.spotify.com/track/7doeCRERLqKcAzEufAi44e?si=6fa0c7e046b4461e"
        )
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(songs) { song in
                    if let url = URL(string: song.spotifyURL) {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }) {
                            HStack {
                                Image(song.coverString)
                                    .resizable()
                                    .frame(width: 130, height: 130, alignment: .leading)
                                    .aspectRatio(contentMode: .fill)
                                    .accessibilityLabel("Thumbnail for song")
                                VStack(alignment: .leading) {
                                    Text(song.title).font(.custom("Nunito-Bold", size: 15))
                                    Text(song.artist).font(.custom("Nunito-Bold", size: 10))
                                }
                            }
                            .frame(width: 360, height: 120, alignment: .leading)
                            .foregroundColor(Color(#colorLiteral(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
                            .background(Color(#colorLiteral(red: 0.30, green: 0.79, blue: 0.94, alpha: 0.05)))
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
struct SpotifyView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationSpotifyView()
    }
}
#endif
