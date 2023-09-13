//////
//////  PlannerView.swift
//////  MorningFormula
//////
//////  Created by Spencer Belton on 9/5/23.
//////
////
//import SwiftUI
////
////struct PlannerView: View {
////
////    @ObservedObject var calendarManager = CalendarManager.instance
////
////    var viewPosition: ViewPosition = .centerView
////    @State private var currentWeekIndex: Int = 0
//////    @State var selectedDate: Date = Date()
////
////
////    var body: some View {
////        GeometryReader { geo in
////        VStack(alignment: .leading, spacing: 0) {
////            headerView
//////                .padding(.horizontal)
////                .padding(10)
////            WeekView(geo: geo)
////                .frame(maxHeight: 80)
////
//////            let monday = calendarManager.nextDay(from: calendarManager.currentDate)
//////            SwipeableStack(calendarManager.startDateOfWeeksInAYear(), jumpTo: monday) { date, pos in
//////
//////                ZStack {
//////                    RoundedRectangle(cornerRadius: 25)
//////                        .fill(.yellow)
//////                        .ignoresSafeArea()
//////                    Text(date.formatted())
//////
//////            }                 }
////
//////            let nextDay = calendarManager.nextDay(from: selectedDate)
////
//////                .onAppear {
//////                    calendarManager.days = calendarManager.startDateOfDaysInAYear()
//////                }
////            let next = calendarManager.datesInAYear(from: calendarManager.currentDate)
////            let _ = print(calendarManager.daysInYear(from: calendarManager.today))
///////            calendarManager.daysInYear(from: calendarManager.currentDate)
////            ///
////            //             calendarManager.startDateOfWeek(from: calendarManager.currentDate)
////
///////            calendarManager.startDateOfDaysInAYear()
////            SwipeableStack(calendarManager.days, jumpTo: calendarManager.currentDate) { date, pos in
////                let _  = print(date.formatted())
////                let _ = print(calendarManager.currentDate.formatted())
////                    ZStack {
////                            RoundedRectangle(cornerRadius: 25)
////                                .fill(.yellow)
////                                .ignoresSafeArea()
////                            Text(date.formatted())
////
////                            .onChange(of: calendarManager.currentDate) { newValue in
////                                calendarManager.daysInYear(from: newValue)
////                            }
////                }
////
////
////                    .onChange(of: date) { newValue in
////                        calendarManager.currentDate = newValue - 1
////
////                        if calendarManager.isSelected(date) {
////                            if pos == .nextView {
////                                currentWeekIndex += 1
////                            } else if pos == .previousView {
////                                currentWeekIndex -= 1
////                            }
////                        }
////                    }
////
//////                    .onChange(of: date) { newValue in
//////                        if pos == .centerView {
//////                            let position = calendarManager.currentPositionInYear()
//////                            let dateInYear = calendarManager.datesInAYear(from: newValue)
//////                            let day = dateInYear[position]
//////                            calendarManager.currentDate = day
//////                        }
//////                    }
////
//////                    .onChange(of: date) { newValue in
//////                        if pos == .centerView {
////////                            let position = calendarManager.currentPositionInWeek()
////////                            let dtWeek = calendarManager.datesInAWeek(from: newValue)
//////                            let days = calendarManager.daysInYear(from: newValue)
//////                            calendarManager.currentDate = days[position]
//////                        }
//////
//////                    }
////
////            }
////        }
////    }
////                     }
////
////    private var headerView: some View {
////        HStack {
////            Text(calendarManager.currentDate.monthYYYY())
////                .font(.title)
////                .fontWeight(.bold)
////        }
////    }
////}
////struct PlannerView_Previews: PreviewProvider {
////    static var previews: some View {
////        PlannerView()
////    }
////}
////
////struct PlanBView: View {
////
////    @ObservedObject var calendarManager = CalendarManager.instance
////
////    var viewPosition: ViewPosition = .centerView
////    @State private var currentWeekIndex: Int = 0
////    //    @State var selectedDate: Date = Date()
////
////
////    @State private var swipeDirection: SwipeDirection?
////
////
////    @ObservedObject var taskWeekVM = TaskWeekVM.instance
////
////    @GestureState private var translation: CGFloat = 0
////    @State private var offset: CGFloat = 0
////
//
////    var body: some View {
////        GeometryReader { geo in
////            VStack(alignment: .leading, spacing: 0) {
////                headerView
////                //                .padding(.horizontal)
////                    .padding(10)
////                WeekView(geo: geo)
////                    .frame(maxHeight: 80)
////
////                HStack {
////                    RoutineView(date: calendarManager.currentDate)
////
////                }
////                .gesture(
////                    DragGesture()
////                        .updating($translation) { value, state, _ in
////                            state = value.translation.width
////                        }
////                        .onEnded { value in
////                            let threshold: CGFloat = UIScreen.main.bounds.width / 2
////                            if value.translation.width > threshold {
////                                // Swipe right (previous week)
////                                withAnimation {
////                                    calendarManager.currentDate = taskWeekVM.previousDay(date: calendarManager.currentDate)
////                                    //                                offset -= UIScreen.main.bounds.width
////                                }
////                            } else if value.translation.width < -threshold {
////                                // Swipe left (next week)
////                                withAnimation {
////                                    calendarManager.currentDate = taskWeekVM.nextDay(date: calendarManager.currentDate)
////                                    //                                taskWeekVM.nextWeek()
////                                    //                                offset += UIScreen.main.bounds.width
////                                }
////                            }
////                        }
////                )
////            }
////        }
////    }
////
//////
//////    var body: some View {
//////        VStack(alignment: .leading, spacing: 0) {
//////            headerView
//////            //                .padding(.horizontal)
//////                .padding(10)
//////            WeekView(currentWeekIndex: $currentWeekIndex)
//////                .frame(maxHeight: 80)
//////
//////
//////            let monday = calendarManager.startDateOfWeek(from: calendarManager.currentDate)
//////            SwipeableStack(calendarManager.startDateOfDaysInAYear(), jumpTo: monday) { value, pos in
//////
//////
//////                RoutineView(date: value)
//////
//////                    .onChange(of: value) { newValue in
//////                        calendarManager.currentDate = value
//////                    }
//////
//////
//////            }
//////        }
//////    }
////
////    private var headerView: some View {
////        HStack {
////            Text(calendarManager.currentDate.monthYYYY())
////                .font(.title)
////                .fontWeight(.bold)
////        }
////    }
////}
////
///
import SwiftUI

enum SwipeDirection {
    case backward, forward
}

//struct RoutineView: View {
//
//    let calendarStore = CalendarViewStore.instance
//    @ObservedObject var calendarVM = CalendarViewModel.instance
//
//    @Binding var date: Date
//
//    @State private var swipeDirection: SwipeDirection?
//
//    @GestureState private var translation: CGFloat = 0
//    @State private var offset: CGFloat = 0
//
//
//    let forward: () -> Void
//    let backward: () -> Void
//
//    var body: some View {
//        ZStack {
//            ForEach(0..<5) { _ in
//                RoundedRectangle(cornerRadius: 25)
//                    .fill(.yellow)
//                    .ignoresSafeArea()
//                Text(date.formatted())
//            }
//        }
//            .gesture(
//                DragGesture(minimumDistance: 3.0,
//                            coordinateSpace: .local)
//                .onEnded({ value in
//
//                    switch (value.translation.width, value.translation.height) {
//
//                    case (...0, -200...200):
//                        print("left swipe")
//                        self.swipeDirection = .forward
//                        withAnimation {
//                            forward()
//                        }
//
//
//                    case (0..., -200...200):
//                        print("right swipe")
//                        self.swipeDirection = .backward
//                        withAnimation {
//                            backward()
//                        }
//                    default: print("no clue")
//                    }
//                }))
//            .transition(.asymmetric(
//                insertion: swipeDirection == .forward ? .move(edge: .trailing) : .move(edge: .leading),
//                removal: swipeDirection == .forward ? .move(edge: .leading) : .move(edge: .trailing)))
//    }
//
//
//}

//
////var body: some View {
////    let datesInAYear = calendarManager.datesInAYear(from: date)
////
////    HStack(spacing: 0) {
////        ForEach(0..<1, id: \.self) { index in
////            let date = datesInAYear[index]
////
////            ZStack {
////                    RoundedRectangle(cornerRadius: 25)
////                        .fill(.yellow)
////                        .ignoresSafeArea()
////                    Text(date.formatted())
////            }
////
////        }
////
////    }
////}


struct RoutineView: View {

    let calendarStore = CalendarViewStore.instance
    @ObservedObject var calendarVM = CalendarManager.instance

    @Binding var date: Date
    
    @State private var swipeDirection: SwipeDirection?

    @GestureState private var translation: CGFloat = 0
    @State private var offset: CGFloat = 0

    let forward: () -> Void
    let backward: () -> Void

    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(0..<10) { _ in
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.yellow)
                            .ignoresSafeArea()
                        Text(date.formatted())
                    }
                    .frame(width: geometry.size.width)
                }
            }
            
            .offset(x: self.offset) // Offset the view horizontally
            .gesture(
                DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                    .updating($translation) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        let swipeThreshold = geometry.size.width * 0.4 // Adjust the threshold as needed
                        if value.translation.width > swipeThreshold {
                            self.swipeDirection = .backward
                            withAnimation {
                                self.offset = geometry.size.width
                            }
                            self.backward()
                        } else if value.translation.width < -swipeThreshold {
                            self.swipeDirection = .forward
                            withAnimation {
                                self.offset = -geometry.size.width
                            }
                            self.forward()
                        } else {
                            self.swipeDirection = nil
                            withAnimation {
                                self.offset = 0
                            }
                        }
                    }
            )
        }
    }
}
