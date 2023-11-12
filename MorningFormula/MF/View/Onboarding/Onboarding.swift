//
//  Onboarding.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/21/23.
//

import SwiftUI

struct Onboarding: View {
    var body: some View {
        NavigationStack {
            ProfileOnboardingView()
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
