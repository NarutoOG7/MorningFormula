//
//  DayTaskCell.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/2/23.
//

import SwiftUI



struct DayTaskCell: View {
    
    @Binding var task: MFTask
        
    var body: some View {
            HStack {
                time
                taskCell
                    .padding(.leading, 20)
                
            }
    }
    
    private var time: some View {
        Text(task.starTime.formatted(date: .omitted, time: .shortened))
            .font(.subheadline)
            .frame(width: 80)
            .foregroundColor(task.chosenColor)
    }
    
    private var taskCell: some View {
        VStack(alignment: .leading, spacing: 2) {
                taskTitle
                .padding(.bottom, 2)
            taskDescription
        HStack {
            duration
            Spacer()
            startEndTimeView
        }
        }
    }
    
    private var taskTitle: some View {
        Text(task.title)
            .font(.title3)
            .foregroundColor(task.chosenColor)
    }
    
    private var taskDescription: some View {
        Text(task.description)
            .font(.subheadline)
            .foregroundColor(task.chosenColor.opacity(0.8))

    }
    
    private var duration: some View {
        Text(task.durationString(startTime:task.starTime, endTime: task.endTime))
            .font(.caption)
            .italic()
            .foregroundColor(task.chosenColor)
    }
    
    private var startEndTimeView: some View {
        HStack {
            Text(task.starTime.formatted(date: .omitted, time: .shortened))
                .font(.caption2)
                .italic()
                .foregroundColor(task.chosenColor)
            Text("-")
                .font(.caption2)
                .italic()
                .foregroundColor(task.chosenColor)
            Text(task.endTime.formatted(date: .omitted, time: .shortened))
                .font(.caption2)
                .italic()
                .foregroundColor(task.chosenColor)
        }
    }
}

struct DayTaskCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
            DayTaskCell(task: .constant(MFTask.exampleOne))

        }
    }
}
