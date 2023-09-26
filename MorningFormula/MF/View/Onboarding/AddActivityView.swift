//
//  AddActivityView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/25/23.
//

import SwiftUI

struct AddActivityView: View {
    
    @State var titleInput = ""
    @State var timeInput = DateInterval()
    @State var selectedColor = Color.red
    @State var selectedRepetitionIndex = 0
    
    @ObservedObject var viewModel = AddGoalsVM.instance
    
    
    var body: some View {
        ScrollView {
            
            
            VStack(alignment: .leading, spacing: 40) {
                cancelButton
                titleField
                timeField
                colorField
                TaskRepetitionView(selectedColor: $selectedColor, selectedRepetitionIndex: $selectedRepetitionIndex)
                addButton
            }
            .padding(.horizontal)
        }
    }
    
    var titleField: some View {
        VStack(alignment: .leading) {
            Text("What is this actionable step called?")
                .font(.headline)
                .foregroundColor(.gray)
            TextField("ex. Workout", text: $titleInput)
                .submitLabel(.done)
                .textFieldStyle(RoundedTextStyle())
        }
    }
    
    var timeField: some View {
        VStack(alignment: .leading) {
            Text("How long does this take?")
                .font(.headline)
                .foregroundColor(.gray)
            TimerOptions(selectedColor: selectedColor)
        }
    }
    
    
    var colorField: some View {
        VStack(alignment: .leading) {
            Text("What color?")
                .font(.headline)
                .foregroundColor(.gray)
            ColorSelection(selectedColor: $selectedColor)
        }
    }
    
    private var addButton: some View {
        HStack {
            Spacer()
            Button(action: addTapped) {
                Text("Add Activity")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedColor))
            }
            Spacer()
        }
    }
    
    private var cancelButton: some View {
        Button {
            viewModel.showAddActivityPopUp = false
        } label: {
            Text("Cancel")
        }

    }
    
    private func addTapped() {
        viewModel.activities.append(newActivity())
        viewModel.showAddActivityPopUp = false
    }
    
    private func newActivity() -> Activity {
        let activity = Activity(title: titleInput,
                 time: timeInput.duration,
                 weight: .three,
                 color: selectedColor,
                 repetition: TaskRepetion.daily.caseFromTag(selectedRepetitionIndex))
        print(activity.repetition.rawValue)
        return activity
    }
}

class AddGoalsVM: ObservableObject {
    static let instance = AddGoalsVM()
    
    @Published var goals: [Goal] = []
    @Published var activities: [Activity] = []

    @Published var showAddActivityPopUp = false
    @Published var showAddGoalView = false

}

struct TimerOptions: View {
    
    var selectedColor: Color
    
    @State var selectedDurationIndex = 0
    @State var showTimeWheel = false
    
    var body: some View {
        ZStack {
            Picker("", selection: $selectedDurationIndex) {
                ForEach(TaskDuration.allCases, id: \.rawValue) { duration in
                    if selectedDurationIndex == duration.rawValue {
                        Text(duration.selectedText).tag(duration.rawValue)
                    } else {
                        Text(duration.idleText).tag(duration.rawValue)
                    }
                }
            }
            .pickerStyle(.segmented)
            .padding(.top, showTimeWheel ? -100 : 0)
            
            .onChange(of: selectedDurationIndex) { index in
                print(index)
                switch index {
                case TaskDuration.other.rawValue:
                    showTimeWheel = true
                default:
                    showTimeWheel = false
                }
            }
            
            if showTimeWheel {
                CountdownTimerView(selectedColor)
            }
        }
    }
    
    init(selectedColor: Color) {
        self.selectedColor = selectedColor
//        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(selectedColor)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }
}


extension Binding where Value == Color? {
    func toNonOptional() -> Binding<Color> {
        return Binding<Color>(
            get: {
                return self.wrappedValue ?? .white
            },
            set: {
                self.wrappedValue = $0
            }
        )
        
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView()
    }
}

enum TaskDuration: Int, CaseIterable {
    
    case oneMinute = 0
    case fifteenMinutes = 1
    case thirtyMinutes = 2
    case fourtyFiveMinutes = 3
    case oneHours = 4
    case other = 5
    
    var selectedText: String {
        switch self {
        case .oneMinute:
            return "1m"
        case .fifteenMinutes:
            return "15m"
        case .thirtyMinutes:
            return "30m"
        case .fourtyFiveMinutes:
            return "45m"
        case .oneHours:
            return "1hr"
        case .other:
            return "+"
        }
    }
    
    var idleText: String {
        switch self {
        case .oneMinute:
            return "1"
        case .fifteenMinutes:
            return "15"
        case .thirtyMinutes:
            return "30"
        case .fourtyFiveMinutes:
            return "45"
        case .oneHours:
            return "1hr"
        case .other:
            return "+"
        }
    }
}

struct TaskRepetitionView: View {
    
    @Binding var selectedColor: Color
    @Binding var selectedRepetitionIndex: Int
        
    var body: some View {
        Picker("", selection: $selectedRepetitionIndex) {
            ForEach(TaskRepetion.allCases, id: \.tag) { repetition in
                Text(repetition.rawValue.capitalized).tag(repetition.tag)
                    .foregroundColor(selectedColor)
            }
        }
        .pickerStyle(.segmented)
    }
    
    
//    init(selectedColor: Binding<Color>) {
//        self.selectedColor = selectedColor
//        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(selectedColor)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
//    }
}

enum TaskRepetion: String, CaseIterable {
    case once
    case daily
    case weekly
    case monthly
    
    var tag: Int {
        switch self {
        case .once:
            return 0
        case .daily:
            return 1
        case .weekly:
            return 2
        case .monthly:
            return 3
        }
    }
    
    func caseFromTag(_ tag: Int) -> Self {
        switch tag {
        case 0:
            return .once
        case 1:
            return .daily
        case 2:
            return .weekly
        case 3:
            return .monthly
        default:
            return .daily
        }
    }
    
}
