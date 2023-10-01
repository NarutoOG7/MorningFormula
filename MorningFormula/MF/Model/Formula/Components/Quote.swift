//
//  Quote.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/27/23.
//

import Foundation

struct Quote: Identifiable {
    var id = UUID().uuidString
    var title: String
    var description: String
    var attribution: String
    
    static let exampleA = Quote(title: "Choices make the monster",
                                description: "It's not the face that makes someone a monster, it's the choices that they make.",
                                attribution: "Naruto")
    static let exampleB = Quote(title: "Try Not!",
                                description: "Do or do not, there is no try",
                                attribution: "Yoda")
    static let examples = [exampleA, exampleB]
}
