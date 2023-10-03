//
//  FMAuthentication.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/29/23.
//

import Foundation
import Firebase

extension FirebaseManager {
    
    func signUpTapped(email: String, password: String, confirmPassword: String) {
        if confirmPassword == password {
            signUp(email: email, password: password) { success, id, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.errorManager.setError(error.localizedDescription)
                }
                if success == true {
                    
                    self.userManager.userSignedUp(id ?? UUID().uuidString)
                }
            }
        }
    }

    func signUp(email: String, password: String, withCompletion completion: @escaping(Bool, String?, Error?) -> Void) {
        self.auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, nil, error)
            }
            if let result = result {
                self.userAuthData = result
                completion(true, result.user.uid, nil)
            }
        }
    }
    
    
    func signIn(email: String, password: String, withCompletion completion: @escaping(Bool, String?, Error?) -> Void) {
        self.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, nil, error)
            }
            if let result = result {
                    completion(true, result.user.uid, nil)
            }
        }
    }
    
    func logInTapped(email: String, password: String) {
        let group = DispatchGroup()
        
        var onboardingComplete = false
        var userID = ""
        group.enter()
        self.signIn(email: email, password: password) { success, id, error in
            if let error = error {
                self.errorManager.setError(error.localizedDescription)
            }
            if success {
                if let id = id {
                    group.enter()
                    self.getFirestoreUserData(userID: id) { finishedOnboarding, error in
                        onboardingComplete = finishedOnboarding
                        userID = id
                        group.leave()
                    }
                }
            }
            group.leave()
        }
        group.notify(queue: .main) {
            self.userManager.userSignedIn(userID, onboardingComplete)
        }
    }
    
    func logOut(withCompletion completion: @escaping(Error?) -> Void) {
            do {
                try auth.signOut()
                self.userManager.signUserOut()
                completion(nil)
            } catch {
                print("Trouble siging out. \(error)")
                completion(error)
            }
    }
    
    func logOutTapped() {
        self.logOut { error in
            if let error = error {
                print(error.localizedDescription)
                self.errorManager.setError(error.localizedDescription)
            }
        }
    }
    
    func addUserToFirestore(_ user: AuthDataResult, withcCompletion completion: @escaping(Error?) -> Void) {
        
        guard let db = db else { return }
        let user = user.user
        let documentID = user.uid
        
        db.collection("Users").document(documentID).setData([
            "id" : user.uid,
            "email" : user.email ?? "",
            "finishedOnboarding" : false
        ]) { error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func updateFirestoreUser(userID: String, finishedOnboarding: Bool, withCompletion completion: @escaping(Error?) -> Void) {
        guard let db = db else { return }
        db.collection("Users").document(userID)
            .updateData([
                "finishedOnboarding" : finishedOnboarding
            ], completion: { err in
                if let err = err {
                    completion(err)
                } else {
                    completion(nil)
                }
            })
    }
    
    func getFirestoreUserData(userID: String, withCompletion completion: @escaping(_ finishedOnboarding: Bool , Error?) -> Void) {
        guard let db = db else {  return }
        print(userID)
        db.collection("Users")
            .whereField("id", isEqualTo: userID)
            .getDocuments
        { snapshot, error in
            guard let snapshot = snapshot,
                  let doc = snapshot.documents.first else { completion(false, error)
                return
            }
            let firestoreData = doc.data()["finishedOnboarding"] as? Bool ?? false
            print(firestoreData)
            completion(firestoreData, nil)
        }
    }
}
