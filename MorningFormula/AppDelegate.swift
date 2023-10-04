//
//  AppDelegate.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/29/23.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
    @ObservedObject var userDefaultsManager = UserDefaultsManager.instance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        userDefaultsManager.checkIfUserIsSignedIn()
        userDefaultsManager.checkOnboardingStatus()

        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.synchronize()
    }
}
