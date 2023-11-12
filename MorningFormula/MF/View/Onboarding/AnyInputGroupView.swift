//
//  AnyInputGroupView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/9/23.
//

import SwiftUI


struct AnyGroupInputView: View  {
    
    let title: String
    let subTitle: String
    let textFieldPlaceholder: String

    let onTextChange: (String) -> Void
    
    @Binding var submissions: [String]
    @Binding var autoFillOptions: [String]
    
    @State var input = ""
    
    @State private var lastDeleted: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleView
            subtitleView
            textfield
            if lastDeleted != nil {
                undoLastButton
            }
            listOfSubmissions
                .padding(.horizontal, 5)
        }
    }
    
    var titleView: some View {
        Text(title)
            .font(.title)
    }
    
    var subtitleView: some View {
        Text(subTitle)
//            .font(.caption)
//            .foregroundColor(.gray)
            .font(.headline)
            .foregroundColor(.gray)
        
    }
    
    var textfield: some View {
        VStack {
        TextField(textFieldPlaceholder, text: $input)
            .submitLabel(.done)
            .onChange(of: input, perform: { newValue in
                onTextChange(newValue)
            })
            .onSubmit {
                self.submissions.append(input)
                   self.input = ""
            }
            listOfAutoCompleteOptions
        }
            .padding()
            .background(
                    GradientRoundedBackground()
            )
            
    }
    
    var listOfAutoCompleteOptions: some View {
            List(autoFillOptions, id: \.self) { option in
                VStack(alignment: .leading) {
                    Text(option)
                        .font(.subheadline)
                    Divider()
                }
                .padding(.leading, -10)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    self.submissions.append(option)
                    self.input = ""
                    self.autoFillOptions = []
                }
            }
            .listStyle(.plain)
            .frame(height: CGFloat(autoFillOptions.count) * 37)
            
    }
    
    var listOfSubmissions: some View {
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
    
//    var lazyList: some View {
//        LazyVGrid(columns: createGridItems(), spacing: 15) {
//            ForEach(submissions, id: \.self) { submission in
//                HStack {
//                    Text(submission)
//                    .font(.subheadline)
//                    .multilineTextAlignment(.center)
//                deleteButton(item: submission)
//            }
//            .listRowSeparator(.hidden)
//
//            .padding()
//            .background(ListItemBackground(colors: [.red, .blue]))
//            }
//        }
//    }
    
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

}


struct AnyInputGroupView_Previews: PreviewProvider {
    static var previews: some View {
        AnyGroupInputView(title: "Spotify",
                          subTitle: "Add Songs",
                          textFieldPlaceholder: "ex. Dream",
                          onTextChange: { newInput in },
                          submissions: .constant(["All-Star", "Landslide"]),
                          autoFillOptions: .constant(["All-Star", "Landslide"]))
        .padding()
    }
}
