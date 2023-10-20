//
//  Formula.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/29/23.
//

import Foundation

struct Formula: Identifiable, Codable {
    var id = UUID().uuidString
    var userID: String
    var descriptiveWords: [String]
    var season: Season
    var goals: [Goal]
    var virtues: [String]
    var qutoes: [Quote]
    var principles: [Principle]
    var rules: [Rule]
    
    static let example = Formula(id: "Baller",
                                 userID: "USERID",
                                 descriptiveWords: ["Brother", "Friend", "iOS Developer"],
                                 season: .watering,
                                 goals: Goal.examples,
                                 virtues: ["Courageous", "Honest", "Brave"],
                                 qutoes: Quote.examples,
                                 principles: Principle.examples,
                                 rules: Rule.examples)
    
    static let exampleTwo = Formula(id: "Baller",
                                    userID: "exampleTwo UserID",
                                    descriptiveWords: ["Lover", "Fighter", "Believer"],
                                    season: .harvesting,
                                    goals: Goal.examples,
                                    virtues: ["Studious", "Generous", "Brave"],
                                    qutoes: Quote.examples,
                                    principles: Principle.examples,
                                    rules: Rule.examples)
}
