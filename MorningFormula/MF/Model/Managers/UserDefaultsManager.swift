//
//  UserDefaultsManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/30/23.
//

import SwiftUI

class UserDefaultsManager: ObservableObject {
    
    static let instance = UserDefaultsManager()
    
    @ObservedObject var userManager = UserManager.instance
    @ObservedObject var errorManager = ErrorManager.instance
    
}
