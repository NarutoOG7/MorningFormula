////
////  TaskWeekView.swift
////  MorningFormula
////
////  Created by Spencer Belton on 9/6/23.
////
//
//import SwiftUI
//
//class TaskWeekVM: ObservableObject {
//    
//    static let instance = TaskWeekVM()
//    
//    @Published var currentWeek: [Date] = []
//    
//    @Published var weeks: [[Date]] = []
//    
//   @Published var currentDay = Date()
//    
//    let calendar = Calendar.current
//
//    init() {
////        fetchWeeksAroundDate(Date())
//        fetchCurrentWeek()
//    }
//    
//    func fetchWeeksAroundDate(_ date: Date) {
//        previousWeek()
//        fetchCurrentWeek()
//        nextWeek()
//    }
//    
//    func fetchCurrentWeek() {
//        
//        let week = calendar.dateInterval(of: .weekOfMonth, for: currentDay)
//        
//        guard let firstWeekDay = week?.start else { return }
//        
////        var ctWeek = [Date]()
//        (1...7).forEach { day in
//            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
////                ctWeek.append(weekday)
//                self.currentWeek.append(weekday)
//            }
//        }
////        self.weeks.append(ctWeek)
//    }
//    
//    
//    func nextWeek() {
//        if let weekFromCurrent = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDay) {
//
//            var start = weekFromCurrent
//            var interval: TimeInterval = 0
//            let week = calendar.dateInterval(of: .weekOfYear, start: &start, interval: &interval, for: weekFromCurrent)
//
//            let end = calendar.date(byAdding: .day, value: -1, to: start.addingTimeInterval(interval))!
//            // or let end = start.addingTimeInterval(interval - 1)
//            // or let end = calendar.date(byAdding: .day, value: 6, to: start)!
//
////            print(formatter.string(from: start), "-", formatter.string(from: end))
//
////            let week = calendar.dateInterval(of: .weekOfYear, for: w)
//
//
//
//            (1...7).forEach { day in
//
//                if let weekday = calendar.date(byAdding: .day, value: day, to: start) {
//                    currentWeek.append(weekday)
//                }
//            }
////            currentDay = end
//            print(currentDay.formatted())
//
//        }
//
//    }
//    
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
//    
//    func previousDay(date: Date) -> Date {
//        return calendar.date(byAdding: .day, value: -1, to: date) ?? Date()
//    }
//    
//    func nextDay(date: Date) -> Date {
//        return calendar.date(byAdding: .day, value: 1, to: date) ?? Date()
//    }
//    
//    func previousWeek() {
//
////        if let weekBeforeCurrent = calendar.dateInterval(of: .weekOfYear, for: currentDay) {
//        
//        let lastWeekDate = Calendar(identifier: .iso8601).date(byAdding: .weekOfYear, value: -1, to: Date())!
//        
//        if let weekBeforeCurrent = calendar.dateInterval(of: .weekOfYear, for: lastWeekDate) {
//            let week = calendar.dateInterval(of: .weekOfYear, for: weekBeforeCurrent.end)
//
//
//            guard let firstWeekDay = week?.start else { return }
//            
////            var pvsWeek = [Date]()
//
//            (1...7).forEach { day in
//
//                if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
////                    pvsWeek.append(weekday)
//                    self.currentWeek.append(weekday)
//                }
//            }
////            self.weeks.append(pvsWeek)
//        }
//    }
//    
//    func extractDate(date: Date, format: String) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = format
//        return formatter.string(from: date)
//    }
//    
//    func isToday(_ date: Date) -> Bool {
//        calendar.isDate(Date(), inSameDayAs: date)
//    }
//    
//    func isCurrent(_ date: Date) -> Bool {
//        date.isSameDay(as: currentDay)
//    }
//}
//
//enum SwipeDirection {
//    case backward, forward
//}
//
//struct TaskWeekView: View {
//    
//    
//    @State private var swipeDirection: SwipeDirection?
//
//    
//    @ObservedObject var taskWeekVM = TaskWeekVM.instance
//    
//    @GestureState private var translation: CGFloat = 0
//    @State private var offset: CGFloat = 0
//
////
////    var body: some View {
//////        ScrollView(.horizontal, showsIndicators: false) {
////
////            HStack {
////
//////                let _ = print(taskWeekVM.weeks.count)
//////                ForEach(taskWeekVM.weeks.indices, id: \.self) { week in
//////                    let weekDays = taskWeekVM.weeks[week]
//////
//////                    ForEach(weekDays, id: \.self) { day in
//////                        WeekDayView(day: day)
//////                    }
//////                }
////
////                ForEach(taskWeekVM.currentWeek, id: \.self) { day in
////                    WeekDayView(day: day)
////                }
////
////
////
////            }
////            .padding()
////
////            .gesture(
////                DragGesture(minimumDistance: 3.0,
////                            coordinateSpace: .local)
////                .onEnded({ value in
////
////                    switch (value.translation.width, value.translation.height) {
////
////                    case (...0, -200...200):
////                        print("left swipe")
////                        self.swipeDirection = .forward
////                        withAnimation(.easeInOut) {
////                            offset += (UIScreen.main.bounds.width * 2)
////                            taskWeekVM.nextWeek()
////                        }
////
////                    case (0..., -200...200):
////                        print("right swipe")
////                        self.swipeDirection = .backward
////                        withAnimation(.easeInOut) {
////                            offset -= UIScreen.main.bounds.width
////                            taskWeekVM.previousWeek()
////                        }
////                    case (-100...100, 0...):
////                        print("Up?")
////
////
////                    default: print("no clue")
////                    }
////                }))
////            .transition(.asymmetric(
////                insertion: swipeDirection == .forward ? .move(edge: .trailing) : .move(edge: .leading),
////                removal: swipeDirection == .forward ? .move(edge: .leading) : .move(edge: .trailing)))
////
////
//////        }
////
////
//////        }
////    }
//    
////    var body: some View {
////
////        HStack(spacing: 0) {
////
////                ForEach(taskWeekVM.currentWeek, id: \.self) { day in
////
////                        WeekDayView(day: day)
////                            .gesture(
////                                DragGesture(minimumDistance: 3.0,
////                                            coordinateSpace: .local)
////                                .onEnded({ value in
////
////                                    switch (value.translation.width, value.translation.height) {
////
////                                    case (...0, -200...200):
////                                        print("left swipe")
////                                        self.swipeDirection = .forward
////                                        withAnimation {
////                                            taskWeekVM.nextWeek()
////                                        }
////
////
////                                    case (0..., -200...200):
////                                        print("right swipe")
////                                        self.swipeDirection = .backward
////                                        taskWeekVM.previousWeek()
////
////                                    default: print("no clue")
////                                    }
////                                }))
////                            .transition(.asymmetric(
////                                insertion: swipeDirection == .forward ? .move(edge: .trailing) : .move(edge: .leading),
////                                removal: swipeDirection == .forward ? .move(edge: .leading) : .move(edge: .trailing)))
////                }
////            }
////    }
//    
//    var body: some View {
//            HStack(spacing: 0) {
//                ForEach(taskWeekVM.currentWeek, id: \.self) { day in
//                    WeekDayView(day: day)
//                }
//            }
//            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
//            .offset(x: offset + translation)
//            .gesture(
//                DragGesture()
//                    .updating($translation) { value, state, _ in
//                        state = value.translation.width
//                    }
//                    .onEnded { value in
//                        let threshold: CGFloat = UIScreen.main.bounds.width / 2
//                        if value.translation.width > threshold {
//                            // Swipe right (previous week)
//                            withAnimation {
//                                taskWeekVM.previousWeek()
//                                offset -= UIScreen.main.bounds.width
//                            }
//                        } else if value.translation.width < -threshold {
//                            // Swipe left (next week)
//                            withAnimation {
//                                taskWeekVM.nextWeek()
//                                offset += UIScreen.main.bounds.width
//                            }
//                        }
//                    }
//            )
//        }
//    
////    var body: some View {
////            HStack(spacing: 0) {
////                ForEach(taskWeekVM.currentWeek, id: \.self) { day in
////                    let dayIsToday = taskWeekVM.isToday(day)
////                                          let dayIsSelected = taskWeekVM.isCurrent(day)
////                                          let dayIsTodayAndSelected = dayIsToday && dayIsSelected
////                                          VStack {
////                                              weekDaySymbol(day)
////                                              weekDayNumerical(day)
////
////                                              circle(day)
////                                          }
////                                          .foregroundStyle(dayIsToday ? .primary : .secondary)
////                                          .foregroundColor(dayIsToday ? .black : .black)
////
////                                          .foregroundStyle(dayIsSelected ? .primary : .secondary)
////                                          .foregroundColor(dayIsSelected ? .white : .black)
////
////                                          .frame(width: 45, height: 90)
////                                          .background(
////                                              ZStack {
////                                                  // Matched Geometry
////                                                  capsule(day)
////                                              }
////                                          )
////                                          .contentShape(Capsule())
////
////                                          .onTapGesture {
////                                              withAnimation {
////                                                  taskWeekVM.currentDay = day
////                                              }
////                                          }
////
////
////                }
////                .padding()
////            }
////            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
////            .offset(x: offset + translation)
////            .gesture(
////                DragGesture()
////                    .updating($translation) { value, state, _ in
////                        state = value.translation.width
////                    }
////                    .onEnded { value in
////                        let threshold: CGFloat = UIScreen.main.bounds.width / 2
////                        if value.translation.width > threshold {
////                            // Swipe right (previous week)
////                            withAnimation {
//////                                taskWeekVM.previousWeek()
////                                offset -= UIScreen.main.bounds.width
////                            }
////                        } else if value.translation.width < -threshold {
////                            // Swipe left (next week)
////                            withAnimation {
////                                taskWeekVM.nextWeek()
////                                offset += UIScreen.main.bounds.width
////                            }
////                        }
////                    }
////            )
//////            .animation(.spring())
//////            .animation(.spring())
////        }
//    
//
//}
//
//
//struct TaskWeekView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskWeekView()
//    }
//}
//
//struct WeekDayView: View {
//    
//    @Namespace var animation
//
//    @ObservedObject var taskWeekVM = TaskWeekVM.instance
//    
//    let day: Date
//    
//    var body: some View {
//        let dayIsToday = taskWeekVM.isToday(day)
//        let dayIsSelected = taskWeekVM.isCurrent(day)
//        let dayIsTodayAndSelected = dayIsToday && dayIsSelected
//        VStack {
//            weekDaySymbol(day)
//            weekDayNumerical(day)
//
//            circle(day)
//        }
//        .foregroundStyle(dayIsToday ? .primary : .secondary)
//        .foregroundColor(dayIsToday ? .black : .black)
//
//        .foregroundStyle(dayIsSelected ? .primary : .secondary)
//        .foregroundColor(dayIsSelected ? .white : .black)
//
//        .frame(width: 45, height: 90)
//        .background(
//            ZStack {
//                // Matched Geometry
//                capsule(day)
//            }
//        )
//        .contentShape(Capsule())
//
//        .onTapGesture {
//            withAnimation {
//                taskWeekVM.currentDay = day
//            }
//        }
//    }
//    
//    private func weekDaySymbol(_ day: Date) -> some View {
//        let dayIsToday = taskWeekVM.isToday(day)
//        let dayIsSelected = taskWeekVM.isCurrent(day)
//        return ZStack {
//            
//            if dayIsToday {
//                
//                Text(taskWeekVM.extractDate(date: day, format: "EEE"))
//                    .font(.system(size: 14))
//                    .fontWeight(.semibold)
//                    .foregroundColor(.black)
//            }
//            if dayIsSelected {
//                
//                Text(taskWeekVM.extractDate(date: day, format: "EEE"))
//                    .font(.system(size: 14))
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                
//            }
//
//            if !dayIsToday && !dayIsSelected {
//                Text(taskWeekVM.extractDate(date: day, format: "EEE"))
//                    .font(.system(size: 14))
//                    .fontWeight(.semibold)
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//    
//    private func weekDayNumerical(_ day: Date) -> some View {
//        let dayIsToday = taskWeekVM.isToday(day)
//        let dayIsSelected = taskWeekVM.isCurrent(day)
//        return ZStack {
//            
//            if dayIsToday && dayIsSelected {
//                Text(taskWeekVM.extractDate(date: day, format: "dd"))
//                    .font(.system(size: 15))
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//            }
//            
//            if dayIsToday && !dayIsSelected {
//                Text(taskWeekVM.extractDate(date: day, format: "dd"))
//                    .font(.system(size: 15))
//                    .fontWeight(.semibold)
//                    .foregroundColor(.black)
//            }
//            
//            if !dayIsToday {
//                Text(taskWeekVM.extractDate(date: day, format: "dd"))
//                    .font(.system(size: 15))
//                    .fontWeight(.semibold)
//                    .foregroundColor(.gray)
//            }
//            
//            if dayIsSelected {
//                Text(taskWeekVM.extractDate(date: day, format: "dd"))
//                    .font(.system(size: 15))
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//            }
//            
//
//        }
//    }
//    
//    private func circle(_ day: Date) -> some View {
//        let dayIsToday = taskWeekVM.isToday(day)
//        let dayIsSelected = taskWeekVM.isCurrent(day)
//        let dayIsTodayAndSelected = dayIsToday && dayIsSelected
//        
//        return ZStack {
//            
//            if dayIsTodayAndSelected {
//                 Circle()
//                    .fill(.white)
//                    .frame(width: 8, height: 8)
//                    .opacity(1)
//            }
//            
//            if dayIsToday && !dayIsSelected {
//                Circle()
//                   .fill(.black)
//                   .frame(width: 8, height: 8)
//                   .opacity(1)
//            }
//            
//            if dayIsSelected && !dayIsToday {
//                Circle()
//                   .fill(.white)
//                   .frame(width: 8, height: 8)
//                   .opacity(1)
//            }
//        }
//    }
//    
//    private func capsule(_ day: Date) -> some View {
//        let dayIsToday = taskWeekVM.isToday(day)
//        let dayIsSelected = taskWeekVM.isCurrent(day)
//        let dayIsTodayAndSelected = dayIsToday && dayIsSelected
//        
//        return ZStack {
//            if dayIsSelected {
//                Capsule()
//                    .fill(.black)
//                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
//            }
//            
//            if dayIsTodayAndSelected || dayIsSelected {
//                Capsule()
//                    .stroke(lineWidth: 0.8)
//                    .fill(.black)
//                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
//            }
//            
//            
//        }
//    }
//}
