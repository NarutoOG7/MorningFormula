//
//  SpotifyView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/3/23.
//

import SwiftUI
import WebKit

//let authOptions: [String:Any] = [
//    "headers" : [
//        "Authorization" : authKey
//    ],
//    "form" : [
//        "grant_type" : "client_credentials"
//    ],
//    "json" : true
//]

enum SpotifyAPIConstants {
    static let apiHost = "api.spotify.com"
    static let authHost = "accounts.spotify.com"
    static let clientID = "49521fc971524abdafef4a9a0c8109bf"
    static let clientSecret = "04ea55ed23164bc0ad72d674d8549734"
    static let redirectUri = "https://www.google.com"
    static let responseType = "token"
    static let scopes = "user-read-private"

    static var authParams = [
        "response_type" : responseType,
        "client_id" : clientID,
        "redirect_uri" : redirectUri,
        "scopes" : scopes
    ]

}

class SpotifyManager: ObservableObject {
    static let inestance = SpotifyManager()
    
    func three() {
        if let request = getAccessTokenURLRoundTwoFight() {
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                      
                 guard error == nil else {
                     return
                 }
                      
                if let data = data {
                    
                    do {
                        //create json object from data
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print(json)
                            print(json["access_token"])
                        }
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
             })

             task.resume()
        }
    }
    
    func getAccessTokenURLRoundTwoFight() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = SpotifyAPIConstants.authHost
        components.path = "/authorize"
        components.queryItems = SpotifyAPIConstants.authParams.map( { URLQueryItem(name: $0, value: $1) })
        
        guard let url = components.url else { return nil }
        
        return URLRequest(url: url)
    }
    
    func getAccessToken(withCompletion completion: @escaping(String?, Error?) -> Void) {
        let clientID = "49521fc971524abdafef4a9a0c8109bf"
        let secret = "04ea55ed23164bc0ad72d674d8549734"
        let authKey = "Basic" + Data("\(clientID):\(secret)".utf8).base64EncodedString()
        

        let headers = [
            "Content-Type" : "application/x-www-form-urlencoded",
            "Authorization" : "Basic NDk1MjFmYzk3MTUyNGFiZGFmZWY0YTlhMGM4MTA5YmY6MDRlYTU1ZWQyMzE2NGJjMGFkNzJkNjc0ZDg1NDk3MzQ"
            ]
        let parameters = [
            "grant_type" : "client_credentials"
        ]
        
        
        if let url = NSURL(string: "https://accounts.spotify.com/api/token") {
            print(url.absoluteString)
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

struct SpotifyView: View {
    var body: some View {
        Button {
            SpotifyManager.inestance.getAccessToken { token, error in
                if let token = token {
                    print(token)
                }
            }
        } label: {
            Text("Spotify Token")
        }

            
    }
}

struct SpotifyView_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyView()
    }
}

struct WebView: UIViewRepresentable {
 
    var request: URLRequest?
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let request = request {
            webView.load(request)
        }
    }
}
