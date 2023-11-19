//
//  SettingsView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/30/23.
//

import SwiftUI

struct SettingsView: View {
    
    let auth = FirebaseManager.instance
    
    @ObservedObject var todayViewModel = TodayViewModel.instance
    
    var body: some View {
       
        List {
            dayDefinitionSwitch
            Section {
                logOutButton
            }
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
        auth.logOutTapped()
    }
    
    private var dayDefinitionSwitch: some View {
        Toggle(isOn: $todayViewModel.isDaySetByMidnight) {
            Text("Day Defined By Midnight?")
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
