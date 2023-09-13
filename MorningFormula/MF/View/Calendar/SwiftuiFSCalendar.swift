//
//  SwiftuiFSCalendar.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/10/23.
//

import SwiftUI
import FSCalendar
import SwiftUIInfiniteCarousel


struct SwiftUIFSCalendar: UIViewRepresentable {
    
    @ObservedObject var vm = CalendarManager.instance
    
    let fsCalendar = FSCalendar()
    var coordinator: Coordinator?
    
    func makeUIView(context: Context) -> FSCalendar {
        
        fsCalendar.delegate = context.coordinator
        fsCalendar.dataSource = context.coordinator
        
        selectDate(vm.selectedDate)
        
        fsCalendar.scrollDirection = .horizontal
        fsCalendar.scope = .week
        fsCalendar.locale = Locale(identifier: "en")
        
        fsCalendar.calendarHeaderView.isHidden = true
        
        fsCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 20)
        fsCalendar.appearance.weekdayTextColor = .darkGray
        
        fsCalendar.appearance.titleFont = UIFont.systemFont(ofSize: 16)
        fsCalendar.appearance.titleFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        
        fsCalendar.appearance.todayColor = .clear
        fsCalendar.appearance.titleTodayColor = .orange
        
        fsCalendar.appearance.selectionColor = .blue
        fsCalendar.appearance.titleSelectionColor = .orange
        
        fsCalendar.appearance.borderSelectionColor = .blue
        fsCalendar.appearance.titleSelectionColor = .orange
        
        fsCalendar.appearance.borderRadius = 20
        
        
        return fsCalendar
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //        fsCalendar.setCurrentPage(selectedDate, animated: true)
        //        fsCalendar.select(vm.selectedDate)
        
    }
    
    func selectDate(_ date: Date) {
        //        self.selectedDate = date
        self.fsCalendar.select(date, scrollToDate: true)
    }
    
    func makeCoordinator() -> Coordinator{
        let cd = Coordinator(self)
        return cd
    }
    
    
    
    //MARK: - Coordinator
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: SwiftUIFSCalendar
        
        init(_ parent: SwiftUIFSCalendar) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.vm.selectedDate = date
            calendar.select(date)
        }
        
        
        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            
            if parent.vm.selectedDate < calendar.currentPage {
                let date = addSevenTo(calendar.selectedDate ?? Date())
                calendar.select(date)
                parent.vm.selectedDate = date
            } else {
                let date = subtractSevenFrom(calendar.selectedDate ?? Date())
                calendar.select(date)
                parent.vm.selectedDate = date
            }
        }
        
        func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            parent.fsCalendar.frame = CGRect(origin: calendar.frame.origin,
                                             size: bounds.size)
        }
        
        
        func addSevenTo(_ date: Date) -> Date {
            Calendar.current.date(byAdding: .day, value: 7, to: date) ?? Date()
            
        }
        
        func subtractSevenFrom(_ date: Date) -> Date {
            Calendar.current.date(byAdding: .day, value: -7, to: date) ?? Date()
            
        }
    }
}




