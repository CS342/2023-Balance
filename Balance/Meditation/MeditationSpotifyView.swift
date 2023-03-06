//
// This source file is part of the CS342 2023 Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import UIKit
import SwiftUI

struct MeditationSpotifyView: View {
    @Environment(\.openURL) var openURL
    let spotifyURLArray = [
        "https://open.spotify.com/track/7doeCRERLqKcAzEufAi44e?si=6fa0c7e046b4461e",
        "https://open.spotify.com/track/2JHBuWOMSGHOWCoLrXAriB?si=5f6d601ac0664d93",
        "https://open.spotify.com/track/46biZBPkwqTzB70Pabb9ks?si=f315155074864e1d",
        "https://open.spotify.com/track/3wdROXnP25gPoEKLyubpqc?si=e1400690922a48e4",
        "https://open.spotify.com/track/5aP4bQuGcZIWzSoGGQeN0S?si=e7730ac057c34bfa",
        "https://open.spotify.com/track/1buvmZ3wdzJ2I7mqd1ifNs?si=da278ed097b64953",
        "https://open.spotify.com/track/3fd1dXUQ92rRnxKWyqgwcx?si=44e40d0ffd384cd9"
    ]
    
    var body: some View {
        ScrollView (.vertical) {
            VStack {
                ForEach(spotifyURLArray, id: \.self) { spotifyID in
                    if let url = URL(string: spotifyID) {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }) {
                            HStack {
                                Image("BalanceLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 20)
                                Text("Open in Spotify").font(.custom("Nunito-Bold", size: 25))
                            }
                            .frame(width: 360, height: 200)
                            .foregroundColor(Color(UIColor(red: 0.25, green: 0.38, blue: 0.50, alpha: 1.00)))
                            .background(Color(UIColor(red: 0.30, green: 0.79, blue: 0.94, alpha: 0.05)))
                            .cornerRadius(40)
                            .padding()
                        }
                    }
                }
            }
        }
    }
}


struct SpotifyView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationSpotifyView()
    }
}
