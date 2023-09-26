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
        print(weeks)
        self.weeks = []
        previousWeek()
        fetchCurrentWeek()
        nextWeek()
        
        print(weeks)
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
    
    
//    func nextWeek() {
//        if let weekFromCurrent = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDay) {
//
//            var start = weekFromCurrent
//            var interval: TimeInterval = 0
//            let week = calendar.dateInterval(of: .weekOfYear, start: &start, interval: &interval, for: weekFromCurrent)
//
//            let end = calendar.date(byAdding: .day, value: -1, to: start.addingTimeInterval(interval))!
//
//            var nxtWk = [Date]()
//            (1...7).forEach { day in
//
//                if let weekday = calendar.date(byAdding: .day, value: day, to: start) {
//                    nxtWk.append(weekday)
//                }
//            }
//            let wk = Week(id: UUID().hashValue, dates: nxtWk)
//            self.weeks.append(wk)
//
//        }
//    }
    
    func nextWeek() {

        if let weekFromCurrent = calendar.dateInterval(of: .weekOfYear, for: currentDay) {
            let week = calendar.dateInterval(of: .weekOfYear, for: weekFromCurrent.end)


            guard let firstWeekDay = week?.start else { return }
            
            var nxtWeek = [Date]()

            (1...7).forEach { day in

                if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                    nxtWeek.append(weekday)
//                    self.currentW eek.append(weekday)
                }
            }
            let wk = Week(id: weeks.count, dates: nxtWeek)
            self.weeks.append(wk)
        }
    }
    
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
            let wk = Week(id: weeks.count, dates: pvsWeek)
            self.weeks.append(wk)
//            self.weeks.append(pvsWeek)
        }
    }
    
    func dayOfWeekPosition(day: Date, week: Week) -> Int {
        let sorted = week.dates.sorted(by: { $0 < $1 })
        let index = sorted.firstIndex(where: { $0 == day })
        return index ?? 0
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func daySymbol(_ day: Date) -> String {
        extractDate(date: day, format: "EEE")
    }
    
    func dayNumerical(_ day: Date) -> String {
        extractDate(date: day, format: "dd")
    }
}

struct WeekView: View {
    let week: Week
    
    @ObservedObject var weekStore = WeekStore.instance

    @Binding var daySelection: Date
    
    var body: some View {
        HStack {
            ForEach(week.dates, id: \.self) { day in
                VStack(spacing: 10) {
                    Text(weekStore.daySymbol(day))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Text(weekStore.dayNumerical(day))
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .onTapGesture {
                    daySelection = day
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 100) // Adjust frame size as needed
    }
}

struct CalendarWeekCarousel: View {
    @State private var currentPage = 0
    @State private var currentDay = Date()
    
    @StateObject var weekStore = WeekStore.instance
    
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<weekStore.weeks.count, id: \.self) { index in
                WeekView(week: weekStore.weeks[index], daySelection: $currentDay)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear {
            // Initialize the current page to the middle (or any other default page)
            currentPage = weekStore.weeks.count / 2
        }
        
        .onChange(of: currentPage) { newValue in
            if let day = weekStore.weeks[newValue].dates.first {
                weekStore.fetchWeeksAroundDate(day)
            }
        }
    }
    

    
//    func distance(_ item: Int) -> Double {
//        return (draggingItem - Double(item)).remainder(dividingBy: Double(weekStore.weeks.count))
//    }
//
//    func myXOffset(_ item: Int) -> Double {
//        let angle = Double.pi * 2 / Double(weekStore.weeks.count) * distance(item)
//        return sin(angle) * 200
//    }
}

struct CalendarWeekCarousel_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWeekCarousel()
//        Home()
    }
}


//    var body: some View {
////        GeometryReader { geo in
//            ZStack {
//                ForEach(weekStore.weeks) { week in
//                    HStack {
//                        ForEach(week.dates, id: \.self) { day in
//                            VStack {
//                                Text(day.formatted())
//                            }
//                        }
//                    }
//                    .frame(width: 200, height: 100)
//
//                          .scaleEffect(1.0 - abs(distance(week.id)) * 0.2 )
//                          .opacity(1.0 - abs(distance(week.id)) * 0.3 )
//                          .offset(x: myXOffset(week.id), y: 0)
//                          .zIndex(1.0 - abs(distance(week.id)) * 0.1)
//
//                          .gesture(
//                                 DragGesture()
//                                     .onChanged { value in
//                                         draggingItem = snappedItem + value.translation.width / 10
//                                     }
//                                     .onEnded { value in
//                                         withAnimation {
//                                             draggingItem = snappedItem + value.predictedEndTranslation.width / 100
//                                             draggingItem = round(draggingItem).remainder(dividingBy: Double(weekStore.weeks.count))
//                                             snappedItem = draggingItem
//                                         }
//                                     }
//                             )
//                }
////            }
//        }
//    }

struct InfiniteCarouselView: View {
    
    @Binding var tabs: [Tab]
    @Binding var currentIndex: Int
    
    @State var fakeIndex = 0
    
    @State var offset: CGFloat = 0
    
    @State var selectedDay = Date()
    
    @ObservedObject var cm = CM.instance
    
    var body: some View {
        
        TabView(selection: $fakeIndex) {
            ForEach(tabs) { tab in
                VStack {
                    Text("My Goals")
                    HStack {
                        ForEach(tab.dates, id: \.self) { day in
                            VStack(spacing: 10) {
                                Text(cm.daySymbol(day))
                                    .font(.system(size: 16))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                Text(cm.dayNumerical(day))
                                    .font(.system(size: 17))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                            }
                            .onTapGesture {
                                self.selectedDay = day
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: OffsetKey.self, value: geo.frame(in: .global).minX)
                    }
                    )
                .onPreferenceChange(OffsetKey.self, perform: { offset in
                    self.offset = offset
                })
                .tag(getIndex(tab: tab))
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: offset) { newValue in
            if fakeIndex == 0 && offset == 0 {
                previousTabs()
            }
            if fakeIndex == 2 && offset == 0 {
                nextTabs()
            }
        }
        
//        .onAppear {
//            guard var first = tabs.first else { return }
//            guard var last = tabs.last else { return }
//            
//            first.id = UUID().uuidString
//            last.id = UUID().uuidString
//            tabs.append(first)
//            tabs.insert(last, at: 0)
//            fakeIndex = 1
//        }
    }
    
    func getIndex(tab: Tab) -> Int {
        tabs.firstIndex(where: { $0.id == tab.id }) ?? 0
    }
    
    func previousTabs() {
//        let date = tabs[currentIndex].dates
        let dates = cm.previousWeekFrom(date: selectedDay)
        let newTab = Tab(dates: dates)
        self.tabs.insert(newTab, at: 0)
    }
    
    func nextTabs() {
        let dates = cm.nextWeekFrom(date: selectedDay)
        let newTab = Tab(dates: dates)
        self.tabs.append(newTab)
    }
}

struct Tab: Identifiable, Hashable {
    var id = UUID().uuidString
    var dates: [Date]
}



struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


class CM: ObservableObject {
    static let instance = CM()
    
    let calendar = Calendar.current
    
        func datesInAWeek(from date: Date) -> [Date] {
            if let range = calendar.range(of: .weekday, in: .weekOfYear, for: date) {
                let datesArranged = range.compactMap {
                    calendar.date(byAdding: .day, value: $0 - 1, to: date)
                }
                return datesArranged
            }
            return []
        }
    
    func previousWeekFrom(date: Date) -> [Date] {
        guard let lastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: date) else {
            return []
        }
        return datesInAWeek(from: lastWeek)
    }
    
    func nextWeekFrom(date: Date) -> [Date] {
        guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: date) else {
            return []
        }
        return datesInAWeek(from: nextWeek)
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func daySymbol(_ day: Date) -> String {
        extractDate(date: day, format: "EEE")
    }
    
    func dayNumerical(_ day: Date) -> String {
        extractDate(date: day, format: "dd")
    }
}
