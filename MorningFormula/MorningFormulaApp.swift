//
//  MorningFormulaApp.swift
//  MorningFormula
//
//  Created by Spencer Belton on 7/2/23.
//

import SwiftUI


@main
struct MorningFormulaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var userManager = UserManager.instance
    @StateObject var userDefaultsManager = UserDefaultsManager.instance
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
                .environmentObject(userDefaultsManager)
        }
    }
}
