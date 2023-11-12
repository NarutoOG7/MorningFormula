//
//  EmotionManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/6/23.
//

import SwiftUI

class EmotionManager: ObservableObject {
    static let instance = EmotionManager()
    
    @Published var currentEmtion: Emotion = .happy
}
