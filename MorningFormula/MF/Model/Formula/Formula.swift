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
    var songs: [SpotifyItem]
    
    var summaryForChat: String {
        "Can you write a long paragrapgh, in the third person, an introduction and a conclusion. Make each at least 5 sentences long. The content is about who I am Using these descriptive words: \(descriptiveWords), and using these goals: \(goals.map({ $0.title })). Use the present tense as if I already have what I want. My name is Spencer."
    }
//    Using these virtues: \(virtues), using these quotes: \(quotes), using these principles: \(principles), using these rules: \(rules).
    
    var spotifyRecommendationRequest: String {
//        let intro = "Hi there! I'm looking for some song recommendations based on my taste. I enjoy songs with a modern and fairly similar genre to the following tracks: "
//        let outro = " I'd like the recommendations to have a the same genre and prefer songs that aren't too mainstream. Can you suggest 3 tracks that fit these criteria and give them distinct separation of a specail character?"
        let intro = "only respond with one real song title and artist please based off of my favorite artists and songs: 'Chemical' by Post Malone, 'Guts Over Fear' by Eminem."
//        let outro = "This is supposed to be a new song for me."
        var songStrings: [String] = []
        for song in songs {
            let title = song.name
            let artist = song.firstArtistName
            songStrings.append("'\(title)' by \(artist)")
        }
        let request = intro + songStrings.joined(separator: ",")
        return request
    }
    
    var imStressedRequest: String {
        "Give me one random action for me to complete that helps ease stress. Looking for it to be between 2 and 10 minutes. Return just the action please."
    }
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? String ?? ""
        self.userID = dict["id"] as? String ?? ""
        self.descriptiveWords = dict["descriptiveWords"] as? [String] ?? []
        self.season = .cultivating
        self.goals = Goal.examples
        self.virtues = []
        self.quotes = Quote.examples
        self.principles = Principle.examples
        self.rules = Rule.examples
        self.imagesWithDuration = [:]
        self.narratorID = dict["id"] as? String ?? ""
        self.chatResponse = dict["id"] as? String ?? ""
        self.formulaURL = URL(string: dict["formulaURL"] as? String ?? "")
        self.songs = dict["songs"] as? [SpotifyItem] ?? []
    }
    
    init(id: String = UUID().uuidString, userID: String, descriptiveWords: [String], season: Season, goals: [Goal], virtues: [String], quotes: [Quote], principles: [Principle], rules: [Rule], imagesWithDuration: [FormulaImage : Int], narratorID: String, chatResponse: String, formulaURL: URL? = nil, songs: [SpotifyItem] = []) {
        self.id = id
        self.userID = userID
        self.descriptiveWords = descriptiveWords
        self.season = season
        self.goals = goals
        self.virtues = virtues
        self.quotes = quotes
        self.principles = principles
        self.rules = rules
        self.imagesWithDuration = imagesWithDuration
        self.narratorID = narratorID
        self.chatResponse = chatResponse
        self.formulaURL = formulaURL
        self.songs = songs
    }

    
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
