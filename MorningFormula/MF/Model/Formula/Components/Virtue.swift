//
//  Virtue.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/27/23.
//

import Foundation

struct Virtue: Identifiable, Codable {
    
    var id = UUID().uuidString
    var text: String
    
    static let exampleA = Virtue(text: "Courage")
    static let exampleB = Virtue(text: "Friendliness")
    static let exampleC = Virtue(text: "Faithfulness")
    static let exampleD = Virtue(text: "Humility")

    static let examples = [exampleA, exampleB, exampleC, exampleD]
}
