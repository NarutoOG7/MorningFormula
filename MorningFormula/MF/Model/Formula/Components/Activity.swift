//
//  Activity.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/20/23.
//

import SwiftUI

struct Activity: Identifiable, Codable {
    
    var id = UUID().uuidString
    var title: String
    var startTime: Date
    var endTime: Date
    var weight: ActivityWeight
    var color: CodableColor
    var repetition: TaskRepetion
    
    var time: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    enum ActivityWeight: Int, Codable {
        case one = 1,
             two = 2,
             three = 3,
             four = 4,
             five = 5
    }
    
    static let examples = [
        Activity(title: "Workout", startTime: Date(), endTime: Date(timeIntervalSinceNow: 100), weight: .three, color: .init(.red), repetition: .daily),
        Activity(title: "Attend Meeting", startTime: Date(), endTime: Date(timeIntervalSinceNow: 1000), weight: .three, color: .init(.blue), repetition: .weekly),
        Activity(title: "Buy Fruit", startTime: Date(), endTime: Date(timeIntervalSinceNow: 10000), weight: .three, color: .init(.yellow), repetition: .weekly),
        Activity(title: "Code", startTime: Date(), endTime: Date(timeIntervalSinceNow: 100000), weight: .three, color: .init(.green), repetition: .daily)
    ]
    
}

