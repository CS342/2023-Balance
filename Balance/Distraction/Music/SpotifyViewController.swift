//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
// Adapted from https://github.com/jrasmusson/swift-arcade/Spotify
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import UIKit

class SpotifyViewController: UIViewController {
    static let shared = SpotifyViewController()
    @Published var connectedSpotify = false
    private let myArray = [
        "spotify:album:3M7xLE04DvF9sM9gnTBPdY",
        "spotify:track:7lEptt4wbM0yJTvSG5EBof",
        "spotify:track:0EANQDy9R0iyVz27nGiDvQ",
        "spotify:album:3M7xLE04DvF9sM9gnTBPdY",
        "spotify:track:7lEptt4wbM0yJTvSG5EBof",
        "spotify:track:0EANQDy9R0iyVz27nGiDvQ",
        "spotify:album:3M7xLE04DvF9sM9gnTBPdY",
        "spotify:track:7lEptt4wbM0yJTvSG5EBof",
        "spotify:track:0EANQDy9R0iyVz27nGiDvQ",
        "spotify:album:3M7xLE04DvF9sM9gnTBPdY",
        "spotify:track:7lEptt4wbM0yJTvSG5EBof",
        "spotify:track:0EANQDy9R0iyVz27nGiDvQ"
    ]
    var currentUri = silentTrack
    
    var responseCode: String? {
        didSet {
            fetchAccessToken { dictionary, error in
                if let error = error {
                    print("Fetching token request error \(error)")
                    return
                }
                let accessToken = dictionary?["access_token"] as? String
                UserDefaults.standard.set(accessToken, forKey: "access_token")
                DispatchQueue.main.async {
                    self.appRemote.connectionParameters.accessToken = accessToken
                    self.appRemote.connect()
                }
            }
        }
    }

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()

    var accessToken = UserDefaults.standard.string(forKey: SpotifyConfig.accessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: SpotifyConfig.accessTokenKey)
        }
    }

    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyConfig.spotifyClientId, redirectURL: SpotifyConfig.redirectUri)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating
        // otherwise another app switch will be required
        
        // replace this placeholder URI with the desired URI
        configuration.playURI = currentUri
        
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()

    lazy var sessionManager: SPTSessionManager? = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()

    private var lastPlayerState: SPTAppRemotePlayerState?

    var activityLogEntry: ActivityLogEntry?
    
    // MARK: - Subviews
    let stackView = UIStackView()
    let stackInstallView = UIStackView()
    let safeArea = UIView()
    let appInstallImage = UIImageView()
    let appInstallLabel = UILabel()
    let imageView = UIImageView()
    let trackLabel = UILabel()
    let playPauseButton = UIButton(type: .system)
    var myTableView = UITableView()

    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        print("Spotify view start")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewBasedOnConnected()
    }

    func update(playerState: SPTAppRemotePlayerState) {
        if lastPlayerState?.track.uri != playerState.track.uri {
            fetchArtwork(for: playerState.track)
        }
        lastPlayerState = playerState
        trackLabel.text = playerState.track.name

        let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        if playerState.isPaused {
            activityLogEntry?.addAction(actionDescription: "Playing Spotify")
            playPauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: configuration), for: .normal)
        } else {
            activityLogEntry?.addAction(actionDescription: "Pausing Spotify")
            playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: configuration), for: .normal)
        }
    }

    // MARK: - Actions
    @objc
    func didTapPauseOrPlay(_ button: UIButton) {
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            appRemote.playerAPI?.resume(nil)
        } else {
            appRemote.playerAPI?.pause(nil)
        }
    }

    @objc
    func didTapSignOut(_ button: UIButton) {
        if appRemote.isConnected == true {
            appRemote.disconnect()
        }
    }

    @objc
    func didTapConnect(_ button: UIButton) {
        activityLogEntry?.addAction(actionDescription: "Connecting Spotify")
        guard let sessionManager = sessionManager else {
            return
        }
        sessionManager.initiateSession(with: SpotifyConfig.scopes, options: .clientOnly)
    }
        
    @objc
    func playTapped(uri: String) {
        currentUri = uri
        if appRemote.isConnected {
            appRemote.playerAPI?.play(currentUri, asRadio: false, callback: { value, error in
                if error == nil {
                    print("Spotify playUri error")
                } else {
                    print("Spotify playUri" + value.debugDescription )
                }
            })
        } else {
            activityLogEntry?.addAction(actionDescription: "Connecting Spotify")
            sessionManager = nil
            configuration.playURI = currentUri
            sessionManager = SPTSessionManager(configuration: configuration, delegate: self)
            sessionManager?.initiateSession(with: SpotifyConfig.scopes, options: .clientOnly)
        }
    }
    
    // MARK: - Private Helpers
    private func presentAlertController(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            controller.addAction(action)
            self.present(controller, animated: true)
        }
    }
}

// MARK: Style & Layout
extension SpotifyViewController: UITableViewDelegate, UITableViewDataSource {
    func style() {
        installedApp()
        table()
        player()
    }

    func player() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.backgroundColor = UIColor(primaryColor)

        safeArea.translatesAutoresizingMaskIntoConstraints = false
        safeArea.backgroundColor = UIColor(primaryColor)
        view.addSubview(safeArea)
        NSLayoutConstraint.activate([
            safeArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            safeArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeArea.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        imageView.backgroundColor = UIColor.green
//        imageView.image = UIImage(named: "Spotify_icon")

        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        trackLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        trackLabel.textColor = UIColor.white
        trackLabel.textAlignment = .center
        trackLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        trackLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        trackLabel.backgroundColor = UIColor.yellow
//        trackLabel.text = "Hi World"

        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.addTarget(self, action: #selector(didTapPauseOrPlay), for: .primaryActionTriggered)
        playPauseButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        playPauseButton.backgroundColor = UIColor.blue

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(trackLabel)
        stackView.addArrangedSubview(playPauseButton)

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 100)
            //            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func installedApp() {
        stackInstallView.translatesAutoresizingMaskIntoConstraints = false
        stackInstallView.axis = .vertical
        stackInstallView.spacing = 20
        stackInstallView.alignment = .center
        
        appInstallImage.image = UIImage(named: "Spotify_icon")
        appInstallImage.contentMode = .scaleAspectFit
        appInstallImage.translatesAutoresizingMaskIntoConstraints = false
        appInstallImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        appInstallImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        appInstallLabel.text = "Please install Spotify to continue"
        appInstallLabel.textColor = UIColor(darkBlueColor)
        appInstallLabel.font = UIFont(name: "Nunito-Bold", size: 20)
        appInstallLabel.translatesAutoresizingMaskIntoConstraints = false
//        appInstallLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        appInstallLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        stackInstallView.addArrangedSubview(appInstallImage)
        stackInstallView.addArrangedSubview(appInstallLabel)
        view.addSubview(stackInstallView)

        NSLayoutConstraint.activate([
            stackInstallView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackInstallView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func table() {
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: balWidth, height: balHeight - 300))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.separatorStyle = .none

        view.addSubview(myTableView)
    }

    func updateViewBasedOnConnected() {
//        if isSpotifyInstalled() {
//            stackInstallView.isHidden = false
//            myTableView.isHidden = true
//            safeArea.isHidden = true
//            stackView.isHidden = true
//           return
//        }
    
        stackInstallView.isHidden = true
        
        if self.appRemote.isConnected == true {
            self.stackView.isHidden = false
            self.safeArea.isHidden = false
            self.myTableView.frame = CGRect(x: 0, y: 0, width: balWidth, height: balHeight - 330)
//            self.imageView.isHidden = false
//            self.trackLabel.isHidden = false
//            self.playPauseButton.isHidden = false
        } else { // show login
            self.stackView.isHidden = true
            self.safeArea.isHidden = true
            self.myTableView.frame = CGRect(x: 0, y: 0, width: balWidth, height: balHeight - 150)
//            self.imageView.isHidden = true
//            self.trackLabel.isHidden = true
//            self.playPauseButton.isHidden = true
        }
    }
    
    func isSpotifyInstalled() -> Bool {
        let isSpotifyAppInstalled = ((sessionManager?.isSpotifyAppInstalled) != nil)
        return isSpotifyAppInstalled
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
        playTapped(uri: myArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = myArray.count
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.selectionStyle = .none

        cell.contentConfiguration = UIHostingConfiguration {
            TrackCellView(image: "Spotify_icon", text: "\(myArray[indexPath.row])", duration: "3:21 segs")
        }
        
        return cell
    }
}

// MARK: - SPTAppRemoteDelegate
extension SpotifyViewController: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        updateViewBasedOnConnected()
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { _, error in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
        fetchPlayerState()
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        updateViewBasedOnConnected()
        lastPlayerState = nil
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        updateViewBasedOnConnected()
        lastPlayerState = nil
    }
}

// MARK: - SPTAppRemotePlayerAPIDelegate
extension SpotifyViewController: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        debugPrint("Spotify Track name: %@", playerState.track.name)
        update(playerState: playerState)
    }
}

// MARK: - SPTSessionManagerDelegate
extension SpotifyViewController: SPTSessionManagerDelegate {
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        if error.localizedDescription == "The operation couldn’t be completed. (com.spotify.sdk.login error 1.)" {
            print("AUTHENTICATE with WEBAPI")
        } else {
            presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
        }
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
}

// MARK: - Networking
extension SpotifyViewController {
    // swiftlint:disable discouraged_optional_collection
    func fetchAccessToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let url = URL(string: "https://accounts.spotify.com/api/token") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let clientString = SpotifyConfig.spotifyClientId + ":" + SpotifyConfig.spotifyClientSecretKey

        guard let clientStringData = clientString.data(using: .utf8) else {
            return
        }

        let spotifyAuthKey = "Basic \((clientStringData).base64EncodedString())"

        request.allHTTPHeaderFields = [
            "Authorization": spotifyAuthKey,
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        var requestBodyComponents = URLComponents()
        let scopeAsString = SpotifyConfig.stringScopes.joined(separator: " ")

        guard let responseCode else {
            return
        }

        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: SpotifyConfig.spotifyClientId),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: responseCode),
            URLQueryItem(name: "redirect_uri", value: SpotifyConfig.redirectUri.absoluteString),
            URLQueryItem(name: "code_verifier", value: ""), // not currently used
            URLQueryItem(name: "scope", value: scopeAsString)
        ]

        request.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                      print("Error fetching token \(error?.localizedDescription ?? "")")
                      return completion(nil, error)
                  }
            let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            print("Access Token Dictionary=", responseObject ?? "")
            completion(responseObject, nil)
        }
        task.resume()
    }

    func fetchArtwork(for track: SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] image, error in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                self?.imageView.image = image
            }
        })
    }

    func fetchPlayerState() {
        appRemote.playerAPI?.getPlayerState { [weak self] playerState, error in
            if let error = error {
                print("Error getting player state:" + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.update(playerState: playerState)
            }
        }
    }
}
