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

struct Playlist {
    var name: String
    var description: String
    var type: String
    var images: CoverImage
    var uri: String
}

struct CoverImage {
    var url: String
    var height: Int
    var width: Int
}

// swiftlint:disable all
class SpotifyViewController: UIViewController {
    static let shared = SpotifyViewController()
    @Published var connectedSpotify = false
    private var myArray = [Playlist]()
    var currentUri = silentTrack
    var isPause = false
    
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
    let openSpotifyButton = UIButton(type: .system)
    var myTableView = UITableView()
    var contentItems = [SPTAppRemoteContentItem]()
    
    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        print("Spotify view start")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewBasedOnConnected()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if appRemote.isConnected == true {
            if (self.currentUri == silentTrack) {
                appRemote.playerAPI?.pause(nil)
            }
        }
    }
    
    @objc
    func showTop() {
        SpotifyDataController.shared.getMyTop(type: "tracks") { data in
            guard let data = data else {
                return
            }
            guard let itemsArray = data["items"] as? [[String: AnyObject]] else { return }
            for track in itemsArray {
                guard let trackName = track["name"] as? String else { return }
                guard let trackDescription = track["description"] as? String else { return }
                guard let trackType = track["type"] as? String else { return }
                guard let trackUri = track["uri"] as? String else { return }
                let images = track["images"]
                let imageCover = (images as? [[String: AnyObject]])?.first
                let image = CoverImage(url: imageCover?["url"] as! String, height: 100, width:100)
                let trackObject = Playlist(name: trackName, description: trackDescription, type: trackType, images: image, uri: trackUri)
                self.myArray.append(trackObject)
            }
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
    }
    
    @objc
    func showPlaylists() {
        SpotifyDataController.shared.getMyPlaylists { data in
            guard let data = data else {
                return
            }
            self.myArray.removeAll()
            guard let itemsArray = data["items"] as? [[String: AnyObject]] else { return }
            for track in itemsArray {
                guard let trackName = track["name"] as? String else { return }
                guard let trackDescription = track["description"] as? String else { return }
                guard let trackType = track["type"] as? String else { return }
                guard let trackUri = track["uri"] as? String else { return }
                let images = track["images"]
                let imageCover = (images as? [[String: AnyObject]])?.first
                let image = CoverImage(url: imageCover?["url"] as! String, height: 100, width:100)
                let playlist = Playlist(name: trackName, description: trackDescription, type: trackType, images: image, uri: trackUri)
                self.myArray.append(playlist)
            }
            
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
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
            isPause = false
        } else {
            appRemote.playerAPI?.pause(nil)
            isPause = true
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
                    print("Spotify playUri")
                    self.isPause = false
                    self.updateViewBasedOnConnected()
                    
                } else {
                    print("Spotify playUri error" + value.debugDescription )
                }
            })
        } else {
            self.reconnect(uri: self.currentUri)
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
    func layout() {
        view.backgroundColor = UIColor(backgroundColor)
        installedApp()
        table()
        spotify()
        player()
    }
    
    func spotify() {
        openSpotifyButton.setTitle("Open Spotify", for: .normal)
        openSpotifyButton.titleLabel!.font = UIFont(name: "Nunito-Bold" , size: 18)
        openSpotifyButton.setTitleColor(UIColor.white, for: .normal)
        openSpotifyButton.backgroundColor = UIColor(red: 20/255, green: 215/255, blue: 96/255, alpha: 1.0)
        openSpotifyButton.roundCorners(.allCorners, radius: 25)
        openSpotifyButton.addShadow(shadowColor: UIColor.gray.cgColor, shadowOffset: CGSize(width: 0, height: -3), shadowOpacity: 0.2, shadowRadius: 5)
        openSpotifyButton.addTarget(self, action: #selector(handleRegister), for: .primaryActionTriggered)
        openSpotifyButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(openSpotifyButton)
        
        NSLayoutConstraint.activate([
            openSpotifyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            openSpotifyButton.heightAnchor.constraint(equalToConstant: 50),
            openSpotifyButton.widthAnchor.constraint(equalToConstant: 300),
            openSpotifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    func handleRegister(_ button: UIButton) {
        UIApplication.shared.open(URL(string: "https://open.spotify.com/")!, options: [:], completionHandler: nil)
    }
    
    func player() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.backgroundColor = UIColor(primaryColor)
        stackView.roundCorners([.topLeft, .topRight], radius: 15)
        //        stackView.addShadow(shadowColor: UIColor.gray.cgColor, shadowOffset: CGSize(width: 0, height: -3), shadowOpacity: 0.2, shadowRadius: 5)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        stackView.addGestureRecognizer(swipeDown)
        
        stackView.isHidden = true
        safeArea.translatesAutoresizingMaskIntoConstraints = false
        safeArea.backgroundColor = UIColor(primaryColor)
        view.addSubview(safeArea)
        NSLayoutConstraint.activate([
            safeArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            safeArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeArea.heightAnchor.constraint(equalToConstant: 100)
        ])
        safeArea.isHidden = true
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.roundCorners(.allCorners, radius: 8)
        imageView.addShadow(shadowColor: UIColor.gray.cgColor, shadowOffset: CGSize(width: 0, height: -3), shadowOpacity: 0.2, shadowRadius: 5)
        imageView.clipsToBounds = true
        
        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        trackLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        trackLabel.textColor = UIColor.white
        trackLabel.textAlignment = .center
        trackLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        trackLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
        
        playPauseButton.tintColor = UIColor.white
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.addTarget(self, action: #selector(didTapPauseOrPlay), for: .primaryActionTriggered)
        playPauseButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        playPauseButton.addShadow(shadowColor: UIColor.gray.cgColor, shadowOffset: CGSize(width: 0, height: -3), shadowOpacity: 0.2, shadowRadius: 5)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(trackLabel)
        stackView.addArrangedSubview(playPauseButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
                self.stackView.isHidden = true
                self.safeArea.isHidden = true
                self.myTableView.frame = CGRect(x: 0, y: 0, width: balWidth, height: balHeight - 150)
                self.imageView.isHidden = true
                self.trackLabel.isHidden = true
                self.playPauseButton.isHidden = true
            default:
                break
            }
        }
    }
    
    func installedApp() {
        stackInstallView.translatesAutoresizingMaskIntoConstraints = false
        stackInstallView.axis = .vertical
        stackInstallView.spacing = 20
        stackInstallView.alignment = .center
        
        appInstallImage.image = #imageLiteral(resourceName: "Spotify_icon")
        appInstallImage.contentMode = .scaleAspectFit
        appInstallImage.translatesAutoresizingMaskIntoConstraints = false
        appInstallImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        appInstallImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        appInstallLabel.text = "Please install Spotify to continue"
        appInstallLabel.textColor = UIColor(darkBlueColor)
        appInstallLabel.font = UIFont(name: "Nunito-Bold", size: 20)
        appInstallLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackInstallView.addArrangedSubview(appInstallImage)
        stackInstallView.addArrangedSubview(appInstallLabel)
        view.addSubview(stackInstallView)
        
        NSLayoutConstraint.activate([
            stackInstallView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackInstallView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func table() {
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: balWidth, height: balHeight - 150))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.separatorStyle = .none
        
        view.addSubview(myTableView)
    }
    
    func updateViewBasedOnConnected() {
        if !isSpotifyInstalled() {
            stackInstallView.isHidden = false
            myTableView.isHidden = true
            safeArea.isHidden = true
            stackView.isHidden = true
            return
        }
        
        stackInstallView.isHidden = true
        openSpotifyButton.isHidden = false
        if self.appRemote.isConnected == true {
            if currentUri != silentTrack {
                self.stackView.isHidden = false
                self.safeArea.isHidden = false
                self.myTableView.frame = CGRect(x: 0, y: 0, width: balWidth, height: balHeight - 300)
                self.imageView.isHidden = false
                self.trackLabel.isHidden = false
                self.playPauseButton.isHidden = false
            } else {
                self.stackView.isHidden = true
                self.safeArea.isHidden = true
                self.myTableView.frame = CGRect(x: 0, y: 0, width: balWidth, height: balHeight - 150)
                self.imageView.isHidden = true
                self.trackLabel.isHidden = true
                self.playPauseButton.isHidden = true
            }
        } else { // show login
            self.stackView.isHidden = true
            self.safeArea.isHidden = true
            self.myTableView.frame = CGRect(x: 0, y: 0, width: balWidth, height: balHeight - 150)
            self.imageView.isHidden = true
            self.trackLabel.isHidden = true
            self.playPauseButton.isHidden = true

            if (isPause == false) {
                self.currentUri = silentTrack
                self.reconnect(uri: self.currentUri)
            }
        }
    }
    
    func reconnect(uri: String) {
        if self.isOnScreen {
            activityLogEntry?.addAction(actionDescription: "Connecting Spotify")
            self.currentUri = uri
            configuration.playURI = self.currentUri
            guard let sessionManager = sessionManager else {
                return
            }
            sessionManager.initiateSession(with: SpotifyConfig.scopes, options: .clientOnly)
        }
    }
    
    func isSpotifyInstalled() -> Bool {
        let isSpotifyAppInstalled = ((sessionManager?.isSpotifyAppInstalled) != nil)
        return isSpotifyAppInstalled
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
        playTapped(uri: myArray[indexPath.row].uri)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = myArray.count
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.selectionStyle = .none
        
        cell.contentConfiguration = UIHostingConfiguration {
            TrackCellView(image: myArray[indexPath.row].images.url, text: "\(myArray[indexPath.row].name)", duration: "\(myArray[indexPath.row].type)")
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
        showPlaylists()
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        lastPlayerState = nil
        if (self.currentUri == silentTrack) {
            return
        }
        updateViewBasedOnConnected()
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

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.label.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }
}

extension UIViewController{
    var isOnScreen: Bool{
        return self.isViewLoaded && view.window != nil
    }
}
