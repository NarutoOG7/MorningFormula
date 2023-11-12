//
//  Rule.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/27/23.
//

import Foundation

struct Rule: Identifiable, Codable {
    
    var id = UUID().uuidString
    var text: String
    
    static let exampleA = Rule(text: "Rule 1: I don't go back on my word.")
    static let exampleB = Rule(text: "I workout four days per week.")
    static let exampleC = Rule(text: "I take at least one hour daily to unwind and relax.")
    static let exampleD = Rule(text: "I spend my first hour of work learning something new in my field.")
    
    static let examples = [exampleA, exampleB, exampleC, exampleD]
    
}
