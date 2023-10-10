//
//  SpotifyManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/6/23.
//

import SwiftUI

class SpotifyManager: ObservableObject {
    static let instance = SpotifyManager()
    
    private var accessCode = ""
    
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
    
    func getAccessCodeTapped() {
        self.getAccessToken { token, error in
            if let token = token {
                self.accessCode = token
            }
        }
    }
    
    func searchSongs(_ query: String) {
        let keepSearching = !pauseSearch
        if keepSearching {
            self.getSongFromSearch(query) { root, error in
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
    
    func getSongFromSearch(_ query: String, withCompletion completion: @escaping(SpotifyRoot?, Error?) -> Void) {
        
        if let request = urlRequestFromQuery(query) {
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    do {
                        let root = try JSONDecoder().decode(SpotifyRoot.self, from: data)
                        completion(root, nil)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
    
    func urlRequestFromQuery(_ query: String) -> URLRequest? {
        guard var baseURL = URLComponents(string: "https://api.spotify.com/v1/search") else {
//            error(NSError(domain: "SpotifyManager", code: 3, userInfo: ["message" : "BaseURL is nil"]))
            return nil
        }
        
        let authKey = "Bearer BQACndxKGMOUYr6NcKq-vQ9vHUFLHpd7SzQ2p9mLJ1haHzuDKaW51NBMYv_yKp0QgECIwy3NGD8_YwQ2t1nAZ6QQoFjR5W8ItmtVA0a1hgiFSAMKxYg"
        
        
        let headers = [
            "Authorization" : authKey
        ]
        
        baseURL.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "type", value: "track"),
            URLQueryItem(name: "limit", value: "3")
        ]
        
        baseURL.percentEncodedQuery = baseURL.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        if let url = baseURL.url {
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            return request as URLRequest
        }
            return nil
    }
    
    
    func getAccessToken(withCompletion completion: @escaping(String?, Error?) -> Void) {
        
        let headers = [
            "Content-Type" : "application/x-www-form-urlencoded",
            "Authorization" : "Basic NDk1MjFmYzk3MTUyNGFiZGFmZWY0YTlhMGM4MTA5YmY6MDRlYTU1ZWQyMzE2NGJjMGFkNzJkNjc0ZDg1NDk3MzQ"
            ]
        let parameters = [
            "grant_type" : "client_credentials"
        ]
        
        
        if let url = NSURL(string: "https://accounts.spotify.com/api/token") {
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = parameters
                .map { key, value in "\(key)=\(value)" }
                .joined(separator: "&")
                .data(using: .utf8)
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request as URLRequest) {
                data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {

                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] {
                            print(json)
                            if let accessToken = json["access_token"] as? String {
                                completion(accessToken, nil)
                            } else {
                                completion(nil, NSError(domain: "SpotifyManager", code: 1, userInfo: ["message" : "Access Token not found in response"]))
                            }
                        } else {
                            completion(nil, NSError(domain: "SpotifyManager", code: 2, userInfo: ["message" : "Invalid JSON response."]))
                        }
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
                }
            }
            dataTask.resume()

        }
    }
    
//    func spotifySearch(query: String, withCompletion completion: @escaping(Track?, Error?) -> Void) {
//
//    }
    
    
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
}
