//
//  FirebaseUser.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/29/23.
//

import Foundation

struct FirebaseUser: Identifiable {
    
    var id = UUID().uuidString
    var name: String
    var wakeTime: Date
    var sleepTime: Date
    var gender: String
    var formula: Formula
    
}


