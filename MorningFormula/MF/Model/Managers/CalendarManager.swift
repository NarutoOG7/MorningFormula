//
//  CalendarManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/12/23.
//

import SwiftUI

class CalendarManager: ObservableObject {
    static let instance = CalendarManager()
    
    @Published var selectedDate = Date()
    @Published var wheelDates: [Date] = [Date()]

    func forward() {
        self.wheelDates = []

        let calendarViewStore = CalendarViewStore.instance

        let date = Calendar.current.date(byAdding: .day, value: 1, to:  self.selectedDate) ?? Date()
        calendarViewStore.calendar.fsCalendar.setCurrentPage(date, animated: true)
        self.selectedDate = date
        calendarViewStore.calendar.fsCalendar.select(date)
        self.allThreeDays()
    }
    
    func backward() {
        self.wheelDates = []
        let calendarViewStore = CalendarViewStore.instance

        let date = dayBefore()
        calendarViewStore.calendar.fsCalendar.setCurrentPage(date, animated: true)
        self.selectedDate = date
        calendarViewStore.calendar.fsCalendar.select(date)
        self.allThreeDays()
    }
    
    func dayBefore() -> Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self.selectedDate) ?? Date()
    }

    func dayAfter() -> Date {
       Calendar.current.date(byAdding: .day, value: 1, to: self.selectedDate) ?? Date()
    }
    
    
    func allThreeDays() {
        self.wheelDates = [
            dayBefore(),
            self.selectedDate,
            dayAfter()
        ]
        
    }
}
