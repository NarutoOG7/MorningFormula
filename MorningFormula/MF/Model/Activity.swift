//
//  Activity.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/20/23.
//

import SwiftUI

struct Activity: Identifiable {
    
    var id = UUID().uuidString
    var title: String
    var time: TimeInterval
    var weight: ActivityWeight
    var color: Color
    var repetition: TaskRepetion
    
    enum ActivityWeight: Int {
        case one = 1,
             two = 2,
             three = 3,
             four = 4,
             five = 5
    }
    
    static let examples = [
        Activity(title: "Workout", time: Date().timeIntervalSince1970, weight: .three, color: .red, repetition: .daily),
        Activity(title: "Attend Meeting", time: Date().timeIntervalSince1970, weight: .three, color: .orange, repetition: .weekly),
        Activity(title: "Buy Fruit", time: Date().timeIntervalSince1970, weight: .three, color: .yellow, repetition: .weekly),
        Activity(title: "Code", time: Date().timeIntervalSince1970, weight: .three, color: .blue, repetition: .daily)
    ]
    
}

