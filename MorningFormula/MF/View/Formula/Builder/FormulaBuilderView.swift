//
//  FormulaBuilderView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/27/23.
//

import SwiftUI

class FormulaManager: ObservableObject {
    static let instance = FormulaManager()
    
    @Published var descriptiveWords: [String] = []
    @Published var goals: [Goal] = []
    @Published var selectedNarrator = ""
    @Published var virtues: [String] = []
    @Published var quotes: [Quote] = []
    @Published var principles: [Principle] = []
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
    
    @Published var formula: Formula?
    
    let formulaPageCount = 3
    
    @ObservedObject var userStore = UserManager.instance
    @ObservedObject var chatManager = ChatManager.instance
    let videoManager = VideoManager.instance
    let firebaseManager = FirebaseManager.instance
    
    func formulaFromFields() -> Formula {
        Formula(userID: userStore.userID ?? "",
                descriptiveWords: descriptiveWords,
                season: .watering,
                goals: goals,
                virtues: virtues,
                quotes: quotes,
                principles: principles,
                rules: rules,
                imagesWithDuration: formulaImages(),
                narratorID: selectedNarrator,
                chatResponse: "")
    }
    
    func formulaImages() -> [FormulaImage : Int] {
        var returnables: [FormulaImage : Int] = [:]
        for image in self.images {
            let formulaImage = FormulaImage(photo: image)
            returnables[formulaImage] = 3
        }
        return returnables
    }
    
    func buildFormulaVideo(frameRate: Int, withCompletion completion: @escaping(Formula) -> Void) {
//         let formula = formulaFromFields()
        let formula = Formula.example
        print(formula.chatResponse)
        chatManager.getPersonalSummaryFromFormula(formula) { newFormula in
                print(newFormula.chatResponse)
                self.videoManager.formulate(formula: newFormula, frameRate: frameRate) { formulaURL in
                    var newestFormula = newFormula
                    newestFormula.formulaURL = formulaURL
                    self.firebaseManager.saveFormulaTapped(newestFormula)
                    completion(newestFormula)
                }
            }
        
    }
}


struct FormulaBuilderView: View {
    

    @State private var ruleInput = ""
    @State var currentPage = 1

    @ObservedObject var formulaManager = FormulaManager.instance
    @ObservedObject var viewModel = FormulaViewViewModel.instance
    var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    cancelButton
                    capsule
                }
                
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
                    } else {
                        saveButton
                    }
                }
                
            }
        
    }
    
    var capsule: some View {
        CapsuleProgressView(
            progress: currentPage,
            pageCount: formulaManager.formulaPageCount)
        .frame(height: 40)
        .padding(.top)
        
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
    
    var saveButton: some View {
        Button {
            viewModel.showBuilder = false
            viewModel.showWaiting = true
            formulaManager.buildFormulaVideo(frameRate: 1) { formula in
                formulaManager.formula = formula
                viewModel.showWaiting = false
            }
        } label: {
            Text("Save")
        }
    }
    
    private var cancelButton: some View {
        Button {
            viewModel.showBuilder = false
        } label: {
            Image(systemName: "x.circle")
                .font(.title)
                .foregroundStyle(.black.opacity(0.6))
        }
        .padding(.bottom)

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
            AVNarratorView()

        }
    }
}

extension Binding<[Virtue]> {
    func virtueStrings() -> Binding<[String]> {
        var returnables: Binding<[String]> = .constant([])
        let _ = self.map { bindVirtue in
            returnables.wrappedValue.append(bindVirtue.text.wrappedValue)
        }
        return returnables

    }
}

//MARK: - Virtues
extension FormulaBuilderView {
    
    var virtuesView: some View {
        InputGroupView(inputGroup: .virtues, submissions: $formulaManager.virtues)
    }
    
//    func convertStringsToVirtues() {
//
//        var virtuesReturnable: [Virtue] = []
//        for string in formulaManager.virtues {
//            let virtue = Virtue(text: string)
//            let virtuesDoesntContainNewVirtue = !virtuesReturnable.contains(where: { $0.text == string })
//            if virtuesDoesntContainNewVirtue {
//                virtuesReturnable.append(virtue)
//            }
//        }
//        // Save virtues to formula...
//        // Save formula to firebase
//    }
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


struct FormulaBuilderLoadingView: View {
    
    var body: some View {
        Image(systemName: "testtube.2")
    }
}
