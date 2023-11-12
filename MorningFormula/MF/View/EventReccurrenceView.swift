//
//  EventReccurrenceView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/6/23.
//

import SwiftUI

enum EventRecurrenceOption: String, CaseIterable, Identifiable {
    case never = "Never"
    case daily = "Every Day"
    case weekly = "Every Week"
    case biWeekly = "Every 2 Weeks"
    case monthly = "Every Month"
    case yearly = "Every Year"
    
    var id: Self { self }

}

struct EventReccurrenceView: View {
    var body: some View {
        list
    }
    
    var list: some View {
            List {
                
                ForEach(EventRecurrenceOption.allCases) { reccurence in
                    Text(reccurence.rawValue)
                }
                
                Section {
                    NavigationLink {
                        CustomReccurenceView()
                    } label: {
                        Text("Custom")
                    }
                }
            }
        }
    
}

enum EventInterval: String, CaseIterable, Identifiable {
    case daily
    case weekly
    case monthly
    case yearly
    
    var frequency: [Int] {
        switch self {
        case .daily:
            return Array(1...31)
        case .weekly:
            return Array(1...52)
        case .monthly:
            return Array(1...12)
        case .yearly:
            return Array(1...100)
        }
    }
    
    var id: Self { self }

}


struct CustomReccurenceView: View {
    
    @State var interval: EventInterval = .daily
    @State var frequency: Int = 1
    
    var body: some View {
        List {
            intervalPicker
            frequencyPicker
        }
    }
    
    private var intervalPicker: some View {
        Picker("Interval:", selection: $interval) {
            ForEach(Array(EventInterval.allCases), id: \.id) { interval in
                Text(interval.rawValue.capitalized)
            }
        }
        .id("Interval")
    }
    
    private var frequencyPicker: some View {
        Picker("Frequency:", selection: $frequency) {
            ForEach(interval.frequency, id: \.self) { freq in
                Text("\(freq)")
            }
        }
        .id("Frequency")
    }
}

#Preview {
    EventReccurrenceView()
}
