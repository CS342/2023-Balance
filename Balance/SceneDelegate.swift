//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var spotifyController = SpotifyViewController.shared

    // For spotify authorization and authentication flow
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        let parameters = spotifyController.appRemote.authorizationParameters(from: url)
        if let code = parameters?["code"] {
            spotifyController.responseCode = code
        } else if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            spotifyController.accessToken = accessToken
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("No access token error =", errorDescription)
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if let accessToken = spotifyController.appRemote.connectionParameters.accessToken {
            spotifyController.appRemote.connectionParameters.accessToken = accessToken
            spotifyController.appRemote.connect()
        } else if let accessToken = spotifyController.accessToken {
            spotifyController.appRemote.connectionParameters.accessToken = accessToken
            spotifyController.appRemote.connect()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        if spotifyController.appRemote.isConnected {
            spotifyController.appRemote.disconnect()
        }
    }
}
