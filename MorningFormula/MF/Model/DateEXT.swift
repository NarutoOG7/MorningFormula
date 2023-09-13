//
//  DateEXT.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/12/23.
//

import SwiftUI


extension Date {
    func monthYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL YYYY"
        let nameOfMonth = dateFormatter.string(from: self)
        return nameOfMonth
    }
}
