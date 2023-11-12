//
//  DayCardView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/12/23.
//

import SwiftUI
import SwiftUIInfiniteCarousel

struct DayCardView: View {
    
    @ObservedObject var vm = CalendarManager.instance
    
    let geo: GeometryProxy
    let calendar = Calendar.current
    let calendarViewStore = CalendarViewStore.instance
    
    @State var days: [Date] = []

    @State var index = 0

    
    var body: some View {
        let height = geo.size.height * 0.75

        let dayAfter = calendar.date(byAdding: .day, value: 1, to: vm.selectedDate) ?? Date()
        let dayBefore = calendar.date(byAdding: .day, value: -1, to: vm.selectedDate) ?? Date()
        let _ = print(calendarViewStore.calendar.fsCalendar.minimumDate)
        let _ = print(calendarViewStore.calendar.fsCalendar.maximumDate)

        SwipeableStack(vm.wheelDates.sorted(by: { $0 < $1 }), dataIndex: $index, forward: vm.forward, backward: vm.backward) { day, pos in
            Text(day.formatted())
                .frame(width: geo.size.width - 40, height: height)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 45)
                            .fill(.orange)
                    )
        }
    }
    
//    var body: some View {
//        let height = geo.size.height * 0.75
//        let dayBefore = calendar.date(byAdding: .day, value: -1, to: vm.selectedDate) ?? Date()
//        InfiniteCarousel(data: days, height: height, horizontalPadding: 0, transition: .opacity) { day in
////                DayView(day: $vm.selectedDate)
//            Text(day.formatted())
//                .frame(width: geo.size.width, height: height)
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 15)
//                            .fill(.orange)
//                    )
////                    .frame(width: geo.size.width, height: geo.size.height * 0.75)
//                    .onAppear {
//
//                        days.insert(dayBefore, at: 0)
//                    }
//        }
//
//    }
}

struct DayCardView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            DayCardView(geo: geo)
        }
    }
}
