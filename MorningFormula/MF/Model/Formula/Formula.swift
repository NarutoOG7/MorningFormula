//
//  Formula.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/29/23.
//

import Foundation

struct Formula: Identifiable {
    var id = UUID().uuidString
    var descriptiveWords: [String]
    var season: Season
    var goals: [Goal]
    var virtues: [Virtue]
    var qutoes: [Quote]
    var principles: [Principle]
    var rules: [Rule]
}
