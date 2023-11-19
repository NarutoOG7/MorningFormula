//
//  HomeViewModel.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/18/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    static let instance = HomeViewModel()
    
    @Published var showRecommendedSong = false
    @Published var recommendedSong = SpotifyItem()
    
    @Published var stressedOutPrompt: String? = "Perform two minutes of deep breathing exercises, inhaling for four seconds, holding your breath for seven seconds, and exhaling for eight seconds."
    
    @ObservedObject var chatManager = ChatManager.instance
    @ObservedObject var formulaManager = FormulaManager.instance
    
    func imStressedTapped() {
//        self.stressedOutPrompt = "Perform two minutes of deep breathing exercises, inhaling for four seconds, holding your breath for seven seconds, and exhaling for eight seconds."
        if let formula = formulaManager.formula {
            chatManager.getStressdOutPrompt(formula) { prompt, error in
                DispatchQueue.main.async {
                    self.stressedOutPrompt = prompt
                }
            }
        }
    }
}

