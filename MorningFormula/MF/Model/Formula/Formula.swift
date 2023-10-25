//
//  Formula.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/29/23.
//

import UIKit

struct FormulaImage: Codable, Identifiable, Hashable {

    let id: String
    let photo: Data
    
    init(photo: UIImage) {
        self.id = UUID().uuidString
        if let data = photo.pngData() {
            self.photo = data
        } else {
            self.photo = Data()
        }
    }
    
    func image() -> UIImage? {
        UIImage(data: self.photo)
    }
}

struct Formula: Identifiable, Codable {
    var id = UUID().uuidString
    var userID: String
    var descriptiveWords: [String]
    var season: Season
    var goals: [Goal]
    var virtues: [String]
    var quotes: [Quote]
    var principles: [Principle]
    var rules: [Rule]
    var imagesWithDuration: [FormulaImage : Int]
    var narratorID: String
    var chatResponse: String
    var formulaURL: URL?
    
    var summaryForChat: String {
        "Can you write a long paragrapgh, in the third person, an introduction and a conclusion. Make each at least 5 sentences long. The content is about who I am Using these descriptive words: \(descriptiveWords), and using these goals: \(goals.map({ $0.title })). Use the present tense as if I already have what I want. My name is Spencer."
    }
//    Using these virtues: \(virtues), using these quotes: \(quotes), using these principles: \(principles), using these rules: \(rules).
    
    
    static let example = Formula(id: "Baller",
                                 userID: "USERID",
                                 descriptiveWords: ["Brother", "Friend", "iOS Developer"],
                                 season: .watering,
                                 goals: Goal.examples,
                                 virtues: ["Courageous", "Honest", "Brave"],
                                 quotes: Quote.examples,
                                 principles: Principle.examples,
                                 rules: Rule.examples,
                                 imagesWithDuration: [
                                    FormulaImage(photo: UIImage(named: "SampleOne")!) : 5,
                                    FormulaImage(photo: UIImage(named: "SampleTwo")!) : 7,
                                    FormulaImage(photo: UIImage(named: "SampleThree")!) : 13
                                    ],
                                 narratorID: "alex",
                                 chatResponse: "See you later")
    
    static let exampleTwo = Formula(id: "Baller",
                                    userID: "exampleTwo UserID",
                                    descriptiveWords: ["Lover", "Fighter", "Believer"],
                                    season: .harvesting,
                                    goals: Goal.examples,
                                    virtues: ["Studious", "Generous", "Brave"],
                                    quotes: Quote.examples,
                                    principles: Principle.examples,
                                    rules: Rule.examples, 
                                    imagesWithDuration: [
                                       FormulaImage(photo: UIImage(named: "SampleOne")!) : 5,
                                       FormulaImage(photo: UIImage(named: "SampleTwo")!) : 7,
                                       FormulaImage(photo: UIImage(named: "SampleThree")!) : 13
                                       ],
                                    narratorID: "Sam",
                                    chatResponse: "See you later")
}
