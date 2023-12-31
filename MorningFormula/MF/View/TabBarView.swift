//
//  TabBarView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/2/23.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var selection = 0
    
    @ObservedObject var calendarManager = CalendarManager.instance
    
    @StateObject var todayViewModel = TodayViewModel.instance


    var body: some View {
            
            TabView(selection: $selection) {
                formulaView
                homeView
                todayView
//                goalsView
                settingsView
            }
        }
    

    
    private var formulaView: some View {
        FormulaView()
            .padding()
            .tabItem {
                Text("Formula")
                Image(systemName: "testtube.2")
            }
            .tag(0)
    }
    
    private var homeView: some View {
            Home()
                .tabItem {
                    Text("Home")
                    Image(systemName: "house")
                }
                .tag(1)
    }
    
    private var todayView: some View {
        Today()
            .tabItem {
                Text("Today")
                Image(systemName: "calendar")
            }
            .tag(2)
        
            .onAppear {
                todayViewModel.eventManager.fetchEvents { events in
                    if events.count > 0 {
                        todayViewModel.ekEvents = events
                    }
                }
            }
    }
    
//    private var goalsView: some View {
//        Goals()
//            .padding()
//            .tabItem {
//                Text("My Goals")
//                Image(systemName: "testtube.2")
//            }
//            .tag(2)
//    }
    
    
    private var settingsView: some View {
        SettingsView()
            .tabItem {
                Text("Settings")
                Image(systemName: "gear")
            }
            .tag(3)
    }
    
    
//    private var weekView: some View {
//
//
//        .tabItem {
//            Text("Day")
//            Image(systemName: "calendar.day.timeline.leading")
//
//        }
//        .tag(0)
//
//    }
    

}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            TabBarView()
            RuleOfThirds()
        }
    }
}
