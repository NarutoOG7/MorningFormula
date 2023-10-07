//
//  FormulaBuilderView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/27/23.
//

import SwiftUI

struct FormulaBuilderView: View {
    
    @State var selectedNarrator = ""
    @State var virtueStrings: [String] = []
    @State var showsSpotify = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                narratorView
                virtuesView
                SpotifyView()
            }
        }
//        .sheet(isPresented: $showsSpotify) {
//            SpotifyView()
//        }
    }
    
    func doneTapped() {
        /// Move everything to a VM... save Formula model to Firebase
        convertStringsToVirtues()
    }
    

}

struct FormulaBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        FormulaBuilderView()
            .padding()
    }
}

//MARK: -  Narrator View
extension FormulaBuilderView {
    
    private var narratorView: some View {
        VStack(alignment: .leading) {
            Text("Who would you like to narrate your Morning Formula?")
                .font(.headline)
                .foregroundColor(.gray)
            narratorsList

        }
    }
    
    private var narratorsList: some View {
        Picker("", selection: $selectedNarrator) {
            ForEach(Voice.examples) { voice in
                Text(voice.name)
                
            }
        }
    }
}

//MARK: - Virtues
extension FormulaBuilderView {
    
    var virtuesView: some View {
        InputGroupView(inputGroup: .virtues, submissions: $virtueStrings)
    }
    
    func convertStringsToVirtues() {

        var virtuesReturnable: [Virtue] = []
        for string in virtueStrings {
            let virtue = Virtue(text: string)
            let virtuesDoesntContainNewVirtue = !virtuesReturnable.contains(where: { $0.text == string })
            if virtuesDoesntContainNewVirtue {
                virtuesReturnable.append(virtue)
            }
        }
        // Save virtues to formula...
        // Save formula to firebase
    }
}

