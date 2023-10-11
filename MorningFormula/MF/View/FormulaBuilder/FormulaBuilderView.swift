//
//  FormulaBuilderView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/27/23.
//

import SwiftUI

class FormulaManager: ObservableObject {
    static let instance = FormulaManager()
    
    @Published var selectedNarrator = ""
    @Published var virtueStrings: [String] = []
    @Published var showsSpotify = true
    @Published var favoriteSongTitles: [String] = []
    
    @Published var rulesAsStrings: [String] = []
    @Published var rules: [Rule] = [] {
        didSet {
            let newRules = rules.map({ $0.text })
            rulesAsStrings = newRules
        }
    }
    @Published var images: [UIImage] = []
    
    let formulaPageCount = 3
    
}


struct FormulaBuilderView: View {
    
    @ObservedObject var formulaManager = FormulaManager.instance

    @State private var ruleInput = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                CapsuleProgressView(
                    progress: 1,
                    pageCount: formulaManager.formulaPageCount)
                narratorView
                virtuesView
                rulesView
                Spacer(minLength: 100)
                nextButton

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
    
    var nextButton: some View {
        HStack {
            Spacer()
            NavigationLink {
                SpotifyView()
                    .padding()
            } label: {
                Text("Next")
            }
        }
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
        Picker("", selection: $formulaManager.selectedNarrator) {
            ForEach(Voice.examples) { voice in
                Text(voice.name)
                
            }
        }
    }
}

//MARK: - Virtues
extension FormulaBuilderView {
    
    var virtuesView: some View {
        InputGroupView(inputGroup: .virtues, submissions: $formulaManager.virtueStrings)
    }
    
    func convertStringsToVirtues() {

        var virtuesReturnable: [Virtue] = []
        for string in formulaManager.virtueStrings {
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

//MARK: - Rules
extension FormulaBuilderView {
    
    var rulesView: some View {
        let rule = InputGroups.rules
        return AnyGroupInputView(title: rule.title,
                          subTitle: rule.subtitle,
                          textFieldPlaceholder: rule.placeholder,
                          onTextChange: { _ in return },
                          submissions: $formulaManager.rulesAsStrings,
                          autoFillOptions: .constant([]))
    }
}

