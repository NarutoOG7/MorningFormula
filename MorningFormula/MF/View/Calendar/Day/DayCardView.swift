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
    
    @State var days: [Date] = []

    init(_ geo: GeometryProxy) {
        self.geo = geo
        let dayAfter = calendar.date(byAdding: .day, value: 1, to: vm.selectedDate) ?? Date()
        
        days.append(vm.selectedDate)
        days.append(dayAfter)
    }
    
    var body: some View {
        let height = geo.size.height * 0.75
        let dayBefore = calendar.date(byAdding: .day, value: -1, to: vm.selectedDate) ?? Date()
        InfiniteCarousel(data: days, height: height, horizontalPadding: 0, transition: .opacity) { day in
//                DayView(day: $vm.selectedDate)
            Text(day.formatted())
                .frame(width: geo.size.width, height: height)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.orange)
                    )
//                    .frame(width: geo.size.width, height: geo.size.height * 0.75)
                    .onAppear {

                        days.insert(dayBefore, at: 0)
                    }
        }
        
    }
}

struct DayCardView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            DayCardView(geo)
        }
    }
}
