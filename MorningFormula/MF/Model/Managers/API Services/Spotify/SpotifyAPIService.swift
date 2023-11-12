//
//  SpotifyAPIService.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/8/23.
//

import SwiftUI

class SpotifyAPIService: SpotifyService {
    
    func getSongFromSearch(accessCode: String, _ query: String, withCompletion completion: @escaping(SpotifyRoot?, Error?) -> Void) {
        
        if let request = urlRequestFromQuery(accessCode: accessCode, query) {
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
    
    func urlRequestFromQuery(accessCode: String, _ query: String) -> URLRequest? {
        guard var baseURL = URLComponents(string: "https://api.spotify.com/v1/search") else {
            return nil
        }
        
        let authKey = "Bearer \(accessCode)"
        
        
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
    
}


