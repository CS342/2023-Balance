//
//  SpotifyConstants.swift
//  Balance
//
//  Created by Vishnu Ravi on 2/22/23.
//

import Foundation

let accessTokenKey = "access-token-key"
let redirectUri = URL(string:"balanceapp://")
let spotifyClientId = "5ad120eaa5484078844d8be16d30909a"
let spotifyClientSecretKey = "secretKey"

let scopes: SPTScope = [
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
    .userFollowModify,
]

let stringScopes = [
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
    "user-follow-modify",
]
