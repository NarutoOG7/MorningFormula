//
//  AddTaskView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/2/23.
//

import SwiftUI

struct AddTaskView: View {
    
    
    @State var titleInput = ""
    @State var chosenColor = Color.yellow
    @State var eventDate = Date()
    @State var startTime = Date()
    @State var endTime = Date(timeIntervalSinceNow: 1200) /// 20 minutes
    @State var descriptionInput = ""
    @Environment(\.dismiss) var dismiss
    
    let taskManager = TaskManager.instance

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                list
            }
            createButton
        }
        
        .onChange(of: startTime) { newValue in
            endTime = newValue.addingTimeInterval(1200)
        }
        .onChange(of: endTime) { newValue in
            startTime = newValue.addingTimeInterval(-1200)
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
                .foregroundColor(chosenColor)
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
                    .foregroundColor(taskManager.blackOrWhite(for: chosenColor))
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
                        .foregroundColor(taskManager.blackOrWhite(for: chosenColor))
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
                        .foregroundColor(taskManager.blackOrWhite(for: chosenColor))
            }
            .listRowBackground(Color.black)
            .foregroundColor(.black)


        }
        .scrollContentBackground(.hidden)
        .background(chosenColor.edgesIgnoringSafeArea(.all))
    }
    
    private var titleField: some View {
            TextField("", text: $titleInput)
                .foregroundColor(.white)
                .font(.title2)
                .placeholder(when: titleInput.isEmpty) {
                    Text("ex. Attend Meeting")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.subheadline)
                }
    }
    private var colorField: some View {
        ColorPicker(selection: $chosenColor) {
            Text("Choose Color")
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
        }
    }
    
    private var eventDateView: some View {
        DatePicker(selection: $eventDate, displayedComponents: .date) {
            Text("Date:")
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
        }
        .datePickerStyle(.compact)
        .environment(\.colorScheme, .dark)
    }
    
    private var startTimeView: some View {
        DatePicker(selection: $startTime, displayedComponents: .hourAndMinute) {
            Text("Start time:")
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
        }
        .datePickerStyle(.compact)
        .environment(\.colorScheme, .dark)
    }
    
    private var endTimeView: some View {
        DatePicker(selection: $endTime, displayedComponents: .hourAndMinute) {
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
                .foregroundColor(taskManager.blackOrWhite(for: chosenColor))
                .font(.caption)
            Text("\(taskManager.durationString(startTime: startTime, endTime: endTime))")
                .foregroundColor(taskManager.blackOrWhite(for: chosenColor))
                .font(.subheadline)
        }
    }
    
    private var descriptionView: some View {
        TextField("", text: $descriptionInput, axis: .vertical)
            .foregroundColor(.white)
            .placeholder(when: descriptionInput.isEmpty) {
                Text("Add notes, tips, or any other helpful information.")
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(nil)
                    .font(.subheadline)
            }
    }
    
    private var createButton: some View {
        VStack {
            Spacer()
            Button(action: createTapped) {
                Text("Create Task")
                    .foregroundColor(taskManager.blackOrWhite(for: chosenColor))
                    .colorInvert()
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(taskManager.blackOrWhite(for: chosenColor)))
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
        let task = MFTask(id: UUID().uuidString,
                        title: titleInput,
                        starTime: startTime,
                        endTime: endTime,
                        description: descriptionInput,
                        isComplete: false,
                        chosenColor: chosenColor)
        DayVVM.instance.tasks.append(task)
        dismiss()
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}

class TaskManager {
    static let instance = TaskManager()
    
    func durationString(startTime: Date, endTime: Date) -> String {
        if startTime < endTime {
            let duration = DateInterval(start: startTime, end: endTime).duration
            let str = durationAsLogicalString(duration: duration)
            return "\(str)"
        }
        return ""
    }
    
    func durationAsLogicalString(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()

        formatter.maximumUnitCount = 2
        formatter.unitsStyle = .brief
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowedUnits = [.day, .hour, .minute, .second]

        if (!duration.isInfinite && !duration.isNaN) {
           return formatter.string(from: duration) ?? ""
        } else {
            return ""
        }
    }
    
    func blackOrWhite(for color: Color) -> Color {
        let uiColor = UIColor(color)
        
        // Calculate the relative luminance of the color
        let luminance = (0.299 * uiColor.cgColor.components![0] +
                         0.587 * uiColor.cgColor.components![1] +
                         0.114 * uiColor.cgColor.components![2])
        
        let threshold: CGFloat = 0.7
        
        // Determine if the color is light or dark based on the threshold
        let dark = luminance < threshold
        return dark ? .white : .black
    }
}
