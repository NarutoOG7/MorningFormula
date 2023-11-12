//
//  GenderOptionView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 7/4/23.
//

import SwiftUI

struct GenderChoiceView: View {
    @ObservedObject var profileOnboardingVM = ProfileOnboardingVM.instance
    
    var body: some View {
        VStack(alignment: .leading) {
            title
            HStack {
                maleOption
                femaleOption
            }
        }
    }
    
    private var title: some View {
        Text("What gender are you?")
            .font(.headline)
            .foregroundColor(.gray)
    }
    
    private var maleOption: some View {
        Button(action: {
            self.profileOnboardingVM.genderIsMale = true
            self.profileOnboardingVM.genderIsFemale = false        }) {
            Text("🙋‍♂️ Male")
                .frame(width: 100)
        }
        .buttonStyle(RoundedButtonStyle(isSelected: $profileOnboardingVM.genderIsMale))
    }
    
    private var femaleOption: some View {
        Button(action: {
            self.profileOnboardingVM.genderIsMale = false
            self.profileOnboardingVM.genderIsFemale = true
        }) {
            Text("🙋‍♀️ Female")
                .frame(width: 100)
        }
        .buttonStyle(RoundedButtonStyle(isSelected: $profileOnboardingVM.genderIsFemale))
    }
}


struct GenderOptionView_Previews: PreviewProvider {
    static var previews: some View {
        GenderChoiceView()
    }
}
