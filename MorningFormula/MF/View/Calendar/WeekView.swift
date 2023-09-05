//
//  WeekView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/4/23.
//

import SwiftUI

class CalendarManager: ObservableObject {
    
    static let instance = CalendarManager()
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    private(set) var today = Date()
    private(set) var startOfYear: Date
    
    @Published var totalSquares = [Date]()
    @Published var selectedDate: Date

    init() {
//        if let utc = TimeZone(identifier: "UTC") {
//            calendar.timeZone = utc
//            dateFormatter.timeZone = utc
            dateFormatter.dateFormat = "yyyyMMdd"
        selectedDate = today
        
        let currentYear = calendar.component(.year, from: today)
        if let start = calendar.date(from: DateComponents(year: currentYear, month: 1, day: 1)) {
            startOfYear = start
        } else {
            startOfYear = Date()
        }
    }
    
    func addDays(date: Date, days: Int) -> Date {
        return calendar.date(byAdding: .day, value: days, to: date)!
    }

    func sundayForDate(date: Date) -> Date {
        var current = date
        let oneWeekAgo = addDays(date: current, days: -7)

        while(current > oneWeekAgo)
        {
            let currentWeekDay = calendar.dateComponents([.weekday], from: current).weekday
            if(currentWeekDay == 1)
            {
                return current
            }
            current = addDays(date: current, days: -1)
        }
        return current
    }
    
    func setWeekView() {
        totalSquares.removeAll()
        
        var current = sundayForDate(date: selectedDate)
        let nextSunday = addDays(date: current, days: 7)
        
        while (current < nextSunday) {
//            let newCurrent = NewDate(date: current)
            totalSquares.append(current)
            current = addDays(date: current, days: 1)
        }
        
//        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
//            + " " + CalendarHelper().yearString(date: selectedDate)
//        collectionView.reloadData()
//        tableView.reloadData()
    }
    
    func dayString(_ date: Date) -> String {
        String(dayOfMonth(date: date))
    }
    
    func previousWeek() {
            selectedDate = addDays(date: selectedDate, days: -7)
            setWeekView()
    }
    
    func nextWeek() {
        selectedDate = addDays(date: selectedDate, days: 7)
        setWeekView()
    }
    
    func dayOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func weekDay(date: Date) -> Int
    {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
    func weekDayAsString(date: Date) -> String
    {
        switch weekDay(date: date)
        {
        case 0:
            return "Sun"
        case 1:
            return "Mon"
        case 2:
            return "Tue"
        case 3:
            return "Wed"
        case 4:
            return "Thu"
        case 5:
            return "Fri"
        case 6:
            return "Sat"
        default:
            return ""
        }
    }

    func datesInAWeek(from date: Date) -> [Date] {
        if let range = calendar.range(of: .weekday, in: .weekOfYear, for: date) {
            let datesArranged = range.compactMap {
                calendar.date(byAdding: .day, value: $0 - 1, to: date)
            }
            return datesArranged
        }
        return []
    }
    
    func startDateOfWeeksInAYear() -> [Date] {
        let currentWeek = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfYear)
        if let startOfWeek = calendar.date(from: currentWeek) {
            if let range = calendar.range(of: .weekOfYear, in: .year, for: startOfYear) {
                let startOfWeekArranged = range.compactMap {
                    calendar.date(byAdding: .weekOfYear, value: $0, to: startOfWeek)
                }
                return startOfWeekArranged
            }
        }
        return []
    }
    
    func startDateOfWeek(from date: Date) -> Date {
        let currentWeek = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        if let start = calendar.date(from: currentWeek) {
            return start
        }
        return Date()
    }
    
    func isToday(_ date: Date) -> Bool {
         dateFormatter.string(from: date) == dateFormatter.string(from: today)
    }
    
    func isSelected(_ date: Date) -> Bool {
        dateFormatter.string(from: date) == dateFormatter.string(from: selectedDate)
    }
    
    func weekDayColor(_ date: Date) -> Color {
        let isToday = isToday(date)
        let isSelected = isSelected(date)
        let isTodayAndNotSelected = isToday && !isSelected
        
        let selectedColor = Color.white
        let todayColorNotSelected = Color.orange
        let defaultColor = Color.blue
        
        if isToday && !isSelected { // Today But NOT Selected
            return todayColorNotSelected
        } else if isSelected {
            return selectedColor
        } else {
            return defaultColor
        }
    }
}

struct NewDate: Identifiable, Hashable {
    var date: Date
    let id = UUID()
}

struct WeekView: View {
    
    @State var selectedDate = Date()
    @ObservedObject var calendarManager = CalendarManager.instance
    
    var daysOfWeek = [Int]()
    
    init() {
        calendarManager.setWeekView()
    }
    
    @State private var currentIndex = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollDirection: ScrollDirection = .none
    
    enum ScrollDirection {
        case none, left, right
    }
    
    var body: some View {
        GeometryReader { geo in
        
        let monday = calendarManager.startDateOfWeek(from: calendarManager.selectedDate)
            SwipeableStack(calendarManager.startDateOfWeeksInAYear(), jumpTo: monday) { date in
//            SwipeableStack(calendarManager.totalSquares, jumpTo: monday) { date in
                let datesInAWeek = calendarManager.datesInAWeek(from: date)
                
                HStack(spacing: 0) {
                    ForEach(datesInAWeek.indices, id: \.self) { index in
                        let date = datesInAWeek[index]

                        VStack(spacing: 0) {
                            Text(calendarManager.weekDayAsString(date: date))
//                                .frame(width: geo.size.width / 8 - 2)
                            
                            Text(calendarManager.dayString(date))
                                .foregroundColor(calendarManager.weekDayColor(date))
                                .padding()
                                .background(
                                    ZStack {
                                        if calendarManager.isSelected(date) {
                                            Circle().fill(.red)
//                                                .frame(width: geo.size.width / 8)
                                        }
                                    }
                                )
                        }
                        .frame(width: geo.size.width / 7)
                        
                        .onTapGesture {
                            calendarManager.selectedDate = date
                        }
                        
                    }
                    }
                }
                

        }
    }
    
//    var body: some View {
//           GeometryReader { geometry in
//               ScrollView(.horizontal, showsIndicators: false) {
//                   HStack(spacing: 0) {
//                       ForEach(calendarManager.totalSquares) { square in
//                           VStack {
//                               Text(calendarManager.weekDayAsString(date: square.date))
//                               Text(calendarManager.dayString(square.date))
//                                   .frame(width: geometry.size.width / 8 - 2)
//                           }
//                       }
//                   }
//                   .frame(width: geometry.size.width * CGFloat(calendarManager.totalSquares.count), alignment: .leading)
//                   .offset(x: -CGFloat(currentIndex) * geometry.size.width)
//                   .gesture(DragGesture().onChanged { value in
//                       let offset = value.translation.width
//                       scrollDirection = offset > 0 ? .right : .left
//                       scrollOffset = offset
//
//                       if scrollDirection == .left {
//                           calendarManager.previousWeek()
//                       } else if scrollDirection == .right {
//                           calendarManager.nextWeek()
//                       }
//
//                   }.onEnded { value in
//                       let maxOffset = CGFloat(calendarManager.totalSquares.count - 1) * geometry.size.width
//                       if abs(scrollOffset) > geometry.size.width * 0.2 {
//                           currentIndex += scrollDirection == .left ? 1 : -1
//                           currentIndex = min(max(currentIndex, 0), calendarManager.totalSquares.count - 1)
//                       }
//                       withAnimation {
//                           scrollOffset = 0
//                       }
//                   })
//               }
//               .onAppear {
//                   // Scroll to the desired initial index when the view appears
//                   scrollToIndex(currentIndex)
//               }
//           }
//    }
    
    // Function to scroll to a specific index
    private func scrollToIndex(_ index: Int) {
        withAnimation {
            currentIndex = index
        }
    }
    
//    var body: some View {
//        ScrollView(.horizontal) {
//            HStack {
//                ForEach(calendarManager.totalSquares) { square in
//                    Text(calendarManager.dayString(square.date))
//                }
//            }
//        }
//    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView()
    }
}



struct SwipeableStack<AnyData:Hashable, Content>: View where Content: View {
    
    var anyData: [AnyData] = []
    let content: (AnyData) -> Content
    var jumpTo: AnyData?
    
    init(_ data: [AnyData], jumpTo: AnyData? = nil, @ViewBuilder content: @escaping (AnyData) -> Content) {
        self.anyData = data
        self.content = content
        if let jumpTo {
            self.jumpTo = jumpTo
        }
    }
    
    @State private var dataIndex = 0
    @State private var dragged = CGSize.zero
    
    var previousExist: Bool {
        (dataIndex - 1) >= 0
    }
    
    var nextExists: Bool {
        dataIndex < anyData.count - 1
    }
    
    var body: some View {
        GeometryReader { geo in
            let frameWidth = geo.size.width
            
            HStack(spacing: 0) {
                if previousExist {
                    content(anyData[dataIndex - 1]) /// Previous
                        .frame(width: frameWidth)
                        .offset(x: previousExist ? -frameWidth : 0)
                }
                content(anyData[dataIndex]) /// Current
                    .frame(width: frameWidth)
                    .offset(x: previousExist ? -frameWidth : 0)
                if nextExists {
                    content(anyData[dataIndex + 1]) /// Next
                        .frame(width: frameWidth)
                        .offset(x: previousExist ? -frameWidth : 0)
                }
            }
            .onAppear {
                if let jumpTo {
                    if let pos = anyData.firstIndex(of: jumpTo) {
                        dataIndex = pos
                    }
                }
            }
            
            .offset(x: dragged.width)
            .gesture(DragGesture()
                .onChanged({ value in
                    dragged.width = value.translation.width
                })
                    .onEnded({ value in
                        var indexOffset = 0
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dragged = CGSize.zero
                            if value.predictedEndTranslation.width < -frameWidth / 2 && nextExists {
                                dragged.width = -frameWidth
                                indexOffset = 1 /// Next
                            }
                            if value.predictedEndTranslation.width > frameWidth / 2 && previousExist {
                                dragged.width = frameWidth
                                indexOffset = -1
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            dataIndex += indexOffset
                            dragged = CGSize.zero
                        }
                    })
            )
        }
    }
    
}
