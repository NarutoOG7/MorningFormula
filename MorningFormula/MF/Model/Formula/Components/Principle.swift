//
//  Principle.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/27/23.
//

import Foundation

struct Principle: Identifiable, Codable {
    
    var id = UUID().uuidString
    var text: String
    
    static let exampleA = Principle(text: "Think in questions.")
    static let exampleB = Principle(text: "What you speak, you see.")
    static let exampleC = Principle(text: "Everyone lives inside their own fantasies, and their own clocks.")

    static let examples = [exampleA, exampleB, exampleC]
}
