//
//  Home.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/25/23.
//

import SwiftUI

struct Home: View {
    
    @State var day = Date()
    @State var addActionIsVisible = false
    @State var isDaySetByMidnight = true
    
    var body: some View {
        ZStack {
            VStack {
                dayDefinitionSwitch
                timeView
                DayView(color: .white, day: $day)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toolbarAddTapped, label: {
                    Text("+")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                })
            }
        }
        
        .confirmationDialog("", isPresented: $addActionIsVisible) {
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
    }
    
    private var timeView: some View {
        CircleDividerView(day: $day, isDaySetByMidnight: $isDaySetByMidnight)
            .frame(width: 250, height: 250)
//            .padding(.vertical)
            .padding(.bottom, 40)

    }
    
    private func toolbarAddTapped() {
        addActionIsVisible = true
    }
    
    private var dayDefinitionSwitch: some View {
        Toggle(isOn: $isDaySetByMidnight) {}
            .padding()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NavigationStack {
                Home()
            }
        }
    }
}
