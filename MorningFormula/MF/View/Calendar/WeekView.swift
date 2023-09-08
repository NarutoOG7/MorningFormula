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
    @Published var currentDate: Date
    private(set) var startOfYear: Date
    
    @Published var days: [Date] = []
    
    @Published var dayArray: [Date] = []
    
    @Published var totalSquares = [Date]()
//    @Published var selectedDate: Date = Date()

    init() {
//        if let utc = TimeZone(identifier: "UTC") {
//            calendar.timeZone = utc
//            dateFormatter.timeZone = utc


        
            dateFormatter.dateFormat = "yyyyMMdd"
        
        currentDate = today
        
        let todayStr = dateFormatter.string(from: today)
        let toDay = dateFormatter.date(from: todayStr) ?? Date()
        currentDate = toDay
        
        let currentYear = calendar.component(.year, from: toDay)
        if let start = calendar.date(from: DateComponents(year: currentYear, month: 1, day: 1)) {
            startOfYear = start
        } else {
            startOfYear = Date()
        }
        self.days = self.startDateOfDaysInAYear()
//        self.dayArray = self.startDateOfWeeksInAYear()
    }
    
    func setCurrentDate(to date: Date) {
        let dateStr = dateFormatter.string(from: date)
        if let current = dateFormatter.date(from: dateStr) {
            print(current.formatted())
            currentDate =  current
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
    
    func dayString(_ date: Date) -> String {
        String(dayOfMonth(date: date))
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
    
    func datesInAYear(from date: Date) -> [Date] {
        if let range = calendar.range(of: .day, in: .year, for: date) {
            let datesArranged = range.compactMap {
                calendar.date(byAdding: .day, value: $0 - 1, to: date)
            }
            return datesArranged
        }
        return []
    }
    
    
    func daysInYear(from date: Date) -> [Date] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        if let yearStart = calendar.date(from: calendar.dateComponents([.year], from: date)),
           let range = calendar.range(of: .day, in: .year, for: yearStart) {
            
            let datesArranged = range.compactMap {
                calendar.date(byAdding: .day, value: $0, to: yearStart)
            }
            
            print(datesArranged)
            return datesArranged
        }
        return []
    }
    
    
//    func daysInYear(from date: Date) -> [Date] {
//        if let range = calendar.range(of: .day, in: .year, for: date) {
//            let numDays = range.count
//            let datesArranged = range.compactMap {
//                calendar.date(byAdding: .day, value: $0 - 1, to: date)
//            }
//            print(datesArranged)
//            return datesArranged
//        }
//        return []
//    }
    
    
    func startOfDaysInYear() -> [Date] {
        let day = calendar.dateComponents([.day], from: currentDate)
        if let days = calendar.date(from: day) {
            if let range = calendar.range(of: .day, in: .year, for: startOfYear) {
                let daysArranged = range.compactMap {
                    calendar.date(byAdding: .day, value: $0, to: days)
                }
                return daysArranged
            }
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
    
    func startDateOfDaysInAYear() -> [Date] {
        if let range = calendar.range(of: .day, in: .year, for: startOfYear) {
            let datesArranged = range.compactMap {
                calendar.date(byAdding: .day, value: $0, to: startOfYear)
            }
            print(datesArranged.count)
            return datesArranged
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
    

    
    func nextDay(from date: Date) -> Date {
        let next = startDateOfWeek(from: date)
        print(next.formatted())
        return next
    }
    
    
//    func nextDay(from date: Date) -> Date {
////        let currentDate = calendar.dateComponents([.day], from: date)
//        if let next = calendar.date(byAdding: .day, value: 1, to: date) {
//            print(next.formatted())
//            return next
//        }
//        return Date()
//    }
    
    func isToday(_ date: Date) -> Bool {
         dateFormatter.string(from: date) == dateFormatter.string(from: today)
    }
    
    func isSelected(_ date: Date) -> Bool {
        dateFormatter.string(from: date) == dateFormatter.string(from: currentDate)
    }
    
    func weekDayColor(_ date: Date) -> Color {
        let isToday = isToday(date)
        let isSelected = isSelected(date)
        
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
    
    func currentPositionInWeek() -> Int {
        let startOfWeek = startDateOfWeek(from: currentDate)
        let datesInAWeek = datesInAWeek(from: startOfWeek)
        let position = datesInAWeek.firstIndex(of: currentDate)
        return position ?? 0
    }
    
    func currentPositionInYear() -> Int {
        let datesInYear = datesInAYear(from: startOfYear)
        let position = datesInYear.firstIndex(of: currentDate)
        return position ?? 0
    }
    
//    func days() -> [Date] {
//
//    }
}

extension Date {
    func monthYYYY() -> String {
        self.formatted(.dateTime .month(.wide) .year())
    }
}

struct NewDate: Identifiable, Hashable {
    var date: Date
    let id = UUID()
}

struct WeekView: View {
    
    @Binding var currentWeekIndex: Int
    @ObservedObject var calendarManager = CalendarManager.instance
        
    var viewPosition: ViewPosition = .centerView
        
    @State private var currentIndex = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollDirection: ScrollDirection = .none
    
    let geo: GeometryProxy
    
    let monday = CalendarManager.instance.startDateOfWeek(from: CalendarManager.instance.currentDate)

    @State private var stack = SwipeableStack<Date, DayTaskCell>()

    init(geo: GeometryProxy, currentWeekIndex: Binding<Int>) {
            self._currentWeekIndex = currentWeekIndex
        self.geo = geo
            // Initialize your SwipeableStack with the jumpTo parameter
            let monday = calendarManager.startDateOfWeek(from: calendarManager.currentDate)
//            self._stack = State(initialValue: SwipeableStack(data: calendarManager.startDateOfWeeksInAYear(), jumpTo: monday) { date, pos in
//                DayOfWeekCell(date: date, geo: geo, viewPosition: pos)
//            })
        
        }
       
    
    enum ScrollDirection {
        case none, left, right
    }
    
    var body: some View {
        GeometryReader { geo in
        
            let monday = calendarManager.startDateOfWeek(from: calendarManager.currentDate)
            
            stack.

//            SwipeableStack(calendarManager.startDateOfWeeksInAYear(), jumpTo: monday) { date, pos in
//
//                DayOfWeekCell(date: date, geo: geo, viewPosition: pos)
//            }

        }
    }

}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            WeekView(geo: geo, currentWeekIndex: .constant(1))
        }
    }
}

struct DayOfWeekCell: View {
    
    @ObservedObject var calendarManager = CalendarManager.instance
    let date: Date
    let geo: GeometryProxy
    var viewPosition: ViewPosition = .centerView
    
    var body: some View {
        let datesInAWeek = calendarManager.datesInAWeek(from: date)
        
        HStack(spacing: 0) {
            ForEach(datesInAWeek.indices, id: \.self) { index in
                let date = datesInAWeek[index]

                ZStack {
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
                                            .frame(width: geo.size.width / 10)
                                    }
                                }
                            )

                    }
                    .frame(width: geo.size.width / 7)
                    

                }
                
                .onTapGesture {
                    calendarManager.currentDate = date
                    
//                    print(date)
//                    calendarManager.setCurrentDate(to: date)
                }
                
            }
            
            }
        .onChange(of: date) { newValue in
            if viewPosition == .centerView {
                let position = calendarManager.currentPositionInWeek()
                let dtWeek = calendarManager.datesInAWeek(from: newValue)
                let day = dtWeek[position]
                print(day.formatted())
//             /   calendarManager.setCurrentDate(to: dtWeek[position])
                calendarManager.currentDate = day

            }
        }
    }
}


struct SwipeableStack<AnyData:Hashable, Content>: View where Content: View {
    
    var anyData: [AnyData] = []
    let content: (AnyData, ViewPosition) -> Content
    var jumpTo: AnyData?
    
    
    
//    init(_ data: [AnyData], jumpTo: AnyData? = nil, @ViewBuilder content: @escaping (AnyData, ViewPosition) -> Content) {
//        self.anyData = data
//        self.content = content
//        if let jumpTo {
//            self.jumpTo = jumpTo
//        }
//    }
    
    @State private var dataIndex = 0
    @State private var dragged = CGSize.zero
    
    init() {
        
    }
    
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
                    content(anyData[dataIndex - 1], .previousView) /// Previous
                        .frame(width: frameWidth)
                        .offset(x: previousExist ? -frameWidth : 0)
                }
                content(anyData[dataIndex], .centerView) /// Current
                    .frame(width: frameWidth)
                    .offset(x: previousExist ? -frameWidth : 0)
                if nextExists {
                    content(anyData[dataIndex + 1], .nextView) /// Next
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
                                indexOffset = -1 /// Previous
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
    
    mutating func jumpToItem(_ item: AnyData) {
        if let pos = anyData.firstIndex(of: item) {
            dataIndex = pos
        }
    }
}

struct DayCard: View {
    
    let date: Date
    let geo: GeometryProxy
    
    var body: some View {
        ZStack {
        RoundedRectangle(cornerRadius: 25)
            .fill(.yellow)
            .ignoresSafeArea()
        Text(date.formatted())

}
    .padding(.top, 100)
    .frame(width: geo.size.width)
    }
}

enum ViewPosition {
    case previousView
    case centerView
    case nextView
}
