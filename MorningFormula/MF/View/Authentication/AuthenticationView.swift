//
//  AuthenticationView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/30/23.
//

import SwiftUI

struct AuthenticationView: View {
    
    @State var pageIndex = 0
    
    var body: some View {
        VStack {
            if pageIndex == 0 {
                SignUpView()
                    .padding(.horizontal)
                logInText
            }
            if pageIndex == 1 {
                LogInView()
                    .padding(.horizontal)
                signUpText
            }
        }
    }
    
    var logInButton: some View {
        Button {
            pageIndex = 1
        } label: {
            Text("Log In")
        }

    }
    
    
    var signUpButton: some View {
        Button {
            pageIndex = 0
        } label: {
            Text("Sign Up")
        }

    }
    
    var signUpText: some View {
        HStack {
            Text("Don't have an account?")
            signUpButton
        }
    }
    
    var logInText: some View {
        HStack {
            Text("Already have an account?")
            logInButton
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
