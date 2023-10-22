//
//  ChatView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/21/23.
//

import SwiftUI

struct ChatView: View {
    
    var formula: Formula
    
    @ObservedObject var chatManager = ChatManager.instance
    
    var body: some View {
        VStack {
            getResponseButton
            chatResponse
        }
    }
    
    private var chatResponse: some View {
        Text(chatManager.introduction)
    }
    
    private var getResponseButton: some View {
        Button(action: {                chatManager.getChatResponseFromFormula(formula)
        }, label: {
            Text("Get Response")
        })
    }
}

#Preview {
    ChatView(formula: Formula.example)
}
