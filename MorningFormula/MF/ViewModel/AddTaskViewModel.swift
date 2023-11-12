//
//  AddTaskViewModel.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/6/23.
//

import SwiftUI
import EventKit

extension [MFTask] {
    func sortedByTime() -> [MFTask] {
        self.sorted(by: { $0.starTime.getMilitaryTime().double < $1.starTime.getMilitaryTime().double })
    }
}

extension [EKEvent] {
    func sortedByTime() -> [EKEvent] {
        self.sorted(by: { $0.startDate.getMilitaryTime().double < $1.startDate.getMilitaryTime().double })
    }
}

class AddTaskViewModel: ObservableObject {
    static let instance = AddTaskViewModel(eventManager: EventManager.instance, firebaseManager: FirebaseManager.instance)
    
    var eventManager: EventKitService
    var firebaseManager: FirebaseManager
    
    @Published var titleInput = ""
    @Published var chosenColor = Color.yellow
    @Published var eventDate = Date()
    @Published var startTime = Date()
    @Published var endTime = Date(timeIntervalSinceNow: 1200) /// 20 minutes
    @Published var descriptionInput = ""
    @Published var selectedEventSpan: EKSpan = .futureEvents
    

    
    init(eventManager: EventKitService, firebaseManager: FirebaseManager) {
        self.eventManager = eventManager
        self.firebaseManager = firebaseManager
    }
    
    func createTaskAndEvent() {
        let event = eventManager.createEvent(title: titleInput, start: startTime, end: endTime)
        eventManager.saveEvent(event) { success in
            if success {
                let task = MFTask(id: event.eventIdentifier,
                                  title: self.titleInput,
                                  starTime: self.startTime,
                                  endTime: self.endTime,
                                  description: self.descriptionInput,
                                  isComplete: false,
                                  chosenColor: self.chosenColor)
                
                
                self.firebaseManager.saveTaskTapped(task)
//                self.eventManager.fetchEvents { ekEvents in
//                    DispatchQueue.main.async {
////                        self.ekEvents = ekEvents
//                    }
//                }
            }
        }
    }

}

extension AddTaskViewModel {
    //MARK: - Black or White Counterpart
    
    func blackOrWhite(for color: Color) -> Color {
        let uiColor = UIColor(color)
        
        // Calculate the relative luminance of the color
        let luminance = (0.299 * uiColor.cgColor.components![0] +
                         0.587 * uiColor.cgColor.components![1] +
                         0.114 * uiColor.cgColor.components![2])
        
        let threshold: CGFloat = 0.7
        
        // Determine if the color is light or dark based on the threshold
        let dark = luminance < threshold
        return dark ? .white : .black
    }
}

extension AddTaskViewModel {
    //MARK: - Duration
    
    func durationString(startTime: Date, endTime: Date) -> String {
        if startTime < endTime {
            let duration = DateInterval(start: startTime, end: endTime).duration
            let str = durationAsLogicalString(duration: duration)
            return "\(str)"
        }
        return ""
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
}
