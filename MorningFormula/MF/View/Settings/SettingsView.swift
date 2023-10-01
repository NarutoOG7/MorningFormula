//
//  SettingsView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/30/23.
//

import SwiftUI

struct SettingsView: View {
    
    let auth = FirebaseManager.instance
    
    var body: some View {
       
        List {
            logOutButton
        }
    }
    
   private var logOutButton: some View {
        Button(action: self.logOutTapped) {
            Text("Log Out")
                .font(.title)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(.red)
                    )
        }
        .padding(.bottom)
    }
    
    private func logOutTapped() {
        auth.logOut { error in
            if let error = error {
                ErrorManager.instance.setError(error.localizedDescription)
            }
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
