//
//  UserManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/30/23.
//

import SwiftUI

class UserManager: ObservableObject {
    static let instance = UserManager()
    
    @Published var signedIn = UserDefaults.standard.bool(forKey: K.UserDefaults.signedIn.rawValue)
    @Published var finishedOnboarding = UserDefaults.standard.bool(forKey: K.UserDefaults.finishedOnboarding.rawValue)
    @Published var userID = UserDefaults.standard.string(forKey: K.UserDefaults.userID.rawValue)
    @Published var userName = "Spencer"
    
    @ObservedObject var errorManager = ErrorManager.instance
    
        func userSignedUp(_ id: String) {
            self.setSignedInStatus(true)
            self.setOnboardingStatus(false)
            self.setUserID(id)
        }
    
        func userSignedIn(_ id: String, _ finishedOnboarding: Bool) {
            self.setSignedInStatus(true)
            self.setOnboardingStatus(finishedOnboarding)
            self.setUserID(id)
        }
    
        func signUserOut() {
            self.setSignedInStatus(false)
            self.setOnboardingStatus(false)
            self.setUserID(nil)
        }
    
    func userFinishedOnboarding() {
        if let userID = userID {
            
            FirebaseManager.instance.updateFirestoreUser(userID: userID, finishedOnboarding: true) { error in
                if let error = error {
                    print(error.localizedDescription)
                    self.errorManager.setError(error.localizedDescription)
                }
            }
                        self.setOnboardingStatus(true)
        }
    }
    
    
    func setSignedInStatus(_ status: Bool) {
        DispatchQueue.main.async {
            
            self.signedIn = status
            UserDefaults.standard.set(status, forKey: K.UserDefaults.signedIn.rawValue)
        }
    }
    
    func setOnboardingStatus(_ status: Bool) {
        DispatchQueue.main.async {
            self.finishedOnboarding = status
            UserDefaults.standard.set(status, forKey: K.UserDefaults.finishedOnboarding.rawValue)
        }
    }
    
    func setUserID(_ id: String?) {
        DispatchQueue.main.async {
            self.userID = id
            UserDefaults.standard.set(id, forKey: K.UserDefaults.userID.rawValue)
        }
    }
}
