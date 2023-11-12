//
//  FirebaseManager.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/29/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift


class FirebaseManager {
    
    static let instance = FirebaseManager()
    
    var db: Firestore?
    let auth = Auth.auth()
    
    @ObservedObject var errorManager = ErrorManager.instance
    @ObservedObject var userManager = UserManager.instance
    
    var userAuthData: AuthDataResult? {
        didSet {
            guard let data = userAuthData else { return }
            self.addUserToFirestore(data) { error in
                if let error  = error {
                    self.errorManager.setError(error.localizedDescription)
                }
            }
        }
    }
    
    init() {
        db = Firestore.firestore()
    }
    
}

