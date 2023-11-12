//
//  CalendarView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/10/23.
//

import SwiftUI
import SwiftUIPager

struct CalendarView: View {
        
    @ObservedObject var vm = CM.instance
        let OnDayChanged: (Date)->Any
        
        @State private var selectedDay = Date()
        @State private var currentPage = Page.withIndex(2)
        @State private var data = Array(-2..<3)
        @State private var disableButtons = false
        
        var body: some View {
            VStack(spacing: 0){
                VStack(alignment: .center, spacing: 0){
                    Pager(page: currentPage,
                          data: data,
                          id: \.self) {
                        self.generateWeekView($0)
                    }
                          .singlePagination(ratio: 0.5, sensitivity: .high)
                          .onPageWillChange({ (page) in
                              withAnimation {
                      //Moving forward or backward a week
                                  selectedDay = selectedDay + TimeInterval(604800) * Double((page - currentPage.index))
                              }
                              _ = OnDayChanged(selectedDay)
                          })
                          .onPageChanged({
                              page in
                                                      //Adding new weeks when we approach the boundaries of the array
                              if page == 1 {
                                  let newData = (1...5).map { data.first! - $0 }.reversed()
                                  withAnimation {
                                      currentPage.update(.move(increment: newData.count))
                                      data.insert(contentsOf: newData, at: 0)
                                  }
                              } else if page == self.data.count - 2 {
                                  guard let last = self.data.last else { return }
                                  let newData = (1...5).map { last + $0 }
                                  withAnimation {
                                      data.append(contentsOf: newData)
                                  }
                              }
                              disableButtons = false
                          })
                          .onDraggingBegan({
                              disableButtons = true
                          })
                          .pagingPriority(.simultaneous)
                          .frame(height: 48)
                    Capsule()
                        .frame(width: 32, height: 6)
                        .foregroundColor(Color("TransparetPurple"))
                        .padding(4)
                }
                .frame(maxWidth: .infinity)
                .background(Color("AccentBlue"))
                //Spacer()
            }
        }

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
