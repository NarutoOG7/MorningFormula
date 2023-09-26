//
//  Goal.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/20/23.
//

import SwiftUI

struct Goal: Identifiable {
    
    var id = UUID().uuidString
    var title: String
    var goalDate: Date
    var priority: GoalPriority
    var activities: [Activity]
    var season: Season
    var color: Color
    
    enum GoalPriority: Double, CaseIterable {
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
        Goal(title: "Full-time iOS developer with decent salary.", goalDate: Date(timeIntervalSinceNow: TimeInterval(10000)), priority: .three, activities: Activity.examples, season: .cultivating, color: .green),
        Goal(title: "Look and Feel physically fit with structured routine to maintain my physique.", goalDate: Date(timeIntervalSinceNow: TimeInterval(1000)), priority: .three, activities: Activity.examples, season: .cultivating, color: .red),
        Goal(title: "A Healthy Eater", goalDate: Date(timeIntervalSinceNow: TimeInterval(100)), priority: .three, activities: Activity.examples, season: .cultivating, color: .yellow),
        Goal(title: "Vacation on the beach", goalDate: Date(timeIntervalSinceNow: TimeInterval(100000)), priority: .three, activities: Activity.examples, season: .cultivating, color: .blue),
    ]
}
