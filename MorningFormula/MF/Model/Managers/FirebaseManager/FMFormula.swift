//
//  FMVoices.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/11/23.
//

import SwiftUI

extension FirebaseManager {
    
    func saveFormulaTapped(_ formula: Formula) {
        self.addFormula(formula) { status , error in
            if let error = error {
                self.errorManager.setError(error.localizedDescription)
            }
        }
    }
    
    func addFormula(_ formula: Formula, wasSuccessful status: @escaping(Bool, Error?) -> Void) {
        guard let db = db else { 
            status(false, NSError(domain: "Firebase Manager: Error Updating Formula", code: 1))
            return
        }
        do {
            let newFormula = try db.collection("Formulas").addDocument(from: formula)
            print("Formula stored with new document reference: \(newFormula)")
            status(true, nil)
        }
        catch {
            print(error)
            status(false, error)
        }
    }
    
    func updateFormula(_ formula: Formula) {
        guard let db = db else {
//            status(false, NSError(domain: "Firebase Manager: Error Updating Formula", code: 1))
            return
        }
        let docRef = db.collection("Formulas").document(formula.id)
            do {
                let data = try JSONEncoder().encode(formula)
                try docRef.setData(from: formula)
//                status(true, nil)
            } catch {
                print(error)
//                status(/*false*/, error)
            }
        }
}
