//
//  GoalsInput.swift
//  MorningFormula
//
//  Created by Spencer Belton on 7/5/23.
//

import SwiftUI

enum InputGroups {
    case descriptiveWords
    case goals
    case rules
    case affirmations
    
    var title: String {
        switch self {
        case .descriptiveWords:
            return "" /// Nil on purpose
        case .goals:
            return "What are your goals?"
        case .rules:
            return "What personal rules would you like to follow?"
        case .affirmations:
            return "What are some affirmations that resonate with you?"
        }
    }
    
    var subtitle: String {
        switch self {
        case .descriptiveWords:
            return "What words describe you?"
        case .goals:
            return "Include any short and long term goals and shape them as if they will happen. example: I will travel to Iceland where I will ride in a helicopter to explore unspoiled highland wonders."
        case .rules:
            return "example: I spend one hour per day reading."
        case .affirmations:
            return "example: I see opportunity everywhere I look. Opportunity is everywhere and it is there for me every day. I feel confident and positive with the abundance of opportunity."
        }
    }
    
    var placeholder: String {
        switch self {
        case .descriptiveWords:
            return "ex. Family Man, iOS Developer, Brother, etc."
            
        case .goals:
            return "ex. Eat healthier"
            
        case .rules:
            return "ex. I sleep 8 hours per night"
        case .affirmations:
           return "ex. I am worthy of my goals"
        }
    }
    
    
}

struct InputGroupView: View {
    
    let inputGroup: InputGroups
    
    @Binding var submissions: [String]
    
    @State var input = ""
    
    @State private var lastDeleted: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            title
            subtitle
            textfield
            if lastDeleted != nil {
                undoLastButton
            }
            list
        }
    }
    
    var title: some View {
        Text(inputGroup.title)
            .font(.title)
    }
    
    var subtitle: some View {
        Text(inputGroup.subtitle)
//            .font(.caption)
//            .foregroundColor(.gray)
            .font(.headline)
            .foregroundColor(.gray)
        
    }
    
    var textfield: some View {
        TextField(inputGroup.placeholder, text: $input)
            .submitLabel(.done)
            .onSubmit {
                   self.submissions.append(self.input)
                   self.input = ""
            }
            .textFieldStyle(RoundedTextStyle())
    }
    
    var list: some View {
        VStack(alignment: .leading) {
//            List {
                ForEach(submissions, id: \.self) { submission in
                    HStack {
                        Text(submission)
                            .font(.subheadline)
//                                                .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        deleteButton(item: submission)
                    }
                    .listRowSeparator(.hidden)
                    
                    .padding()
                    //                .padding(.vertical)
                    //                .padding(.horizontal, 5)
                    .background(ListItemBackground(colors: [.red, .blue]))
//                }
            }
                .onDelete(perform: delete)
            .listStyle(.plain)
        }
    }
    
    var lazyList: some View {
        LazyVGrid(columns: createGridItems(), spacing: 15) {
            ForEach(submissions, id: \.self) { submission in
                HStack {
                Text(submission)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                deleteButton(item: submission)
            }
            .listRowSeparator(.hidden)
            
            .padding()
            .background(ListItemBackground(colors: [.red, .blue]))
            }
        }
    }
    
    func deleteButton(item: String) -> some View {
        Button {
            self.submissions.removeAll(where:  { $0 == item })
            self.lastDeleted = item
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(
                    LinearGradient(
                    colors: [.red, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
            
        }

    }
    
    var undoLastButton: some View {
        HStack {
            Spacer()
            Button {
                if let lastDeleted = lastDeleted {
                    self.submissions.append(lastDeleted)
                    self.lastDeleted = nil
                }
            } label: {
                Text("Undo Last")
                    .font(.subheadline)
                    .foregroundStyle(
                        Gradient(
                            colors: [.red, .blue]
                        ))
            }
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        submissions.remove(atOffsets: offsets)
    }
    
    func createGridItems() -> [GridItem] {
        let gridItemLayout = [GridItem(.adaptive(minimum: 160)), GridItem(.adaptive(minimum: 350))]
        return gridItemLayout
    }
    
}

//struct GoalsInput: View {
//
//    @State var goals: [String] = []
//
//    var body: some View {
//        InputGroupView(inputGroup: .goals, submissions: $goals)
//    }
//}

struct ListItemBackground: View {
    
    let colors: [Color]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .stroke(
                LinearGradient(
                    colors: colors,
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 2
            )
    }
}

struct GoalsInput: View {
    
    @ObservedObject var viewModel = AddGoalsVM.instance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("What are your goals?")
                .font(.title)
            Text("Short term, long term, dreamers, add them all.")
                .font(.headline)
                .foregroundColor(.gray)
            goalsButton
            goalsList
            Spacer()
            nextButton
        }
        .padding(.horizontal)
    }
    
    var goalsButton: some View {
//            Button {
//                DispatchQueue.main.async {
//                    viewModel.showAddGoalView
//                }
//            } label: {
//                Text("Add Goal")
//                    .underline()
//            }
        NavigationLink {
            AddGoalView()
                .padding(.horizontal)
        } label: {
            Text("Add Goal")
                .underline()
        }

    }
    
    private var goalsList: some View {
        VStack(alignment: .leading) {
            ForEach(Goal.examples) { goal in
                goalCell(goal)
            }
        }
        .listStyle(.plain)
    }
    
    private func goalCell(_ goal: Goal) -> some View {
        NavigationLink {
            AddGoalView(titleInput: goal.title, goalDate: goal.goalDate, goalPriority: goal.priority.rawValue, selectedColor: goal.color)
        } label: {
            HStack {
                Text(goal.title)
                    .foregroundColor(goal.color)
            }
            .padding(.horizontal)
            .padding(.vertical, 7)
            .background(ListItemBackground(colors: [goal.color]))
        }
    }
    
    private var nextButton: some View {
        HStack {
            Spacer()
            NavigationLink {
                Home()
            } label: {
                Text("Next")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
                    .background(ListItemBackground(colors: [.red, .blue]))
            }
        }
    }
}



struct DescriptiveWordsInput: View {
    
    @State var words: [String] = []
    
    var body: some View {
        InputGroupView(inputGroup: .descriptiveWords, submissions: $words)
    }
}

struct GoalsInput_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GoalsInput()
            //        DescriptiveWordsInput()
        }
    }
}

