//
//  DayView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/2/23.
//

import SwiftUI

class DayVVM: ObservableObject {
    static let instance = DayVVM()
    
    @Published var tasks: [Task] = []
}

struct DayView: View {
    
    @Binding var day: Date
    
    @State var isShowingAddNewTask = false
    @ObservedObject var dayVVM = DayVVM.instance
    
    var body: some View {
        VStack {
            list
                .background(Color.black.opacity(0.8).edgesIgnoringSafeArea(.all))
            addButton
        }
        
        .sheet(isPresented: $isShowingAddNewTask) {
            AddTaskView()
                .navigationTitle("Add Task")
        }
    }
    
    private var list: some View {
        
        List($dayVVM.tasks.sorted(by: { $0.starTime.wrappedValue < $1.starTime.wrappedValue})) { task in
                DayTaskCell(task: task)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
        
    }
    
    
    private var addButton: some View {
//        NavigationLink {
//            // AddTask
//        } label: {
        Button {
            self.isShowingAddNewTask = true
        } label: {
            Text("Add Task")
        }

                
//        }

    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        let dayView = DayView(day: .constant(Date()))
        let _ = dayView.dayVVM.tasks = [Task.exampleOne, Task.exampleTwo]
        return dayView
    }
}
