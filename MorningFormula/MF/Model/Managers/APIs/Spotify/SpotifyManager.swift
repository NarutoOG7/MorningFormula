//
//  SpotifyManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/6/23.
//

import SwiftUI

class SpotifyManager: ObservableObject {
    
    static let instance = SpotifyManager(spotifyService: SpotifyAPIService())
    
    private var spotifyService: SpotifyService
    
    private var accessCode = "BQA5onlP-Hq0zAmNocjY7rWmeacdwYUTzzpxvKbRGuoGrt5vrZDmtucnsVYojXUKMHjov4GjOwhTE2TidV1iIfvBYdzxQJIagxFIg0Ksn1o2Gg6xaJs"
    var accessTokenTimer: Timer?
    
    @Published var pauseSearch = false {
        didSet {
            if pauseSearch == true {
                self.handleSearchPauseTimer()
            }
        }
    }
    
    @Published var searchInput = ""
//    {
//        didSet {
//            if searchInput.count > 2 {
//                self.searchSongs(searchInput)
//            }
//        }
//    }
    
    @Published var songTitlesForInputGroup: [String] = []
    @Published var songs: [SpotifyItem] = [] {
        didSet {
            let songTitles = songs.map( { $0.stringValue })
            songTitlesForInputGroup = songTitles
        }
    }
    @ObservedObject var errorManager = ErrorManager.instance
    
    init(spotifyService: SpotifyService) {
        self.spotifyService = spotifyService
    }
    
    func getAccessCodeTapped() {
        self.spotifyService.getAccessToken { token, error in
            if let token = token {
                self.accessCode = token
                self.startTimer(duration: 2)
            }
        }
    }
    
    func searchSongs(_ query: String) {
        let keepSearching = !pauseSearch
        if keepSearching {
            spotifyService.getSongFromSearch(accessCode: accessCode, query) { root, error in
                if let error = error {
                    self.errorManager.setError(error.localizedDescription)
                }
                if let root = root {
                    let newSongs = root.tracks.items
                    DispatchQueue.main.async {
                        self.songs = newSongs
                        self.pauseSearch = true
                    }
                }
            }
        }
    }
    
    func searchSongs(_ query: String, withCompletion completion: @escaping(SpotifyItem) -> Void) {
        spotifyService.getSongFromSearch(accessCode: accessCode, query) { root, error in
            if let error = error {
                self.errorManager.setError(error.localizedDescription)
            }
            if let root = root {
                if let song = root.tracks.items.first {
                    completion(song)
                }
            }
        }
    }
    
//    func getReccomendedSong(withCompletion completion: @escaping(SpotifyItem) -> Void) {
//        if let formula = FormulaManager.instance.formula {
//            ChatManager.instance.getSpotifyResponse(formula) { response in
//                if let response = response {
//                    print(response)
//                    let humanString = self.turnResponseToHumanString(response)
//                    print(humanString)
//                    self.searchSongs(response, withCompletion: completion)
//                }
//            }
//        }
//    }
    
    func getRecommendedSong(withCompletion completion: @escaping(SpotifyItem) -> Void) {
        if let formula = FormulaManager.instance.formula {
            spotifyService.getRecommendedSong(accessCode: accessCode, formula) { root, error in
                if let root = root {
                    if let track = root.tracks.first {
                        completion(track)
                    }
                }
            }
        }
    }

    func turnResponseToHumanString(_ response: String) -> String {
        // Removing backslashes
        let withoutBackslashes = response.replacingOccurrences(of: "\\", with: "")

        // Removing double quotes
        let finalText = withoutBackslashes.replacingOccurrences(of: "\"", with: "")

        return finalText
    }
    
    private func handleSearchPauseTimer() {
        var timer: Timer?
        var secondsRemaining = 1
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                timer?.invalidate() // Stop the timer when countdown reaches 0
                self.pauseSearch = false
            }
        }
    }
    
    func startTimer(duration: TimeInterval) {
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { timer in
            self.accessTokenTimer = timer
            print(timer)
        })
    }
    
    func isSpotifyInstalledOnDevice() -> Bool {
        if let spotifyURL = NSURL(string: "spotify") as URL?, UIApplication.shared.canOpenURL(spotifyURL) {
            print("Spotify can be opened")
            return true
        } else {
            print("Spotify cannot be opened")
            return false
        }
    }
    
    func openSpotify(uri: String) {
        if let bundleId = Bundle.main.bundleIdentifier {
            let canonicalURL = "https://open.spotify.com/album/0sNOF9WDwhWunNAHPD3Baj"
            let branchLink = "https://spotify.link/content_linking?~campaign=\(bundleId)&$canonical_url=\(canonicalURL)"

            if let url = URL(string: branchLink) {
                UIApplication.shared.open(url)
            }
        }
    }
}



