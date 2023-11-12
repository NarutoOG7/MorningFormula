//
//  CodableTask.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/8/23.
//

import SwiftUI

struct CodableTask: Codable {
    var id: String
    var userId: String
    var notes: String
    var isComplete: Bool
    var color: CodableColor
    
    init(from mfTask: MFTask) {
        self.id = mfTask.id
        self.userId = UserManager.instance.userID ?? ""
        self.notes = mfTask.description
        self.isComplete = mfTask.isComplete
        self.color = CodableColor(UIColor(mfTask.chosenColor))
    }

}
