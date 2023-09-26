//
//  Home.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/25/23.
//

import SwiftUI

struct Home: View {
    
    @State var day = Date()
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack {
                
                timeView
                DayView(day: $day)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddGoalView()
                } label: {
                    Text("+")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

            }
        }
    }
    
    private var timeView: some View {
        Circle()
            .fill(.teal)
            .frame(width: 250)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Home()
        }
    }
}
