//
//  FirebaseManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/29/23.
//

import SwiftUI
import Firebase

class FirebaseManager {
    
    static let instance = FirebaseManager()
    
    var db: Firestore?
    let auth = Auth.auth()
    
    @ObservedObject var errorManager = ErrorManager.instance
    @ObservedObject var userManager = UserManager.instance
    
    init() {
        db = Firestore.firestore()
        
//        self.getFirestoreUserData(userID: userManager.userID ?? "") { finishedOnboarding, error in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        self.errorManager.setError(error.localizedDescription)
//                    }
//                    if let finishedOnboarding = finishedOnboarding {
//                        self.userManager.userHasFinishedOnboarding = finishedOnboarding
//                    }
//                }
            
    }
    
}

