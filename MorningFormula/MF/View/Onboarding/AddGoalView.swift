//
//  AddGoalView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/21/23.
//

import SwiftUI

struct AddGoalView: View {
    
    @State var titleInput = ""
    @State var goalDate = Date()
    @State var goalPriority = 0.0
    @State var selectedColor = Color.green
    
    
    @ObservedObject var viewModel = AddGoalsVM.instance
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 30) {
                Text("*Build out this goal with the intentions and mindset that you have already achieved your goal.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom)
//                Spacer()
                titleField
                
                
                goalDateView
                activitiesView
                Spacer()
            }
            .onTapGesture {
                viewModel.showAddActivityPopUp = false
            }
            .blur(radius: viewModel.showAddActivityPopUp ? 5 : 0)
            
            if viewModel.showAddActivityPopUp {
                AddActivityView()
                .frame(height: 400)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(radius: 20)
                    )
            }
        }
    }
    
    var titleField: some View {
        VStack(alignment: .leading) {
            Text("I am ")
                .font(.headline)
                .foregroundColor(.gray)
            TextField("ex. a healthy eater", text: $titleInput)
                .submitLabel(.done)
                .textFieldStyle(RoundedTextStyle())
        }
    }
    
    var goalDateView: some View {
        VStack(alignment: .leading) {

            Text("When would you like to accomplish this/ see progress by?")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, -20)
            DatePicker(selection: $goalDate, displayedComponents: .date) {}
        }
    }
    
    
    var activitiesView: some View {
        VStack(alignment: .leading) {
            Text("What actions or activities push you closer to your goal?")
                .font(.headline)
                .foregroundColor(.gray)
            Button {
                DispatchQueue.main.async {
                    
                    viewModel.showAddActivityPopUp = true
                }
            } label: {
                Text("Add Activity")
                    .underline()
            }
            activitiesList

        }
    }
    
    private var activitiesList: some View {
//        List(viewModel.activities) { activity in
//        List(Activity.examples) { activity in
        VStack(alignment: .leading) {
            ForEach(Activity.examples) { activity in
                HStack {
                    Text(activity.title)
                    Text(activity.repetition.rawValue)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .padding(.vertical, 7)
                .background(ListItemBackground(colors: [activity.color]))
            }
        }
        .listStyle(.plain)
    }
}
struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalView()
            .padding()
    }
}
