//
//  FMTasks.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/6/23.
//

import Foundation

extension FirebaseManager {
    
    
    func saveTaskTapped(_ task: MFTask) {
        print(task.starTime.formatted(date: .abbreviated, time: .shortened))
        print(task.endTime.formatted(date: .abbreviated, time: .shortened))

        self.addTask(task) { status , error in
            if let error = error {
                self.errorManager.setError(error.localizedDescription)
            }
        }
    }
    
    func addTask(_ task: MFTask, wasSuccessful success: @escaping(Bool, Error?) -> Void) {
        guard let db = db else { return }
        
        do {
        try db.collection("Tasks").addDocument(from: CodableTask(from: task))
//            let data = try JSONEncoder().encode(CodableTask(from: task))
//            try newDocRef.setData(from: data)
            success(true, nil)
        } catch {
            success(false, error)
        }
                
//        db.collection("Tasks").document(task.id).setData([
//            "userID" : userManager.userID,
//            "color" : task.chosenColor,
//            
//            "formulaURL" : formula.formulaURL?.absoluteString ?? ""
//        ]) { error in
//            
//            if let error = error {
//                print(error.localizedDescription)
//                status(false, error)
//            } else {
//                status(true, nil)
//            }
//        }
    }
    
    func updateTask(_ task: CodableTask) {
        guard let db = db else {
//            status(false, NSError(domain: "Firebase Manager: Error Updating Formula", code: 1))
            return
        }
        let docRef = db.collection("Tasks").document(task.id)
            do {
                let data = try JSONEncoder().encode(task)
                try docRef.setData(from: data)
//                status(true, nil)
            } catch {
                print(error)
//                status(/*false*/, error)
            }
    }
    
    func getTask(_ id: String, withCompletion completion: @escaping(MFTask?, Error?) -> Void) {
        if userManager.signedIn {
            
            guard let db = db else { return }
            
            let query = db.collection("Tasks")
                .whereField("id", isEqualTo: id)
            
            query.getDocuments { snapshot, error in
                if let snapshot = snapshot {
                    for doc in snapshot.documents {
                        let dict = doc.data()
                        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                            do {
                                let codableTask = try JSONDecoder().decode(CodableTask.self, from: jsonData)
                                let mfTask = MFTask(from: codableTask)
                                completion(mfTask, nil)
                            } catch {
                                // Handle decoding errors
                                print("Error decoding: \(error)")
                                completion(nil, error)
                            }
                        } else {
                            // Handle the case where JSONSerialization couldn't convert the dictionary to data
                            print("Error serializing the dictionary")
                        }
                    }
                }
            }
        }
    }
    
    func deleteTask(_ taskID: String, wasSuccessful success: @escaping(Bool, Error?) -> Void) {
        
        guard let db = db else { return }
        
        db.collection("Tasks").document(taskID)
            .delete() { err in
                
                if let err = err {
                    success(false, err)
                } else {
                    print("Review successfully removed!")
                    success(true, nil)
                }
            }
    }
    
}
