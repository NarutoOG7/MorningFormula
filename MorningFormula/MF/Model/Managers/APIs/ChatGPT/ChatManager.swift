//
//  ChatManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/8/23.
//

import SwiftUI

class ChatManager: ObservableObject {
    static let instance = ChatManager(chatService: ChatGPTAPIService())
    
    private var chatService: ChatGPTService
    
    @Published var introduction = ""
    @Published var conclusion = ""

    
    init(chatService: ChatGPTService) {
        self.chatService = chatService
    }
    
    func getPersonalSummaryFromFormula(_ formula: Formula) {
        self.chatService.getChatResponseFromMessage(formula.summaryForChat) { response, error in
            if let response = response {
                DispatchQueue.main.async {
                    let responseComponents = self.separateResponse(response)
                    self.introduction = responseComponents.0
                    self.conclusion = responseComponents.1

                }
            }
        }
    }
    
    func getPersonalSummaryFromFormula(_ formula: Formula, withCompletion completion: @escaping(Formula) -> Void) {
        self.chatService.getChatResponseFromMessage(formula.summaryForChat) { response, error in
            if let response = response {
                print(response)
                DispatchQueue.main.async {
//                    let responseComponents = self.separateResponse(response)
//                    let introduction = responseComponents.0
//                    let conclusion = responseComponents.1
                    var newFormula = formula
                    newFormula.chatResponse = response
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
    
    func getSpotifyResponse(_ formula: Formula, withCompletion completion: @escaping(String?) -> Void) {
        self.chatService.getChatResponseFromMessage(formula.spotifyRecommendationRequest) { response, error in
                completion(response)
        }
    }
}

