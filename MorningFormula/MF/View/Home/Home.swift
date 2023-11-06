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
    @State var wheelRotatesWithEOD = true
    @State var sleepTime = (start: 0.0, end: 8.0, duration: 8.0)
    
    var body: some View {
        ZStack {
            VStack {
                dayDefinitionSwitch
                wheelRotationSwitch
                timeView
//                DayView(color: .white, day: $day)
                    Text("Sleep(start: \(Int(sleepTime.start)), end: \(Int(sleepTime.end)), duration: \(Int(sleepTime.duration)))")
                Button {
                    sleepTime.start += 1
                    sleepTime.end += 1
                    
                } label: {
                    Text("Up One")
                }

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
        CircleDividerView(day: $day,
                          isDaySetByMidnight: $isDaySetByMidnight,
                          wheelRotatesWithEOD: $wheelRotatesWithEOD, sleepTime: $sleepTime)
            .frame(width: 250, height: 250)
//            .padding(.vertical)
            .padding(.bottom, 40)

    }
    
    private func toolbarAddTapped() {
        addActionIsVisible = true
    }
    
    private var dayDefinitionSwitch: some View {
        Toggle(isOn: $isDaySetByMidnight) {
            Text("Day Defined By Midnight?")
        }
            .padding()
    }
    private var wheelRotationSwitch: some View {
        Toggle(isOn: $wheelRotatesWithEOD) {
            Text("Wheel rotates withe EOD?")
        }
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
