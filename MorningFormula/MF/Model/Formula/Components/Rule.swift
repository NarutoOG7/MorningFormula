//
//  Rule.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/27/23.
//

import Foundation

struct Rule: Identifiable {
    
    var id = UUID().uuidString
    var title: String
    var text: String
    
    static let exampleA = Rule(title: "Rule 1", text: "I don't go back on my word.")
    static let exampleB = Rule(title: "I workout regularly", text: "I workout 4 days per week.")
    static let exampleC = Rule(title: "I relax", text: "I take at least one hour daily to unwind and relax.")
    static let exampleD = Rule(title: "I learn", text: "I spend my first hour of work learning something new in my field.")
    
    static let examples = [exampleA, exampleB, exampleC, exampleD]
    
}
