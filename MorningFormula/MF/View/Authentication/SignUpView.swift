//
//  SignUp.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/29/23.
//

import SwiftUI

struct SignUpView: View {
    
    @State var emailInput = ""
    @State var passwordInput = ""
    @State var confirmPasswordInput = ""
    
    let auth = FirebaseManager.instance
    
    var body: some View {
        VStack(spacing: 30) {
            Circle()
                .frame(width: 200)
                .padding(.vertical, 50)
            emailField
            passwordField
            confirmPasswordField
            Spacer()
                signUpButton
            
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
    
    var confirmPasswordField: some View {
        TextField("Confirm Password", text: $confirmPasswordInput)
            .background(UnderlineTextFieldBackground())
    }
    
    var signUpButton: some View {
        Button(action: self.signUpTapped) {
            Text("Sign Up")
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
    

    
    private func signUpTapped() {
        auth.signUpTapped(email: emailInput,
                          password: passwordInput,
                          confirmPassword: confirmPasswordInput)
    }
    

    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
//            RuleOfThirds()
//                .edgesIgnoringSafeArea(.all)
            SignUpView()
                .padding()
        }
    }
}

struct UnderlineTextFieldBackground: View {
    var body: some View {
            Rectangle()
                .frame(height: 0.5)
                .padding(.top, 30)

    }
}
