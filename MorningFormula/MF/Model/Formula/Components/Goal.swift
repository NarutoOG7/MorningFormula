//
//  Goal.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/20/23.
//

import SwiftUI

struct Goal: Identifiable, Codable {
    
    var id = UUID().uuidString
    var title: String
    var goalDate: Date
    var priority: GoalPriority
    var activities: [Activity]
    var season: Season
    var color: CodableColor
    var points: Double
    
    enum GoalPriority: Double, CaseIterable, Codable {
        case one = 1, two = 2, three = 3, four = 4, five = 5
        
        var tempString: String {
            switch self {
            case .one:
                return "Low"
            case .three:
                return "Medium"
            case .five:
                return "High"
            default: return ""
            }
        }
    }
    
    static let examples = [
        Goal(title: "Full-time iOS developer with decent salary.", goalDate: Date(timeIntervalSinceNow: TimeInterval(10000)), priority: .three, activities: Activity.examples, season: .cultivating, color: .init(.red), points: 5),
        Goal(title: "Look and Feel physically fit with structured routine to maintain my physique.", goalDate: Date(timeIntervalSinceNow: TimeInterval(1000)), priority: .three, activities: Activity.examples, season: .cultivating, color: .init(.blue), points: 10),
        Goal(title: "A Healthy Eater", goalDate: Date(timeIntervalSinceNow: TimeInterval(100)), priority: .three, activities: Activity.examples, season: .cultivating, color: .init(.yellow), points: 1),
        Goal(title: "Vacation on the beach", goalDate: Date(timeIntervalSinceNow: TimeInterval(100000)), priority: .three, activities: Activity.examples, season: .cultivating, color: .init(.green), points: 20),
    ]
}
