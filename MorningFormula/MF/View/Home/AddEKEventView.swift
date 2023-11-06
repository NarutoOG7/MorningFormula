//
//  AddEKEventView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/5/23.
//

import SwiftUI

struct AddEKEventView: View {
    
    @ObservedObject var eventManager = EventManager.instance
    
    var body: some View {
        ZStack {
            VStack {
                addButton
                eventList
            }
            .task {
                eventManager.requestAccess()
            }
            if eventManager.isLoading {
                Color.gray.opacity(0.3)
                ProgressView()
            }
        }
    }
    
    private var eventList: some View {
        List {
            ForEach(eventManager.events, id: \.eventIdentifier) { event in
                Text(event.title)
            }
            .onDelete(perform: { indexSet in
                eventManager.deleteAtIndices(indexSet)
            })
        }
        
    }
    
    private var addButton: some View {
        Button {
            eventManager.demo()
        } label: {
            Text("Demo")
        }
    }
}

#Preview {
    AddEKEventView()
}
