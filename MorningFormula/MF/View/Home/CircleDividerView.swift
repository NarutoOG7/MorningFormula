//
//  CircleDividerView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/30/23.
//

import SwiftUI

// The normalized function returns a unit vector with the same direction
extension CGPoint {
    func normalized() -> CGPoint {
        let length = sqrt(x * x + y * y)
        return CGPoint(x: x / length, y: y / length)
    }
}

struct CircleDividerView: View {
    var numberOfSegments: Double = 24
    
    @Binding var selectedTask: MFTask?
    @Binding var day: Date
    @Binding var isDaySetByMidnight: Bool
    @Binding var sleepTime: (start: Double, end: Double, duration: Double)
        
    @ObservedObject var viewModel = TodayViewModel.instance
    
    var eodTime: Double {
        isDaySetByMidnight ? 24 : sleepTime.start
    }
    
    var angleIncrement: Double {
        360.0 / Double(numberOfSegments)
    }
    
    var degreeRotation: Double {
        (angleIncrement * eodTime) + 90
    }
    
    func radius(_ geo: GeometryProxy) -> CGFloat {
        min(geo.size.width, geo.size.height) / 2
    }
    
    func center(_ geo: GeometryProxy) -> CGPoint {
        CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
    }
    
    var body: some View {
        GeometryReader { geo in
            let radius = radius(geo)
            let center = center(geo)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 7)
                currentTimeTicker(geo)
                VStack {
                    if selectedTask == nil {
                        dayCompletionPercentageView
                    } else {
                        taskTitle
                    }
                }
                
                tasksView(center: center, radius: radius)
                
                endOfDayMarker(geo)
                
                
            }
        }
    }
    
    
    private var taskTitle: some View {
        Text(selectedTask?.title ?? "")
            .foregroundStyle(selectedTask?.chosenColor ?? .red)
    }
    
    private var dayCompletionPercentageView: some View {
        let decimal = Date().getMilitaryTime().double / 24
        let percentage = decimal * 100
        let percentageString = String(format: "%.0f", percentage)
        return VStack(alignment: .center) {
            Text(percentageString + "%")
                .font(.roboto(size: 50, weight: .Medium))
            Text("through the day")
                .font(.roboto(size: 13, weight: .Regular))
            
        }
    }
    
    private func taskTapped() {
        
    }
    
    private func path(center: CGPoint, radius: CGFloat, startAngle: Angle, endAngle: Angle, color: Color, lineHeight: CGFloat) -> Path {
        Path { path in
            path.addArc(center: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false)
            
        }
    }
    
    
    
    private func tasksView(center: CGPoint, radius: CGFloat) -> some View {
        ForEach(MFTask.examples/*viewModel.sortedTasks*/, id: \.id) { task in
            let lowerBounds = task.starTime.getMilitaryTime().double
            var upperBounds = task.endTime.getMilitaryTime().double
            
            let _ = print(lowerBounds)
            let _ = print(upperBounds)
            let _ = print("EOD: \(eodTime)")
            
            if upperBounds < lowerBounds {
                let top = 24 + upperBounds
                let _ = upperBounds = (top > eodTime) ? eodTime : top
                
            }
                
                let range = lowerBounds...upperBounds
                let currentTime = Date().getMilitaryTime().double
                
                //            let isPassed = range.contains(currentTime)
                let isPassed = currentTime > upperBounds
            

            let eodIsInTask = range.contains(eodTime)
                if eodIsInTask {
                    
                    
                    Path { path in
                        let start = Angle(degrees: (lowerBounds * angleIncrement) - degreeRotation)
                        let end = Angle(degrees: (upperBounds * angleIncrement) - degreeRotation)
                        path.addArc(center: center,
                                    radius: radius,
                                    startAngle: start,
                                    endAngle: end,
                                    clockwise: false)
                    }
                    .stroke(color(task: task, currentTimeHasPassed: isPassed),  lineWidth: 30)
                    .onTapGesture {
                        self.selectedTask = task
                    }
                    
//                    Path { path in
//                        let start = Angle(degrees: (eodTime * angleIncrement) - degreeRotation)
//                        let end = Angle(degrees: (upperBounds * angleIncrement) - degreeRotation)
//                        path.addArc(center: center,
//                                    radius: radius,
//                                    startAngle: start,
//                                    endAngle: end,
//                                    clockwise: false)
//                    }
//                    .stroke(.gray,  lineWidth: 30)
//                    
//                    .onTapGesture {
//                        self.selectedTask = task
//                    }
                    
                } else {
                    Path { path in
                        let start = Angle(degrees: (lowerBounds * angleIncrement) - degreeRotation)
                        let end = Angle(degrees: (upperBounds * angleIncrement) - degreeRotation)
                        print(lowerBounds)
                        print(upperBounds)
                        path.addArc(center: center,
                                    radius: radius,
                                    startAngle: start,
                                    endAngle: end,
                                    clockwise: false)
                    }
                    .stroke(color(task: task, currentTimeHasPassed: isPassed),  lineWidth: 30)
                    
                    .onTapGesture {
                        self.selectedTask = task
                    }
                }
            }
        
    }

    
//    private var tasksView: some View {
//            ForEach(viewModel.tasks) { task in
//
//                let taskDurationRange = task.startTime...task.startTime + task.intDuration
//                let eodIsInTask = taskDurationRange.contains(eodTime)
//
//                let mTime = getMilitaryTime()
//                let minDecimal = Double(mTime.min) / 60.0
//                let time = Double(mTime.hr) + minDecimal
//                
//                let isPassed = time > (task.start + task.duration)
//
//                let color: Color = isPassed ? .gray : task.color
//                let degreeRotation = wheelRotatesWithEOD ? degreeRotation : 90
//                if eodIsInTask {
//                    Path { path in
//                        
//
//                        let firstStart = Angle(degrees: (Double(task.start) * angleIncrement) - degreeRotation)
//                        let firstEnd = Angle(degrees: (eodTime * angleIncrement) - degreeRotation)
//                        path.addArc(center: center, radius: radius, startAngle: firstStart, endAngle: firstEnd, clockwise: false)
//                        
//                    }
//                    .stroke(color,  lineWidth: 30)
//                    
//                    Path { path in
//                        let secondStart = Angle(degrees: (eodTime * angleIncrement) - degreeRotation)
//                        let secondEnd = Angle(degrees: (Double(task.start + task.duration) * angleIncrement) - degreeRotation)
//                        path.addArc(center: center, radius: radius, startAngle: secondStart, endAngle: secondEnd, clockwise: false)
//                    }
//                    .stroke(.gray,  lineWidth: 30)
//                    
//                    
//                } else {
//                    
//                    Path { path in
//                        let startAngle = Angle(degrees: (Double(task.start) * angleIncrement) - degreeRotation)
//                        let endAngle = Angle(degrees: (Double(task.start + task.duration) * angleIncrement) - degreeRotation)
//                        
//                        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//                        
//                    }
//                    .stroke(color,  lineWidth: 30)
//                    
//                    .onTapGesture {
//                        self.selectedTask = task
//                    }
//
//            }
//        }
//    }
    
//    private func tasksView(center: CGPoint, radius: CGFloat) -> some View {
//        ForEach(viewModel.tasks, id: \.id) { task in
//            let lowerBounds = task.starTime.getMilitaryTime().double
//            let upperBound = task.endTime.getMilitaryTime().double
//            
//            let range = lowerBounds...upperBound
//            let currentTime = Date().getMilitaryTime().double
//
//            let eodIsInTask = range.contains(eodTime)
//            let isPassed = range.contains(currentTime)
//            
//            let color: Color = isPassed ? .gray : task.chosenColor
//            let degreeRotation = wheelRotatesWithEOD ? degreeRotation : 90
//
//            if eodIsInTask {
//                let firstStart = Angle(degrees: (lowerBounds * angleIncrement) - degreeRotation)
//                let firstEnd = Angle(degrees: (eodTime * angleIncrement) - degreeRotation)
//                
//                let secondStart = Angle(degrees: (eodTime * angleIncrement) - degreeRotation)
//                let secondEnd = Angle(degrees: (upperBound * angleIncrement) - degreeRotation)
//                Group {
//                    path(center: center, radius: radius, startAngle: firstStart, endAngle: firstEnd, color: color, lineHeight: 30)
//                    
//                    path(center: center, radius: radius, startAngle: secondStart, endAngle: secondEnd, color: color, lineHeight: 30)
//                }
//            } else {
//                let startAngle = Angle(degrees: (Double(task.start) * angleIncrement) - degreeRotation)
//                let endAngle = Angle(degrees: (Double(task.start + task.duration) * angleIncrement) - degreeRotation)
//
//                path(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, color: color, lineHeight: 30)
//            }
//                .onTapGesture {
//                    self.selectedTask = task
//                }
//        }
//    }
    

    private func color(task: MFTask, currentTimeHasPassed: Bool) -> Color {
        let thereIsSelectedTask = selectedTask != nil
        let taskIsNotSelected = task != selectedTask
            
        if thereIsSelectedTask && taskIsNotSelected {
            return task.chosenColor.opacity(0.6)
        } else if currentTimeHasPassed {
           return Color.gray
        } else {
            return task.chosenColor
        }

    }
}
extension CircleDividerView {
    //MARK: - Current Time Marker
    
    private func currentTimeTicker(_ geometry: GeometryProxy) -> some View {
        let militaryDouble = Date().getMilitaryTime().double
        
        let radius = min(geometry.size.width, geometry.size.height) / 2
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let angleIncrement = 360.0 / Double(numberOfSegments)
        
        return Path { path in
            let startAngle = Angle(degrees: ((militaryDouble - 0.125) * angleIncrement) - degreeRotation)
            let endAngle = Angle(degrees: ((militaryDouble + 0.125) * angleIncrement) - degreeRotation)
            
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
        }
        .stroke(.blue, lineWidth: 60)
    }
    
    func getMilitaryTime() -> (hr: Int, min: Int) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: day)
        /// change to Date() ???? instead of day
        let hour = components.hour ?? 0
        let minutes = components.minute ?? 0
        return (hr: hour, min: minutes)
    }
}

extension CircleDividerView {
    //MARK: - End Of Day Marker
    
    private func endOfDayMarker(_ geometry: GeometryProxy) -> some View {
        
        let end = isDaySetByMidnight ? 24.0 : 22.0
        
        let radius = min(geometry.size.width, geometry.size.height) / 2
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let angleIncrement = 360.0 / Double(numberOfSegments)
        
        let startAngle = Angle(degrees: ((end - 0.025) * angleIncrement) - degreeRotation)
        let endAngle = Angle(degrees: ((end + 0.025) * angleIncrement) - degreeRotation)
        
        
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
        .stroke(.blue, lineWidth: 60)
        //        .overlay {
        //            Text("\(startAngle.degrees)")
        //                .position(calculateLineEndpoint(geometry, startAngle))
        //        }
    }
}


#Preview {
    CircleDividerView(selectedTask: .constant(MFTask.exampleOne),
                      day: .constant(Date()),
                    isDaySetByMidnight: .constant(false),
                      sleepTime: .constant((start: 22, end: 30, duration: 8)))
    .frame(width: 250, height: 250)
}

