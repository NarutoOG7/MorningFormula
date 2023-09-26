//
//  Task.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/4/23.
//

import SwiftUI

struct Task: Identifiable {
    var id: String
    var title: String
    var starTime: Date
    var endTime: Date
    var description: String
    var isComplete: Bool
    var chosenColor: Color
    
    var timeInterval: TimeInterval {
        DateInterval(start: starTime, end: endTime).duration
    }

    //MARK: - Duration
    var duration: String {
        let intDuration = Int(timeInterval.rounded(.toNearestOrEven))
        return "\(intDuration)"
    }
    func durationAsLogicalString(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()

        formatter.maximumUnitCount = 2
        formatter.unitsStyle = .brief
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowedUnits = [.day, .hour, .minute, .second]

        if (!duration.isInfinite && !duration.isNaN) {
           return formatter.string(from: duration) ?? ""
        } else {
            return ""
        }
    }
    
    
    
    //MARK: - Examples
    static let exampleOne = Task(
        id: "exOne",
        title: "Workout",
        starTime: Date(timeIntervalSinceNow: 1200),
        endTime: Date(timeIntervalSinceNow: 2400),
        description: "Workout for atleast 45 minutes. Make sure to hit back muscles next.",
        isComplete: false,
        chosenColor: .orange)
    static let exampleTwo = Task(
        id: "exTwo",
        title: "Read a book for so long",
        starTime: Date(timeIntervalSinceNow: 3600),
        endTime: Date(timeIntervalSinceNow: 4800) ,
        description: "Sit down and read a fictional novel. Enjoy this time.",
        isComplete: false,
        chosenColor: .mint)
    
    static let exampleThree = Task(
        id: "exThree",
        title: "Code for hours",
        starTime: Date(timeIntervalSinceNow: 5200),
        endTime: Date(timeIntervalSinceNow: 7800) ,
        description: "Code at least 4 hours",
        isComplete: false,
        chosenColor: .mint)
    
    static let examples = [exampleOne, exampleTwo, exampleThree]
}
