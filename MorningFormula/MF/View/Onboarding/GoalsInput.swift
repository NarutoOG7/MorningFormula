//
//  GoalsInput.swift
//  MorningFormula
//
//  Created by Spencer Belton on 7/5/23.
//

import SwiftUI

enum InputGroups {
    case goals
    case rules
    case affirmations
    
    var title: String {
        switch self {
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
        case .goals:
            return "Include any short and long term goals and shape them as if they will happen. example: I will travel to Iceland where I will ride in a helicopter to explore unspoiled highland wonders."
        case .rules:
            return "example: I spend one hour per day reading."
        case .affirmations:
            return "example: I see opportunity everywhere I look. Opportunity is everywhere and it is there for me every day. I feel confident and positive with the abundance of opportunity."
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
        .padding()
    }
    
    var title: some View {
        Text(inputGroup.title)
            .font(.title)
    }
    
    var subtitle: some View {
        Text(inputGroup.subtitle)
            .font(.caption)
            .foregroundColor(.gray)
        
    }
    
    var textfield: some View {
        TextField("Goals", text: $input)
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
                ForEach(["submissions", "razor blade", "razor blade has mmore thatn one i know for a fact that it does "], id: \.self) { submission in
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
                    .background(listItemBackground)
//                }
            }
                .onDelete(perform: delete)
            .listStyle(.plain)
        }
    }
    
    var lazyList: some View {
        LazyVGrid(columns: createGridItems(), spacing: 15) {
            ForEach(["submissions", "razor blade", "razor blade has mmore thatn one i know for a fact that it does "], id: \.self) { submission in
                HStack {
                Text(submission)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                deleteButton(item: submission)
            }
            .listRowSeparator(.hidden)
            
            .padding()
            .background(listItemBackground)
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
    
    var listItemBackground: some View {
        RoundedRectangle(cornerRadius: 25)
            .stroke(
                LinearGradient(
                    colors: [.red, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 2
            )
    }
    
    func delete(at offsets: IndexSet) {
        submissions.remove(atOffsets: offsets)
    }
    
    func createGridItems() -> [GridItem] {
        let gridItemLayout = [GridItem(.adaptive(minimum: 160)), GridItem(.adaptive(minimum: 350))]
        return gridItemLayout
    }
    
}

struct GoalsInput: View {
    
    @State var goals: [String] = []
    
    var body: some View {
        InputGroupView(inputGroup: .goals, submissions: $goals)
    }
}

struct GoalsInput_Previews: PreviewProvider {
    static var previews: some View {
        GoalsInput()
    }
}

