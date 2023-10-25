//
//  ChatServices.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/21/23.
//

import SwiftUI

fileprivate extension URLRequest {
    func debug() {
        print("\(self.httpMethod!) \(self.url!)")
        print("Headers:")
        print(self.allHTTPHeaderFields!)
        print("Body:")
        print(String(data: self.httpBody ?? Data(), encoding: .utf8)!)
    }
}

class ChatManager: ObservableObject {
    static let instance = ChatManager(chatService: ChatGPTAPIService())
    
    private var chatService: ChatGPTService
    
    @Published var introduction = ""
    @Published var conclusion = ""

    
    init(chatService: ChatGPTService) {
        self.chatService = chatService
    }
    
    func getChatResponseFromFormula(_ formula: Formula) {
        self.chatService.getPersonalSummaryFromFormula(formula) { response, error in
            if let response = response {
                DispatchQueue.main.async {
                    let responseComponents = self.separateResponse(response)
                    self.introduction = responseComponents.0
                    self.conclusion = responseComponents.1

                }
            }
        }
    }
    
    func getChatResponseFromFormula(_ formula: Formula, withCompletion completion: @escaping(Formula) -> Void) {
        self.chatService.getPersonalSummaryFromFormula(formula) { response, error in
            if let response = response {
                DispatchQueue.main.async {
                    let responseComponents = self.separateResponse(response)
                    let introduction = responseComponents.0
                    let conclusion = responseComponents.1
                    var newFormula = formula
                    newFormula.chatResponse = introduction
                    completion(newFormula)
                }
            }
        }
    }
    
//    func separateResponse(_ response: String) -> (String,String) {
//        print(response)
//        if let introRange = response.range(of: "Introduction:\\n"),
//           let conclusionRange = response.range(of: "\\nConclusion:\\n") {
//            let introduction = response[introRange.upperBound..<conclusionRange.lowerBound]
//            let conclusion = response[conclusionRange.upperBound...]
//            
//            // Remove escape characters and \\n
//            let processedIntroduction = introduction.replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\\", with: "")
//            let processedConclusion = conclusion.replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\\", with: "")
//            
//            return (processedIntroduction , processedConclusion)
//            
//        }
//        return ("","")
//    }
    
    func separateResponse(_ response: String) -> (String, String) {
        let paragraphs = response.components(separatedBy: "\\n")
        
        // Make sure we have at least two paragraphs
        guard paragraphs.count >= 2 else {
            return ("", "")
        }
        
        let first = paragraphs[0].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\\", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        let second = paragraphs[1].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\\", with: "").trimmingCharacters(in: .whitespacesAndNewlines)

        print(first)
        print("Second")
        print(second)
        // Assuming you want to return the first two paragraphs as a tuple
        return (first, String(paragraphs[1]))
    }
}

protocol ChatGPTService {
    
    func getPersonalSummaryFromFormula(_ formula: Formula, withCompletion completion: @escaping(String?, Error?) -> Void)
    
    func urlRequestFromFormula(_ formula: Formula) -> URLRequest?
}

struct ChatGPTResponse: Codable {
    var bot: String
    
    enum CodingKeys: String, CodingKey {
        case bot = "GPT"
    }
    
    static let example = ChatGPTResponse(bot: "Spencer is a dedicated individual who embodies the essence of a true believer. He's not only a fighter when it comes to pursuing his dreams but also a loving brother who values the support of his family. As a full-time iOS developer, he codes for two hours daily, crafting innovative and user-friendly applications. Spencer's unwavering commitment to his goals is inspiring, and he tirelessly submits job applications, knowing that his hard work will lead to career success. Outside of the tech world, he's equally focused on personal growth and health, hitting the gym four days a week for invigorating one-hour workouts. In all aspects of his life, Spencer exemplifies the tenacity and dedication that make dreams a reality.")
}

class ChatGPTAPIService: ChatGPTService {

    func getPersonalSummaryFromFormula(_ formula: Formula, withCompletion completion: @escaping (String?, Error?) -> Void) {
        
        if let request = urlRequestFromFormula(formula) {
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
    
    func urlRequestFromFormula(_ formula: Formula) -> URLRequest? {
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
                    "content": formula.summaryForChat
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
