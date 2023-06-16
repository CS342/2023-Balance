//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// Go to spotify developer console in order to generate a client key and secret key for this project
enum SpotifyKeys {
    static var clientID = Bundle.main.object(forInfoDictionaryKey: "SpotifyClientID") as? String ?? ""
    static var secretID = Bundle.main.object(forInfoDictionaryKey: "SpotifySecretID") as? String ?? ""
}
