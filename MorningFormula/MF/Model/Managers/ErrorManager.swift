//
//  ErrorManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/30/23.
//

import SwiftUI

class ErrorManager: ObservableObject {
    static let instance = ErrorManager()
    
    @Published var errorMessage = ""
    @Published var shouldShowMessage = false
    
    func setError(_ error: String) {
        self.errorMessage = error
        self.shouldShowMessage = true
    }
}
