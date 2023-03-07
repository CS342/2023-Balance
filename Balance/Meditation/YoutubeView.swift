//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct YoutubeView: View {
    let videoIDArray = [
        "L7u5N2MfTNU",
        "0ZKqLcWdG-4",
        "TgfycCiZl8s",
        "-OmL4t8LEoE",
        "W38Xhg0afWs",
        "FjI9v-VYwZY",
        "qxyVCjp48S4",
        "BEYZ19W8dHc",
        "vFL5NVkn-CY",
        "vQxTUQhVbg4",
        "iN6g2mr0p3Q",
        "wyj8l9miy4w",
        "qUcC71-W9Os",
        "q69GKrgNpeA",
        "PO6OPT78OwQ",
        "Mb19Ee8Dino",
        "rpJYACy8ZoI",
        "pDm_na_Blq8"
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(videoIDArray, id: \.self) { vidID in
                    VideoView(videoID: vidID)
                        .frame(width: 360, height: 200)
                        .cornerRadius(40)
                        .padding()
                }
            }
        }
    }
}

struct YoutubeView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeView()
    }
}
