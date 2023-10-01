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
    

    
    func getUserIDIfSignedIn() {

        if let data = UserDefaults.standard.data(forKey: K.UserDefaults.userID.rawValue) {

            do {
                let decoder = JSONDecoder()

                let userID = try decoder.decode(String.self, from: data)

                userManager.userID = userID
            } catch {
                errorManager.setError("Error signing in")
            }
        }
    }
    
    func checkIfIsGuest() {
        if let data = UserDefaults.standard.data(forKey: K.UserDefaults.isGuest.rawValue) {

            do {
                let decoder = JSONDecoder()
                let isGuest = try decoder.decode(Bool.self, from: data)
                UserManager.instance.isGuest = isGuest
            } catch {
                errorManager.setError("Error signing in")
            }
        }
    }
}
