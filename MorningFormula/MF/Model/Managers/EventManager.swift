//
//  EventManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/5/23.
//

import Foundation
import EventKit

class EventManager: ObservableObject {
    static let instance = EventManager()
    
    let eventKitStore = EKEventStore()
    
    @Published var events: [EKEvent] = []
    @Published var isLoading = false
    
    func fetchEvents() {
        self.isLoading = true
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
            
            DispatchQueue.main.async {
                self.events = events
                self.isLoading = false
            }
        }
    }
    
    func requestAccess() {
        eventKitStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    // load events
                    self.fetchEvents()
                }
            }
        }
    }
    
    func createEvent() -> EKEvent {
        let event = EKEvent(eventStore: eventKitStore)
        event.title = UUID().uuidString
        event.startDate = Date().addingTimeInterval(60)
        event.endDate = Date().addingTimeInterval(300)
        event.calendar = eventKitStore.defaultCalendarForNewEvents
        return event
    }
    
    func saveEvent(_ event: EKEvent, wasSuccessful: @escaping(Bool) -> Void) {
        self.isLoading = true
        do {
            try eventKitStore.save(event, span: .futureEvents, commit: true)
            wasSuccessful(true)
        } catch {
            print(error.localizedDescription)
            wasSuccessful(false)
        }
        self.isLoading = false
    }
    
    func deleteEvent(_ event: EKEvent, wasSuccessful: @escaping(Bool) -> Void) {
        self.isLoading = true
        do {
            try eventKitStore.remove(event, span: .futureEvents, commit: true)
            wasSuccessful(true)
        } catch {
            print(error.localizedDescription)
            wasSuccessful(false)
        }
        self.isLoading = false
    }
    
    func deleteAtIndices(_ index: IndexSet) {
        for i in index.makeIterator() {
            let event = events[i]
            self.deleteEvent(event) { success in
                if success {
                    self.fetchEvents()
                }
            }
        }
    }
    
    
    func demo() {
        let event = createEvent()
        self.saveEvent(event) { success in
            if success {
                self.fetchEvents()
            }
        }
    }
}
