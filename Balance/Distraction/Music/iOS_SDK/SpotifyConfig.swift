//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation

// swiftlint:disable convenience_type force_unwrapping
struct SpotifyConfig {
    static let accessTokenKey = "access-token-key"
    static let redirectUri = URL(string: "balanceapp://spotify")!
    static let spotifyClientId = SpotifyKeys.clientID
    static let spotifyClientSecretKey = SpotifyKeys.secretID
    
    static let scopes: SPTScope = [
        .userReadEmail,
        .userReadPrivate,
        .userReadPlaybackState,
        .userModifyPlaybackState,
        .userReadCurrentlyPlaying,
        .streaming,
        .appRemoteControl,
        .playlistReadCollaborative,
        .playlistModifyPublic,
        .playlistReadPrivate,
        .playlistModifyPrivate,
        .userLibraryModify,
        .userLibraryRead,
        .userTopRead,
        .userReadPlaybackState,
        .userReadCurrentlyPlaying,
        .userFollowRead,
        .userFollowModify
    ]
    
    static let stringScopes = [
        "user-read-email",
        "user-read-private",
        "user-read-playback-state",
        "user-modify-playback-state",
        "user-read-currently-playing",
        "streaming",
        "app-remote-control",
        "playlist-read-collaborative",
        "playlist-modify-public",
        "playlist-read-private",
        "playlist-modify-private",
        "user-library-modify",
        "user-library-read",
        "user-top-read",
        "user-read-playback-position",
        "user-read-recently-played",
        "user-follow-read",
        "user-follow-modify"
    ]
}
