//
//  Goals.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/9/23.
//

import SwiftUI

//var id = UUID().uuidString
//var title: String
//var goalDate: Date
//var priority: GoalPriority
//var activities: [Activity]
//var season: Season
//var color: CodableColor


struct GoalCell: View {
    
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading) {
            title
            Spacer()
            goalDate
            Spacer()
            scoreView
        }
    }
    
    private var title: some View {
        Text(goal.title)
    }
    
    private var goalDate: some View {
        Text("(\(goal.goalDate.formatted(date: .abbreviated, time: .omitted)))")
            .font(.subheadline)
    }
    
    private var scoreView: some View {
        Text(String(format: "%.0f", goal.points))
    }
    
    private var noPointsView: some View {
        Text("No points earned")
            .font(.caption)
    }
    
}
struct Goals: View {
    
    @ObservedObject var formulaManager = FormulaManager.instance
    
    var body: some View {
        list
    }
    
    var list: some View {
        List {
            ForEach(formulaManager.goals.sorted(by: { $0.goalDate < $1.goalDate })) { goal in
                Section {
                    GoalCell(goal: goal)
                }
            }
        }
    }
}


#Preview {
    Goals()
}
