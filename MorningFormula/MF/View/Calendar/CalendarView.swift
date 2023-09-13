//
//  CalendarView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/12/23.
//

import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var viewModel = CalendarManager.instance
    var calendarViewStore = CalendarViewStore.instance
    
    var body: some View {
        return ZStack {
            GeometryReader { geo in
                weeklyCalendarView(geo)
                VStack {
                    Spacer()
                    DayCardView(geo)
//                    RoutineView(date: $viewModel.selectedDate, forward: viewModel.forward, backward: viewModel.backward)
//                        .frame(width: geo.size.width, height: geo.size.height * 0.75)
                }
            }
        }
    }
    
    func weeklyCalendarView(_ geo: GeometryProxy) -> some View {
        VStack(spacing: -30) {
            Text(calendarViewStore.calendar.fsCalendar.selectedDate?.monthYearString() ?? "nil")
                .font(.title3)
            calendarViewStore.calendar
                .frame(maxHeight: geo.size.height / 1.75)
        }
        .padding(.top)
    }
    
}

struct CalendarView_Preview: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
