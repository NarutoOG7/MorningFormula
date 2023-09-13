//
//  CalendarViewStore.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/12/23.
//

import SwiftUI

class CalendarViewStore {
    static let instance = CalendarViewStore()
    
    @ObservedObject var calendarViewModel = CalendarManager.instance
    
    var calendar: SwiftUIFSCalendar
    
    init() {
        self.calendar = SwiftUIFSCalendar()
        self.calendar.fsCalendar.select(Date())
    }
}
