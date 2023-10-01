//
//  AppDelegate.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/29/23.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let userDefaultsManager = UserDefaultsManager.instance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        userDefaultsManager.getUserIDIfSignedIn()
        userDefaultsManager.checkIfIsGuest()
        return true
    }
}
