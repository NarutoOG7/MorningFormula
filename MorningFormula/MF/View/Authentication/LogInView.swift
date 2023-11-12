//
//  LogInView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/30/23.
//

import SwiftUI

struct LogInView: View {
    
    @State var emailInput = ""
    @State var passwordInput = ""
    
    let auth = FirebaseManager.instance
    
    var body: some View {
        VStack(spacing: 30) {
            Circle()
                .frame(width: 200)
                .padding(.vertical, 50)
            emailField
            passwordField
            Spacer()
                logInButton
            
        }
    }
    
    var emailField: some View {
        TextField("Email Address", text: $emailInput)
            .background(UnderlineTextFieldBackground())
    }
    
    var passwordField: some View {
        TextField("Password", text: $passwordInput)
            .background(UnderlineTextFieldBackground())
    }
    
    var logInButton: some View {
        Button(action: self.logInTapped) {
            Text("Log In")
                .font(.title)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(.orange)
                    )
        }
        .padding(.bottom)
    }
    

    
    private func logInTapped() {
        auth.logInTapped(email: emailInput, password: passwordInput)
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
