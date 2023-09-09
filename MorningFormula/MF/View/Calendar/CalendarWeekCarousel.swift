//
//  CalendarWeekCarousel.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/8/23.
//

import SwiftUI

struct Week: Identifiable {
    var id: Int
    var dates: [Date]
}

class WeekStore: ObservableObject {
    static let instance = WeekStore()
    
    @Published var weeks: [Week] = []
    @Published var currentDay = Date()
    
    let calendar = Calendar.current
    
    init() {
        fetchWeeksAroundDate(Date())
    }
    
    func fetchWeeksAroundDate(_ date: Date) {
        previousWeek()
        fetchCurrentWeek()
        nextWeek()
    }
    
    func fetchCurrentWeek() {
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: currentDay)
        
        guard let firstWeekDay = week?.start else { return }
        
        var ctWeek = [Date]()
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                
                ctWeek.append(weekday)
            }
        }
        let wk = Week(id: UUID().hashValue, dates: ctWeek)
        self.weeks.append(wk)
    }
    
    
    func nextWeek() {
        if let weekFromCurrent = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDay) {

            var start = weekFromCurrent
            var interval: TimeInterval = 0
            let week = calendar.dateInterval(of: .weekOfYear, start: &start, interval: &interval, for: weekFromCurrent)

            let end = calendar.date(byAdding: .day, value: -1, to: start.addingTimeInterval(interval))!

            var nxtWk = [Date]()
            (1...7).forEach { day in

                if let weekday = calendar.date(byAdding: .day, value: day, to: start) {
                    nxtWk.append(weekday)
                }
            }
            let wk = Week(id: UUID().hashValue, dates: nxtWk)
            self.weeks.append(wk)

        }
    }
    
//    func nextWeek() {
//
//        if let weekFromCurrent = calendar.dateInterval(of: .weekOfYear, for: currentDay) {
//            let week = calendar.dateInterval(of: .weekOfYear, for: weekFromCurrent.end)
//
//
//            guard let firstWeekDay = week?.start else { return }
//            
////            var nxtWeek = [Date]()
//
//            (1...7).forEach { day in
//
//                if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
////                    nxtWeek.append(weekday)
//                    self.currentWeek.append(weekday)
//                }
//            }
////            self.weeks.append(nxtWeek)
//        }
//    }
    
    func previousWeek() {
        
        let lastWeekDate = Calendar(identifier: .iso8601).date(byAdding: .weekOfYear, value: -1, to: Date())!
        
        if let weekBeforeCurrent = calendar.dateInterval(of: .weekOfYear, for: lastWeekDate) {
            let week = calendar.dateInterval(of: .weekOfYear, for: weekBeforeCurrent.end)


            guard let firstWeekDay = week?.start else { return }
            
            var pvsWeek = [Date]()

            (1...7).forEach { day in

                if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                    pvsWeek.append(weekday)
                }
            }
            let wk = Week(id: UUID().hashValue, dates: pvsWeek)
            self.weeks.append(wk)
//            self.weeks.append(pvsWeek)
        }
    }
}

struct CalendarWeekCarousel: View {
    
    @StateObject var weekStore = WeekStore.instance
    
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    
    var body: some View {
//        GeometryReader { geo in
            ZStack {
                ForEach(weekStore.weeks) { week in
                    HStack {
                        ForEach(week.dates, id: \.self) { day in
                            VStack {
                                Text(day.formatted())
                            }
                        }
                    }
                    .frame(width: 200, height: 100)
                          
                          .scaleEffect(1.0 - abs(distance(week.id)) * 0.2 )
                          .opacity(1.0 - abs(distance(week.id)) * 0.3 )
                          .offset(x: myXOffset(week.id), y: 0)
                          .zIndex(1.0 - abs(distance(week.id)) * 0.1)
                    
                          .gesture(
                                 DragGesture()
                                     .onChanged { value in
                                         draggingItem = snappedItem + value.translation.width / 10
                                     }
                                     .onEnded { value in
                                         withAnimation {
                                             draggingItem = snappedItem + value.predictedEndTranslation.width / 100
                                             draggingItem = round(draggingItem).remainder(dividingBy: Double(weekStore.weeks.count))
                                             snappedItem = draggingItem
                                         }
                                     }
                             )
                }
//            }
        }
    }
    
    func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item)).remainder(dividingBy: Double(weekStore.weeks.count))
    }
    
    func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(weekStore.weeks.count) * distance(item)
        return sin(angle) * 200
    }
}

struct CalendarWeekCarousel_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWeekCarousel()
    }
}
