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
    
    private var accessCode = ""
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
    
    func getReccomendedSong(withCompletion completion: @escaping(SpotifyItem?, Error?) -> Void) {
        
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
}



