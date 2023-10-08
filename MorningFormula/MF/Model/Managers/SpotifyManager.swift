//
//  SpotifyManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/6/23.
//

import SwiftUI

class SpotifyManager: ObservableObject {
    static let inestance = SpotifyManager()
    
    func getSongFromEmotion(_ emotion: Emotion, withCompletion completion: @escaping(SpotifyItem?, Error?) -> Void) {
        let baseURL = "https://api.spotify.com/v1/search"
        let query = emotion.query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let q = "?q=\(query)"
        print(q)
        let type = "?type=track"
        let limit = "?limit=3"
        let advancedURL = baseURL + q + type + limit
        
        let authKey = "Bearer BQCeOgN0d-875UNgC5C6YyQHdc2wZe5hdr1x90fWa0B6Ijsrm3jEFHhuxmHc5jhtqnVWTf0qNnRfytqZWL-KaLZROsBmu6wQX_hNmY1PP4xKpP8HX-I"
        
        let parameters = [
            "type" : type,
            "limit" : limit
        ]
        let headers = [
            "Authorization" : authKey
        ]
        print(advancedURL)
        
        if let url = NSURL(string: baseURL + q) {
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] {
                            print(json)
                            if let items = json["items"] as? [String:Any] {
                                print(items)
                            } else {
                                completion(nil, NSError(domain: "SpotifyManager", code: 1, userInfo: ["message" : "Items not found in response"]))
                            }
                        } else {
                            completion(nil, NSError(domain: "SpotifyManager", code: 2, userInfo: ["message" : "Invalid JSON response."]))
                        }
                    } catch {
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    func getSongFromEmotionUsingComponents(_ emotion: Emotion, withCompletion completion: @escaping(SpotifyItem?, Error?) -> Void) {
        guard var baseURL = URLComponents(string: "https://api.spotify.com/v1/search") else {
            completion(nil, NSError(domain: "SpotifyManager", code: 3, userInfo: ["message" : "BaseURL is nil"]))
            return
        }
//            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let query = emotion.query
        let type = "?type=track"
        let limit = "?limit=3"
            
        let authKey = "Bearer BQCeOgN0d-875UNgC5C6YyQHdc2wZe5hdr1x90fWa0B6Ijsrm3jEFHhuxmHc5jhtqnVWTf0qNnRfytqZWL-KaLZROsBmu6wQX_hNmY1PP4xKpP8HX-I"
        
        
        let headers = [
            "Authorization" : authKey
        ]
        
        baseURL.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "type", value: "track"),
            URLQueryItem(name: "limit", value: "3")
        ]
        print(baseURL)
        
        baseURL.percentEncodedQuery = baseURL.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        if let url = baseURL.url {
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] {
                            if let items = json["items"] as? [String:Any] {
//                                if let album = items["album"] as? [String:Any] {
                                let album = JSONDecoder.
                                
                            } else {
                                completion(nil, NSError(domain: "SpotifyManager", code: 1, userInfo: ["message" : "Items not found in response"]))
                            }
                        } else {
                            completion(nil, NSError(domain: "SpotifyManager", code: 2, userInfo: ["message" : "Invalid JSON response."]))
                        }
                    } catch {
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func getAccessToken(withCompletion completion: @escaping(String?, Error?) -> Void) {
        let authKey = "Basic NDk1MjFmYzk3MTUyNGFiZGFmZWY0YTlhMGM4MTA5YmY6MDRlYTU1ZWQyMzE2NGJjMGFkNzJkNjc0ZDg1NDk3MzQ"

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
    
}
