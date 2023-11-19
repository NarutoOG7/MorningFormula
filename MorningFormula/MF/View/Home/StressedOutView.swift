//
//  StressedOutView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/18/23.
//

import SwiftUI

struct StressedOutView: View {
    
    let viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            promptView
            Spacer()
            completeButton
        }
        .frame(height: CGFloat(viewModel.stressedOutPrompt?.count ?? 0) * 1.5)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.teal)
            )
    }
    
    private var promptView: some View {
        Text(viewModel.stressedOutPrompt ?? "")
            .font(.roboto(size: 20, weight: .MediumItalic))
    }
    
    private var completeButton: some View {
        Button(action: {
            viewModel.stressedOutPrompt = nil
        }, label: {
            Text("Complete")
                .foregroundStyle(Color.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 3)
                    )
        })
    }
}

#Preview {
    StressedOutView(viewModel: HomeViewModel.instance)
}
