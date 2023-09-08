//
//  Funk.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/5/23.
//

import SwiftUI

import SwiftUI

struct Funk: View {
    @State private var selectedDate: Date = Date()
    @State private var currentWeekIndex: Int = 0

    private var weekStartDate: Date {
        Calendar.current.date(byAdding: .weekOfYear, value: currentWeekIndex, to: selectedDate)!
    }

    private var weekDates: [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: weekStartDate))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    var body: some View {
        VStack {
            Text("Selected Date: \(selectedDate.formatted())")
                .padding()
            
            Weakness(weekDates: weekDates, selectedDate: $selectedDate, currentWeekIndex: $currentWeekIndex)
            
            Spacer()
        
        }
    }
}

struct Weakness: View {
    let weekDates: [Date]
    @Binding var selectedDate: Date
    @Binding var currentWeekIndex: Int

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    currentWeekIndex -= 1
                }) {
                    Image(systemName: "arrow.left")
                }
                Spacer()
                Text(weekStartDate.formatted(.short, timeZone: .current))
                Spacer()
                Button(action: {
                    currentWeekIndex += 1
                }) {
                    Image(systemName: "arrow.right")
                }
            }
            .padding()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(weekDates, id: \.self) { date in
                        Dayness(date: date, selectedDate: $selectedDate)
                            .frame(width: 80, height: 80)
                            .background(selectedDate.isSameDay(as: date) ? Color.blue : Color.clear)
                            .cornerRadius(40)
                    }
                }
                .padding()
            }
        }
    }

    private var weekStartDate: Date {
        weekDates.first ?? Date()
    }
}

struct Dayness: View {
    let date: Date
    @Binding var selectedDate: Date

    var body: some View {
        Text(date.formatted(.short))
            .font(.title)
            .foregroundColor(selectedDate.isSameDay(as: date) ? Color.white : Color.primary)
            .onTapGesture {
                selectedDate = date
            }
    }
}

extension Date {
    func formatted(_ format: DateFormatter.Style = .medium, timeZone: TimeZone? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = format
        if let timeZone = timeZone {
            dateFormatter.timeZone = timeZone
        }
        return dateFormatter.string(from: self)
    }

    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
}
struct Funk_Previews: PreviewProvider {
    static var previews: some View {
        Funk()
    }
}
