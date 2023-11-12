//
//  EventManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/5/23.
//

import SwiftUI
import EventKit

class EventManager: EventKitService {
    static let instance = EventManager()
    
    let eventKitStore = EKEventStore()
    
    func fetchEvents(withCompletion completion: @escaping([EKEvent]) -> Void) {
        // Get the appropriate calendar.
        var calendar = Calendar.current
        
        // Get the start date, which is the beginning of the current day
        let startDate = calendar.startOfDay(for: Date())

        // Get the end date, which is the end of the current day
        if let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate) {
            
            // Create a predicate for events within the specified time frame
            let predicate = eventKitStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
            
            // Fetch all events that match the predicate.
            var events = eventKitStore.events(matching: predicate)
            
           completion(events)
        }
        completion([])
    }
    
    func requestAccessOrFetchEvents(withCompletion completion: @escaping([EKEvent]) -> Void) {
        eventKitStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                    // load events
                self.fetchEvents(withCompletion: completion)
                }
            
        }
    }
    
    func createEvent(title: String, start: Date, end: Date) -> EKEvent {
        let event = EKEvent(eventStore: eventKitStore)
        event.title = title
        event.startDate = start
        event.endDate = end
        event.calendar = eventKitStore.defaultCalendarForNewEvents
        
        event.recurrenceRules = [createRecurrenceRule()]

        return event
    }
    
    func createRecurrenceRule() -> EKRecurrenceRule {
        // Define the weekdays on which the event should recur (e.g., Monday and Thursday)
        let weekdays: [EKRecurrenceDayOfWeek] = [
            .init(.monday),
            .init(.thursday)
        ]
        // Create the EKRecurrenceRule for a weekly recurrence
        let rule = EKRecurrenceRule(recurrenceWith: .weekly,
                                    interval: 2,
                                    daysOfTheWeek: weekdays,
                                    daysOfTheMonth: nil,
                                    monthsOfTheYear: nil,
                                    weeksOfTheYear: nil,
                                    daysOfTheYear: nil,
                                    setPositions: nil, end: nil)
        return rule
    }
    
    func saveEvent(_ event: EKEvent, wasSuccessful: @escaping(Bool) -> Void) {
        do {
            try eventKitStore.save(event, span: AddTaskViewModel.instance.selectedEventSpan, commit: true)
            wasSuccessful(true)
        } catch {
            print(error.localizedDescription)
            wasSuccessful(false)
        }
    }
    
    func deleteEvent(_ event: EKEvent, span: EKSpan, wasSuccessful: @escaping(Bool) -> Void) {
        do {
            try eventKitStore.remove(event, span: span, commit: true)
            wasSuccessful(true)
        } catch {
            print(error.localizedDescription)
            wasSuccessful(false)
        }
    }
    
    func getEvent(from id: String) -> EKEvent? {
       eventKitStore.event(withIdentifier: id)
    }
}

protocol EventKitService {
    func fetchEvents(withCompletion completion: @escaping([EKEvent]) -> Void)
    func requestAccessOrFetchEvents(withCompletion completion: @escaping([EKEvent]) -> Void)
    func createEvent(title: String, start: Date, end: Date) -> EKEvent 
    func saveEvent(_ event: EKEvent, wasSuccessful: @escaping(Bool) -> Void)
    func deleteEvent(_ event: EKEvent, span: EKSpan, wasSuccessful: @escaping(Bool) -> Void)
    func getEvent(from id: String) -> EKEvent?

}

