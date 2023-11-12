//
//  Task.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/4/23.
//

import SwiftUI

extension Date {
    func getMilitaryTime() -> (hr: Int, min: Int, double: Double) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        let hour = components.hour ?? 0
        let minutes = components.minute ?? 0
        let minutesAsDouble = Double(minutes) / 60.0
        let double = Double(hour) + minutesAsDouble
        
        print("hour: \(hour)")
        print("minutes: \(minutes)")
        print("minutesAsDouble: \(minutesAsDouble)")
        print("double: \(double)")

        return (hr: hour, min: minutes, double: double)
    }
}

struct MFTask: Identifiable, Hashable {
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
    var intDuration: Int {
        Int(timeInterval.rounded(.toNearestOrEven))
    }
    
    var duration: String {
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
    
    func durationString(startTime: Date, endTime: Date) -> String {
        if startTime < endTime {
            let duration = DateInterval(start: startTime, end: endTime).duration
            let str = durationAsLogicalString(duration: duration)
            return "\(str)"
        }
        return ""
    }
    
    func getMilitaryTime(date: Date) -> (hr: Int, min: Int, double: Double) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 0
        let minutes = components.minute ?? 0
        let minutesAsDouble = Double(minutes / 60)
        let double = Double(hour) + minutesAsDouble
        return (hr: hour, min: minutes, double: double)
    }
    
    //MARK: - Initializers
    init(id: String = "", title: String = "", starTime: Date = Date(), endTime: Date = Date(), description: String = "", isComplete: Bool = false, chosenColor: Color = .red) {
        self.id = id
        self.title = title
        self.starTime = starTime
        self.endTime = endTime
        self.description = description
        self.isComplete = isComplete
        self.chosenColor = chosenColor
    }
    
    init(from firebase: CodableTask) {
        self.id = firebase.id
        self.description = firebase.notes
        self.isComplete = firebase.isComplete
        self.chosenColor = firebase.color.color()
        
        if let event = EventManager.instance.getEvent(from: firebase.id) {
            self.title = event.title
            self.starTime = event.startDate
            self.endTime = event.endDate
        } else {
            self.title = "No EKEvent"
            self.starTime = Date()
            self.endTime = Date()
        }
        
    }
    
    //MARK: - Examples
    static let exampleOne = MFTask(
        id: "exOne",
        title: "Workout",
        starTime: Date(timeIntervalSinceNow: 1200),
        endTime: Date(timeIntervalSinceNow: 2400),
        description: "Workout for atleast 45 minutes. Make sure to hit back muscles next.",
        isComplete: false,
        chosenColor: .orange)
    static let exampleTwo = MFTask(
        id: "exTwo",
        title: "Read a book for so long",
        starTime: Date(timeIntervalSinceNow: 3600),
        endTime: Date(timeIntervalSinceNow: 4800) ,
        description: "Sit down and read a fictional novel. Enjoy this time.",
        isComplete: false,
        chosenColor: .yellow)
    
    static let exampleThree = MFTask(
        id: "exThree",
        title: "Code for hours",
        starTime: Date(timeIntervalSinceNow: 5200),
        endTime: Date(timeIntervalSinceNow: 7800) ,
        description: "Code at least 4 hours",
        isComplete: false,
        chosenColor: .mint)
    
    static let examples = [exampleOne, exampleTwo, exampleThree]
}
