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

struct GradientRoundedBackground: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(
                    LinearGradient(
                        colors: [.red, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
}

struct ProfileOnboardingView: View {
    @State private var nameInput = ""
    @State private var wakeTime = Date()
    @State private var sleepTime = Date()

    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {
                nameView
                genderChoice
                wakeTimeView
                sleepTimeView
                DescriptiveWordsInput()
                    .padding(.top, -35)
                Spacer()
                nextButton
            }
            .padding()
        }
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
    
    private var wakeTimeView: some View {
        VStack(alignment: .leading) {
            Text("What time do you wake up?")
                .font(.headline)
                .foregroundColor(.gray)
                DatePicker(selection: $wakeTime, displayedComponents: .hourAndMinute) {}
                    .frame(width: 80)
            
        }
    }
    
    private var sleepTimeView: some View {
        VStack(alignment: .leading) {
            Text("What time do you go to sleep?")
                .font(.headline)
                .foregroundColor(.gray)
            DatePicker(selection: $sleepTime, displayedComponents: .hourAndMinute) {}
                .frame(width: 80)

        }
    }
    
    
    private var genderChoice: some View {
        GenderChoiceView()
    }
    
    
    private var nextButton: some View {
        HStack {
            Spacer()
            
            NavigationLink {
                GoalsInput()
            } label: {
                Text("Next")
                    .padding(.horizontal)
                    .padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black)
                    )
            }
        }
    }
}


struct ProfileOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileOnboardingView()
    }
}

