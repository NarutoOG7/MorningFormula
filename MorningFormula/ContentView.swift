//
//  ContentView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 7/2/23.
//

import SwiftUI
import PhotosUI


struct ContentView: View {
    
    @ObservedObject var vm = CalendarManager.instance
//    @ObservedObject var userManager = UserManager.instance
    @State var hasFinishedOnboarding = false
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
//    var body: some View {
//        FormulaBuilderView().padding()
//    }
    
    var body: some View {

        if userManager.signedIn {
            if userManager.finishedOnboarding {
                NavigationStack {
                    TabBarView()
                        .onAppear {
                            SpotifyManager.inestance.getAccessToken { token, error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                                if let token = token {
                                    print(token)
                                }
                            }
                        }
                }

            } else {
                NavigationStack {
                    ProfileOnboardingView()
                }
            }
        } else {
            AuthenticationView()
        }
    }
    


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
