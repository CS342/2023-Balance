//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct Music: View {
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "Music")
                
                VStack(alignment: .center, spacing: 10) {
                    SpotifyView()
                    Spacer()
                }
            }
        }
    }
}

struct Music_Previews: PreviewProvider {
    static var previews: some View {
        Music()
    }
}
