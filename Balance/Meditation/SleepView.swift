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
    
    let sleepURLArray = [
        "https://open.spotify.com/track/5NWOEqOSCqHebuRMjYEn1i?si=bc627872f8d14624",
        "https://open.spotify.com/track/475L4j7qFaZE0jlcvrsScN?si=04f4eb003ce94c66",
        "https://open.spotify.com/track/0N5NNIaNs3YVhiyt22ZYhG?si=5ecc0e2fc507461f",
        "https://open.spotify.com/track/0CMYUXTTTmI6Lwc0opH2XG?si=3399143e6a154fb9",
        "https://open.spotify.com/track/5F820xSuKiMLpGOV04Xs3c?si=8601ea70e87744d8",
        "https://open.spotify.com/track/6MePLoqcI97WjWyx5Sq2JV?si=6cee5d6e859542ad",
        "https://open.spotify.com/track/1SucXU3xTOCyBAAqE22E8B?si=3147950d3de04a52"
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(sleepURLArray, id: \.self) { spotifyID in
                    if let url = URL(string: spotifyID) {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }) {
                            HStack {
                                Image("BalanceLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 20)
                                    .accessibilityLabel(Text("Balance Logo"))
                                Text("Open in Spotify").font(.custom("Nunito-Bold", size: 25))
                            }
                            .frame(width: 360, height: 200)
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
