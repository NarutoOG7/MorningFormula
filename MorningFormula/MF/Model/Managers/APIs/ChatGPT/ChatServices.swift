//
//  ChatServices.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/21/23.
//

import SwiftUI


class ChatGPTAPIService: ChatGPTService {

    func getStressedOutResponseFromMessage(_ message: String, withCompletion completion: @escaping (String?, Error?) -> Void) {
        if let request = urlRequestForStressedOut(message) {
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, error)
                }
                if let data = data {
                    do {
                        let bot = try JSONDecoder().decode(ChatStressedResponse.self, from: data)
                        completion(bot.result, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func getChatResponseFromMessage(_ message: String, withCompletion completion: @escaping (String?, Error?) -> Void) {
        
        if let request = urlRequestFromMessage(message) {
            print(request.debug())
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    do {
                        let bot = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
                        completion(bot.bot, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func urlRequestFromMessage(_ message: String) -> URLRequest? {
        guard var baseURL = URLComponents(string: "https://open-ai21.p.rapidapi.com/chatmpt") else {
            return nil
        }
        let key = "936ecadc60mshba73eeb67dc3a97p17f25ajsn35f57e6830e4"
        let host = "open-ai21.p.rapidapi.com"
        
        let headers = [
            "content-type" : "application/json",
            "X-RapidAPI-Key" : key,
            "X-RapidAPI-Host" : host
        ]
        
        let parameters: [String:Any] = [
            "message" : message
        ]

//        let parameters: [String : Any] = [
//            "messages": [
//                [
//                    "role": "user",
//                    "content": formula.summaryForChat
//                ]
//            ],
//            "web_access": false,
//            "stream": false
//            ]
        do {
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        baseURL.percentEncodedQuery = baseURL.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
            if let url = baseURL.url {
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headers
                request.httpBody = postData
                return request as URLRequest
            }
                
        } catch {
            print(error.localizedDescription)
            return nil
        }
        return nil
    }

    
    func urlRequestForStressedOut(_ message: String) -> URLRequest? {
        guard var baseURL = URLComponents(string: "https://open-ai21.p.rapidapi.com/conversationgpt") else {
            return nil
        }
        let key = "936ecadc60mshba73eeb67dc3a97p17f25ajsn35f57e6830e4"
        let host = "open-ai21.p.rapidapi.com"
        
        let headers = [
            "content-type" : "application/json",
            "X-RapidAPI-Key" : key,
            "X-RapidAPI-Host" : host
        ]
        

        let parameters: [String : Any] = [
            "messages": [
                [
                    "role": "user",
                    "content": message
                ]
            ],
            "web_access": false,
            "stream": false
            ]
        do {
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        baseURL.percentEncodedQuery = baseURL.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
            if let url = baseURL.url {
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headers
                request.httpBody = postData
                return request as URLRequest
            }
                
        } catch {
            print(error.localizedDescription)
            return nil
        }
        return nil
    }
}

struct ChatStressedResponse: Codable {
    var result: String
}
