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
    
    @State var currentPage = 1

    var body: some View {
            VStack(alignment: .leading) {
                capsule
                
                switch currentPage {
                case 1:
                     formulaPageOne
                case 2:
                     formulaPageTwo
                default:
                     formulaPageThree
                }
                    Spacer()
                
                HStack {
                    if currentPage != 1 {
                        previousButton
                    }
                    Spacer()
                    if currentPage != 3 {
                        nextButton
                    }
                }
            }
        
    }
    
    var capsule: some View {
        CapsuleProgressView(
            progress: currentPage,
            pageCount: formulaManager.formulaPageCount)
        .frame(height: 40)
        
    }
    
    var formulaPageOne: some View {
        VStack(alignment: .leading) {
            narratorView
            virtuesView
            rulesView
        }
    }
    
    var formulaPageTwo: some View {
        SpotifyView()
    }
    
    var formulaPageThree: some View {
        FormulaImagesView()
    }
    
    func doneTapped() {
        /// Move everything to a VM... save Formula model to Firebase
        convertStringsToVirtues()
    }
    
    var nextButton: some View {
        HStack {
            Spacer()
            Button {
                currentPage += 1
            } label: {
                Text("Next")
            }
        }
    }
    
    var previousButton: some View {
        Button {
            currentPage -= 1
        } label: {
            Text("Previous")
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

