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
    
    
    func checkIfUserIsSignedIn() {
        let status = UserDefaults.standard.bool(forKey: K.UserDefaults.signedIn.rawValue)
        userManager.setSignedInStatus(status)
    }
    
    func checkOnboardingStatus() {
        let status = UserDefaults.standard.bool(forKey: K.UserDefaults.finishedOnboarding.rawValue)
        userManager.setOnboardingStatus(status)
    }
    
//    func checkIfIsGuest() {
//        if let data = UserDefaults.standard.data(forKey: K.UserDefaults.isGuest) {
//
//            do {
//                let decoder = JSONDecoder()
//                let isGuest = try decoder.decode(Bool.self, from: data)
//                userStore.isGuest = isGuest
//            } catch {
//                print("Unable to Decode Note (\(error)")
//            }
//        }
//    }
    
}
