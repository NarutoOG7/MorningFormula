//
//  Today.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/16/23.
//

import SwiftUI

struct Today: View {
    
    @ObservedObject var viewModel = TodayViewModel.instance
    
    @State var day = Date()
    @State var sleepTime = (start: 22.0, end: 6.0, duration: 8.0)
    @State var selectedTask: MFTask?
    
    @ObservedObject var addTaskViewModel = AddTaskViewModel.instance
    @ObservedObject var spotifyManager = SpotifyManager.instance
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    List {
                        
                        timeView
                            .listRowBackground(Color.clear)
                        tasksList
                            .listRowBackground(Color.clear)

                    }
                    .scrollContentBackground(.hidden)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .scrollIndicators(.hidden)
                    addTaskButton
                }
                
                
                .confirmationDialog("", isPresented: $viewModel.addActionIsVisible) {
                    NavigationLink {
                        AddGoalView()
                    } label: {
                        Text("Add Goal")
                    }
                    NavigationLink {
                        AddTaskView()
                    } label: {
                        Text("Add Task")
                    }
                }
                
                .actionSheet(isPresented: $viewModel.showEventSpanOption) {
                    ActionSheet(
                        title: Text("Delete Event"),
                        message: Text("Do you want to delete this event only or all future events?"),
                        buttons: [
                            .default(Text("Delete This Event")) {
                                if let indexSetForDeletingTask = viewModel.indexSetForDeletingTask {
                                    self.viewModel.deleteAtIndices(indexSetForDeletingTask, span: .thisEvent)
                                }
                            },
                            .default(Text("Delete All Future Events")) {
                                if let indexSetForDeletingTask = viewModel.indexSetForDeletingTask {
                                    self.viewModel.deleteAtIndices(indexSetForDeletingTask, span: .futureEvents)
                                }
                            },
                            .cancel()
                        ]
                    )
                }
                
            }
            
        }
    }
    
    private var timeView: some View {
        HStack {
            
            Spacer()
            
            CircleDividerView(selectedTask: $selectedTask,
                              day: $day,
                              isDaySetByMidnight: $viewModel.isDaySetByMidnight,
                              sleepTime: $sleepTime)
            .frame(width: 250, height: 350)
//            .padding(.top, 20)
            Spacer()
            
        }
        
    }
    
    private var tasksList: some View {
//        List {
            ForEach(MFTask.examples/*viewModel.sortedTasks*/) { task in
                Section {
                    DayTaskCell(task: .constant(task))
                        .onTapGesture {
                            selectedTask = task
                        }
                }
            }
            .onDelete(perform: { indexSet in
                viewModel.showEventSpanOption = true
                viewModel.indexSetForDeletingTask = indexSet
            })
    }
    
    private var addTaskButton: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    viewModel.toolbarAddTapped()
                } label: {
                    Text("+")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    ZStack {
        Today()
        RuleOfThirds()
    }
}
