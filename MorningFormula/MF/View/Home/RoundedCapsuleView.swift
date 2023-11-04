////
////  RoundedCapsuleView.swift
////  MorningFormula
////
////  Created by Spencer Belton on 10/30/23.
////
//
//import SwiftUI
//
//struct RoundedCapsuleView: View {
//    
//    @State var capsuleWidths: [Int:Double] = [:]
//
//    @State var tasks: [MFTask]
//    
//    var taskCapsuleOffset: [(offset: Int, element: Int)] {
//        let intDurations = tasks.map { $0.intDuration }
//        return Array(intDurations.enumerated())
//    }
//    
//    let radius: Double = 125
//    
//    var body: some View {
//        ZStack {
//            ForEach(taskCapsuleOffset, id: \.offset) { index, capsule in
//                VStack {
//                    Capsule()
//                        .foregroundStyle(.red)
//                }
//            }
//        }
//    }
//    
//    func fetchAngle(at capsulePosition: Int) -> Angle {
//        let times2pi: (Double) -> Double = { $0 * 2 * .pi }
//        
//        let circumference = times2pi(radius)
//                        
//        let finalAngle = times2pi(capsuleWidths.filter{$0.key <= capsulePosition}.map(\.value).reduce(0, +) / circumference)
//        
//        return .radians(finalAngle)
//    }
//}
//
//#Preview {
//    RoundedCapsuleView(tasks: MFTask.examples)
//}

import SwiftUI

struct CircularCapsulesView: View {
    @State private var capsuleWidths: [Int: Double] = [:]
    
    var tasks: [TaskWithDuration]
    var circleRadius: Double
    
    var body: some View {
        ZStack {
            ForEach(0...tasks.count, id: \.self) { index in
                Capsule()
                    .frame(width: CGFloat(capsuleWidths[index] ?? 2000), height: 20)
//                    .foregroundColor(Color.blue)
                    .foregroundStyle(Color.black)
                    .rotationEffect(angleForTask(at: index))
                    .offset(x: CGFloat(circleRadius))
            }
        }
        .frame(width: CGFloat(circleRadius * 2), height: CGFloat(circleRadius * 2))
        .rotationEffect(.degrees(90)) // Adjust rotation if needed
        .onPreferenceChange(WidthCapsulePreferenceKey.self) { values in
            for (index, width) in values {
                capsuleWidths[index] = width
            }
        }
    }
    
    func angleForTask(at index: Int) -> Angle {
        let totalDuration = tasks.reduce(0) { $0 + $1.duration }
        let relativeDuration = tasks.prefix(index + 1).reduce(0) { $0 + $1.duration }
        let proportion = relativeDuration / totalDuration
        return .degrees(360 * proportion)
    }
}

struct TaskWithDuration {
    var name: String
    var duration: Double // Duration in hours
}

struct WidthCapsulePreferenceKey: PreferenceKey {
    static var defaultValue: [Int: Double] = [:]
    
    static func reduce(value: inout [Int: Double], nextValue: () -> [Int: Double]) {
        for (index, width) in nextValue() {
            value[index] = width
        }
    }
}

struct CircularCapsulesView_Previews: PreviewProvider {
    static var previews: some View {
        let tasks = [
            TaskWithDuration(name: "Task 1", duration: 8),
            TaskWithDuration(name: "Task 2", duration: 5),
            TaskWithDuration(name: "Task 3", duration: 3)
        ]
        return CircularCapsulesView(tasks: tasks, circleRadius: 150)
            .background(
                Color.red)
    }
}
