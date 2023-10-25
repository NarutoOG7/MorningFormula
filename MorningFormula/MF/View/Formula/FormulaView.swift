//
//  FormulaView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/21/23.
//

import SwiftUI

class FormulaViewViewModel: ObservableObject {
    static let instance = FormulaViewViewModel()
    
    @Published var showBuilder = false
    @Published var showWaiting = false
}


struct FormulaView: View {
    
    @ObservedObject var viewModel = FormulaViewViewModel.instance
    @ObservedObject var userStore = UserManager.instance
    @ObservedObject var formulaManager = FormulaManager.instance
    
    var body: some View {
        VStack {
            title
            
            if let formula = formulaManager.formula {
                subTitle
            ChatView(formula: formula)
                VideoPlayerView()
            } else {
                noFormulaSubtitle
                addFormulaButton
            }
        }
        
        .fullScreenCover(isPresented: $viewModel.showBuilder, content: {
            FormulaBuilderView()
                .padding()
        })
        
        .fullScreenCover(isPresented: $viewModel.showWaiting, content: {
            FormulaBuilderLoadingView()
                .padding()
        })
    }
    
    private var title: some View {
        Text("Hello \(userStore.userName),")
            .font(.title)
    }
    
    private var subTitle: some View {
        Text("This is your morning formula. Watch this first thing in the morning to start your day right!")
            .font(.subheadline)
            .foregroundStyle(.gray)
    }
    
    private var noFormulaSubtitle: some View {
        Text("No formula yet.")
    }
    
    private var addFormulaButton: some View {
        Button(action: {
            viewModel.showBuilder = true
        }, label: {
            Text("Build Formula")
        })
    }
}

#Preview {
    FormulaView()
}
