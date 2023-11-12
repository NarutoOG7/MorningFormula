//
//  AddTaskView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/2/23.
//

import SwiftUI

struct AddTaskView: View {
    
    @Environment(\.dismiss) var dismiss
    
//    let taskManager = TaskManager.instance
    @ObservedObject var viewModel = AddTaskViewModel.instance
    
    @State var showEventSpanOption = true

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                list
            }
            createButton
        }
        
        .onChange(of: viewModel.startTime) { newValue in
            viewModel.endTime = newValue.addingTimeInterval(1200)
        }
        
        .actionSheet(isPresented: $showEventSpanOption) {
             ActionSheet(
                 title: Text("Edit this Event"),
                 message: Text("Do you want to edit this event only or all future events?"),
                 buttons: [
                     .default(Text("Edit This Event")) {
                         // Handle editing this event
                         viewModel.selectedEventSpan = .thisEvent
                     },
                     .default(Text("Edit All Future Events")) {
                         // Handle editing all future events
                         viewModel.selectedEventSpan = .futureEvents

                     },
                     .cancel()
                 ]
             )
         }
    }
    
    var header: some View {
        HStack(spacing: 10) {
            Text("New")
                .font(.largeTitle)
                .foregroundColor(.white)
                .tracking(3)
            Text("Task")
                .font(.largeTitle)
                .foregroundColor(viewModel.chosenColor)
                .tracking(3)
            Spacer()
            cancelButton
        }
            .padding()
            .background(.black.opacity(0.8))
    }
    
    var list: some View {
        List {
            Section {
                titleField
                colorField
            } header: {
                Text("What is the task?")
                    .foregroundColor(self.blackOrWhite())
                    .fontWeight(.black)
            }
            .listRowBackground(Color.black)
            .foregroundColor(.black)
            
            Section {
                eventDateView
                startTimeView
                endTimeView
                
            } header: {
                    Text("When?")
                        .fontWeight(.black)
                        .foregroundColor(self.blackOrWhite())
            } footer: {
                durationView
            }
            .listRowBackground(Color.black)
            .foregroundColor(.black)

            Section {
                descriptionView
                
            } header: {
                    Text("Want to add any details?")
                        .fontWeight(.black)
                        .foregroundColor(self.blackOrWhite())
            }
            .listRowBackground(Color.black)
            .foregroundColor(.black)


            Section {
                reccurenceView
            }
            
        }
        .scrollContentBackground(.hidden)
        .background(viewModel.chosenColor.edgesIgnoringSafeArea(.all))
    }
    
    private var titleField: some View {
        TextField("", text: $viewModel.titleInput)
                .foregroundColor(.white)
                .font(.title2)
                .placeholder(when: viewModel.titleInput.isEmpty) {
                    Text("ex. Attend Meeting")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.subheadline)
                }
    }
    private var colorField: some View {
        ColorPicker(selection: $viewModel.chosenColor) {
            Text("Choose Color")
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
        }
    }
    
    private var eventDateView: some View {
        DatePicker(selection: $viewModel.eventDate, displayedComponents: .date) {
            Text("Date:")
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
        }
        .datePickerStyle(.compact)
        .environment(\.colorScheme, .dark)
    }
    
    private var startTimeView: some View {
        DatePicker(selection: $viewModel.startTime, displayedComponents: .hourAndMinute) {
            Text("Start time:")
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
        }
        .datePickerStyle(.compact)
        .environment(\.colorScheme, .dark)
    }
    
    private var endTimeView: some View {
        DatePicker(selection: $viewModel.endTime, displayedComponents: .hourAndMinute) {
            Text("End time:")
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
        }
        .datePickerStyle(.compact)
        .environment(\.colorScheme, .dark)
    }

    private var durationView: some View {
        HStack {
            Spacer()
            Text("Duration:")
                .foregroundColor(self.blackOrWhite())
                .font(.caption)
            Text("\(viewModel.durationString(startTime: viewModel.startTime, endTime: viewModel.endTime))")
                .foregroundColor(self.blackOrWhite())
                .font(.subheadline)
        }
    }
    
    private var descriptionView: some View {
        TextField("", text: $viewModel.descriptionInput, axis: .vertical)
            .foregroundColor(.white)
            .placeholder(when: viewModel.descriptionInput.isEmpty) {
                Text("Add notes, tips, or any other helpful information.")
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(nil)
                    .font(.subheadline)
            }
    }
    
    private var reccurenceView: some  View {
        HStack {
            Text("Repeats:")
            NavigationLink {
                EventReccurrenceView()
            } label: {
                Text(EventInterval.daily.rawValue)
            }
        }
    }
    
    private var createButton: some View {
        VStack {
            Spacer()
            Button(action: createTapped) {
                Text("Create Task")
                    .foregroundColor(self.blackOrWhite())
                    .colorInvert()
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(self.blackOrWhite()))
            }
        }
    }
    
    private var cancelButton: some View {
        Button {
            self.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.title)
                .foregroundColor(.gray)
        }

    }
    
    private func createTapped() {
        viewModel.createTaskAndEvent()
        dismiss()
    }
    
    private func blackOrWhite() -> Color {
        viewModel.blackOrWhite(for: viewModel.chosenColor)
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
