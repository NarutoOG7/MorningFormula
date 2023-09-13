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
    
    func forward() {
        let calendarViewStore = CalendarViewStore.instance

        let date = Calendar.current.date(byAdding: .day, value: 1, to:  self.selectedDate) ?? Date()
        calendarViewStore.calendar.fsCalendar.setCurrentPage(date, animated: true)
        self.selectedDate = date
        calendarViewStore.calendar.fsCalendar.select(date)
    }
    
    func backward() {
        let calendarViewStore = CalendarViewStore.instance

        let date = Calendar.current.date(byAdding: .day, value: -1, to: self.selectedDate) ?? Date()
        calendarViewStore.calendar.fsCalendar.setCurrentPage(date, animated: true)
        self.selectedDate = date
        calendarViewStore.calendar.fsCalendar.select(date)
    }

}
