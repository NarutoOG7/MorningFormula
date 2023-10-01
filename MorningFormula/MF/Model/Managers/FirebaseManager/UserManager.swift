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
    @Published var isGuest = UserDefaults.standard.bool(forKey: K.UserDefaults.isGuest.rawValue)
    @Published var userID = UserDefaults.standard.string(forKey: K.UserDefaults.userID.rawValue)
    @Published var hasFinishedOnboarding = UserDefaults.standard.string(forKey: K.UserDefaults.finishedOnboarding.rawValue)

    
    
    
    @ObservedObject var errorManager = ErrorManager.instance
    
    func hasUserFinishedOnboarding(withCompletion completion: @escaping(Bool) -> Void) {
        FirebaseManager.instance.getFirestoreUserData(userID: self.userID ?? "") { finishedOnboarding, error in
                    if let error = error {
                        print(error.localizedDescription)
                        self.errorManager.setError(error.localizedDescription)
                        completion(false)
                    }
                    if let _ = finishedOnboarding {
//                        self.userHasFinishedOnboarding = finishedOnboarding
                        completion(true)
                    }
                }
    }

    func userSignedIn(_ id: String) {
        UserDefaults.standard.set(true, forKey: K.UserDefaults.signedIn.rawValue)
        UserDefaults.standard.set(false, forKey: K.UserDefaults.isGuest.rawValue)
        UserDefaults.standard.set(id, forKey: K.UserDefaults.userID.rawValue)

        signedIn = true
        isGuest = false
        userID = id

    }
    
    func signUserOut() {
        UserDefaults.standard.set(false, forKey: K.UserDefaults.signedIn.rawValue)
        UserDefaults.standard.set(false, forKey: K.UserDefaults.isGuest.rawValue)
        UserDefaults.standard.set(nil, forKey: K.UserDefaults.userID.rawValue)
        UserDefaults.standard.set(false, forKey: K.UserDefaults.finishedOnboarding.rawValue)
        /// Interesting. I need to track this so that if a user signsout after onboarding, that they don't have to onboard again when they sign in.
        /// Create firestoreUser, track if finishedOnboarding.
        /// Update when finishedOnboarding, remove UD reference to finished onboarding and only track the firebase one.
        
        /// Get finishedOnboarding from firebase only when user signs in after being signed out.
        /// Then we can use usesrDefaults to track the finishedOnboarding for seamless view switching/updating
        /// When user signs out and then someone signs in or up, it will begin onboarding process if necessary.
        /// on sign in, upon completing signIn, it will call the getFinishedOnboarding from firestore. that will update the usermanager as well as the user defaults. View should update accordingly.
        /// Then i should save teh progress of the onboarding process incase the user quits midway.
        

        signedIn = false
        isGuest = false
        userID = nil

    }
    
    func finishedOnboarding() {
        if let userID = userID {
            FirebaseManager.instance.updateFirestoreUser(userID: userID, finishedOnboarding: true) { error in
                if let error = error {
                    print(error.localizedDescription)
                    self.errorManager.setError(error.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                self.hasFinishedOnboarding = true
            }
        }
    }
    
}
