//
//  CustomCalendar.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/2/23.
//

import SwiftUI

struct CustomCalendar: View {
    
    @State var selectedDate: Date = .now
    
    var body: some View {
        DatePicker("Date:", selection: $selectedDate)
            .datePickerStyle(.graphical)
            .padding()
    }
}

struct CustomCalendar_Previews: PreviewProvider {
    static var previews: some View {
        CustomCalendar()
    }
}
