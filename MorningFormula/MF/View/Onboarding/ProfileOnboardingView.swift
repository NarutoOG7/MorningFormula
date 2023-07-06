//
//  ProfileOnboardingView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 7/4/23.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    
    @Binding var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(configuration.isPressed || isSelected ?             LinearGradient(
                        colors: [.red, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :             LinearGradient(
                        colors: [.clear, .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                           .overlay(
                               RoundedRectangle(cornerRadius: 5.0)
                                   .stroke(
                                       LinearGradient(
                                           colors: [.red, .blue],
                                           startPoint: .leading,
                                           endPoint: .trailing
                                       ),
                                       lineWidth: 2
                                   )
                           )
            )
    }
}

struct RoundedTextStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(
                    LinearGradient(
                        colors: [.red, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 40)
            
            configuration
                .padding(.leading)
                .foregroundColor(.gray)
        }
    }
}

struct ProfileOnboardingView: View {
    @State private var nameInput = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            nameView
            genderChoice
            GoalsInput()
        }
        .padding()
    }
    
    private var nameView: some View {
        VStack(alignment: .leading) {
            Text("What is your name?")
                .font(.headline)
                .foregroundColor(.gray)
            TextField("Name", text: $nameInput)
                .textFieldStyle(RoundedTextStyle())
        }
    }
    
    private var genderChoice: some View {
        GenderChoiceView()
    }
}

struct ProfileOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileOnboardingView()
    }
}

