//
//  DayView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/2/23.
//

import SwiftUI

class DayVVM: ObservableObject {
    static let instance = DayVVM()
    
    @Published var tasks: [MFTask] = []
}

struct DayView: View {
    
    let color: Color
    
    
    @Binding var day: Date
    
//    @ObservedObject var dayVVM = DayVVM.instance
//    @ObservedObject var addTaskViewModel = AddTaskViewModel.instance
    @ObservedObject var viewModel = HomeViewModel.instance
    var body: some View {
        VStack {
            list
                .background(color.edgesIgnoringSafeArea(.all))
        }
  
        
    }
    
    private var list: some View {
        ScrollViewReader { scrollValue in
//            ScrollView {
                List {
                    ForEach(viewModel.sortedTasks) { task in
                        DayTaskCell(task: .constant(task))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .padding(.vertical)
                    }
                    .onDelete(perform: { indexSet in
                        viewModel.showEventSpanOption = true
                        viewModel.indexSetForDeletingTask = indexSet
                    })
                }
//            }
            .onAppear {
                let components = Calendar.current.dateComponents([.hour, .minute], from: day)
                let doubleMinutes = Double(components.minute ?? 0)
                let currentTimeDouble = Double(components.hour ?? 0) + (doubleMinutes / 60)

                scrollValue.scrollTo(3, anchor: .top)
            }
        }
        
//        List($dayVVM.tasks.sorted(by: { $0.starTime.wrappedValue < $1.starTime.wrappedValue})) { task in
        
//        List(MFTask.examples) { task in
//            DayTaskCell(task: .constant(task))
//                    .listRowSeparator(.hidden)
//                    .listRowBackground(Color.clear)
//            }
//            .listStyle(.plain)
    }
    
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        let dayView = DayView(color: .white, day: .constant(Date()))
//        let _ = dayView.dayVVM.tasks = [MFTask.exampleOne, MFTask.exampleTwo]
        return dayView
    }
}
