//
//  TabBarView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/2/23.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            dayView
        }
    }
    
    private var dayView: some View {
        
        NavigationView {
            DayView()
                .navigationTitle("")
        }
        .tabItem {
            Text("Day")
            Image(systemName: "calendar.day.timeline.leading")
            
        }
        .tag(0)
        
    }
    
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
