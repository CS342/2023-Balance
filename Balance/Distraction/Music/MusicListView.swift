//
//  MusicListView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 24/05/2023.
//

import SwiftUI

// swiftlint:disable closure_body_length
// swiftlint:disable line_length
struct MusicListView: View {
    @StateObject var spotifyController = SpotifyController()
//    let spotifyController = SpotifyViewController.shared
    var connectedSpotify = false
    
    let songs = [
        Song(title: "Counting Sheep", artist: "To help you sleep", coverString: "meditationThumbnail 1", spotifyURL: "spotify:album:3M7xLE04DvF9sM9gnTBPdY"),
        Song(title: "Power Nap", artist: "To help you sleep", coverString: "meditationThumbnail 2", spotifyURL: "spotify:album:3M7xLE04DvF9sM9gnTBPdY"),
        Song(title: "Hittin' the Hay", artist: "To help you sleep", coverString: "meditationThumbnail 3", spotifyURL: "spotify:album:3M7xLE04DvF9sM9gnTBPdY"),
        Song(title: "Nighty Night", artist: "To help you sleep", coverString: "meditationThumbnail 1", spotifyURL: "spotify:album:3M7xLE04DvF9sM9gnTBPdY"),
        Song(title: "Mimimimimi", artist: "To help you sleep", coverString: "meditationThumbnail 2", spotifyURL: "spotify:album:3M7xLE04DvF9sM9gnTBPdY")
    ]
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "Music")
//                if spotifyController.appRemote.isConnected == true {
                    ScrollView(.vertical) {
                        VStack {
                            ForEach(songs) { song in
                                if let url = URL(string: song.spotifyURL) {
                                    Button(action: {
                                        spotifyController.playUri(uri: song.spotifyURL)
                                    }) {
                                        HStack {
                                            Image(song.coverString)
                                                .resizable()
                                                .frame(width: 130, height: 130, alignment: .leading)
                                                .aspectRatio(contentMode: .fill)
                                                .accessibilityLabel("Thumbnail")
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
//                    }
//                } else {
//                    Spacer()
//                    SpotifyView()
                    Spacer()
                }
            }
        }
        .onOpenURL { url in
            spotifyController.setAccessToken(from: url)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didFinishLaunchingNotification), perform: { _ in
            spotifyController.connect()
        })
    }
}

struct MusicListView_Previews: PreviewProvider {
    static var previews: some View {
        MusicListView()
    }
}
