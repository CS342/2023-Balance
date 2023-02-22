//
//  SceneDelegate.swift
//  Balance
//
//  Created by Vishnu Ravi on 2/22/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var spotifyController = SpotifyViewController.shared

//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window!.makeKeyAndVisible()
//        window!.windowScene = windowScene
//        window!.rootViewController = rootViewController
//    }

    // For spotify authorization and authentication flow
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        let parameters = spotifyController.appRemote.authorizationParameters(from: url)
        if let code = parameters?["code"] {
            spotifyController.responseCode = code
        } else if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            spotifyController.accessToken = access_token
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("No access token error =", error_description)
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
