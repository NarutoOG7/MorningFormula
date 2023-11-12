//
//  Emotion.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/6/23.
//

import Foundation

enum Emotion: String, CaseIterable {
    case happy, sad, angry, excited, anxious
    
    var query: String {
        switch self {
        case .happy:
            return "The Lazy Song"
        case .sad:
            return "Sadness and Sorrow"
        case .angry:
            return "Wild for the Night"
        case .excited:
            return "Come on Eileen"
        case .anxious:
            return "Might as well Dance"
        }
    }
}

