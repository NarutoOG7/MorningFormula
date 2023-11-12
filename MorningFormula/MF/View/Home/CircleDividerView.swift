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
    
    @State var selectedTask: MFTask?
    @Binding var day: Date
    @Binding var isDaySetByMidnight: Bool
    @Binding var wheelRotatesWithEOD: Bool
    @Binding var sleepTime: (start: Double, end: Double, duration: Double)
    
    @ObservedObject var viewModel = HomeViewModel.instance
    
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
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: day)
            let currentHour = components.hour ?? 0
            ZStack {
                Circle()
                    .stroke(lineWidth: 7)
                currentTimeTicker(geo)
                VStack {
                    taskTitle
                    currentTime
                    Text("Task Start: \(self.selectedTask?.starTime.getMilitaryTime().double ?? 0)")
                    Text("Task End: \(self.selectedTask?.endTime.getMilitaryTime().double ?? 0)")

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
        ForEach(viewModel.sortedTasks, id: \.id) { task in
            let lowerBounds = task.starTime.getMilitaryTime().double
            let upperBounds = task.endTime.getMilitaryTime().double
            
            let _ = print(lowerBounds)
            let _ = print(upperBounds)

            let range = lowerBounds...upperBounds
            let currentTime = Date().getMilitaryTime().double
            
            let eodIsInTask = range.contains(eodTime)
//            let isPassed = range.contains(currentTime)
            let isPassed = currentTime > upperBounds
            
            let color: Color = isPassed ? .gray : task.chosenColor
            let degreeRotation = wheelRotatesWithEOD ? degreeRotation : 90
//            
//            if eodIsInTask {
//                
//                    
//                    Path { path in
//                        let start = Angle(degrees: (lowerBounds * angleIncrement) - degreeRotation)
//                        let end = Angle(degrees: (upperBounds * angleIncrement) - degreeRotation)
//                        path.addArc(center: center,
//                                    radius: radius,
//                                    startAngle: start,
//                                    endAngle: end,
//                                    clockwise: false)
//                    }                         
//                    .stroke(color,  lineWidth: 30)
//
//                    
//                    Path { path in
//                        let start = Angle(degrees: (eodTime * angleIncrement) - degreeRotation)
//                        let end = Angle(degrees: (upperBounds * angleIncrement) - degreeRotation)
//                        path.addArc(center: center,
//                                    radius: radius,
//                                    startAngle: start,
//                                    endAngle: end,
//                                    clockwise: false)
//                    }
//                                        .stroke(color,  lineWidth: 30)
//                
//
//                
//            } else {
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
                .stroke(color,  lineWidth: 30)

                .onTapGesture {
                    self.selectedTask = task
                }
//            }
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
    

    
}
extension CircleDividerView {
    //MARK: - Current Time Marker
    
    private func currentTimeTicker(_ geometry: GeometryProxy) -> some View {
        let components = Calendar.current.dateComponents([.hour, .minute], from: day)
        let currentHour = components.hour ?? 0
        let militaryMinutes: Double = Double(components.minute ?? 0)
        
        let radius = min(geometry.size.width, geometry.size.height) / 2
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let angleIncrement = 360.0 / Double(numberOfSegments)
        let degreeRotation = wheelRotatesWithEOD ? degreeRotation : 90
        let currentMilitaryHourGrade: Double = Double(currentHour) + Double(militaryMinutes / 60)
        
        let _ = print(militaryMinutes / 60)
        
        
        return Path { path in
            let startAngle = Angle(degrees: ((currentMilitaryHourGrade - 0.125) * angleIncrement) - degreeRotation)
            let endAngle = Angle(degrees: ((currentMilitaryHourGrade + 0.125) * angleIncrement) - degreeRotation)
            
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
        }
        .stroke(.blue, lineWidth: 60)
    }
    
    private var currentTime: some View {
        let time = getMilitaryTime()
        return VStack {
            Text(day.formatted(date: .omitted, time: .shortened))
            Text("\(time.hr):\(time.min)")
        }
    }
    
    func getMilitaryTime() -> (hr: Int, min: Int) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: day)
        let hour = components.hour ?? 0
        let minutes = components.minute ?? 0
        return (hr: hour, min: minutes)
    }
}

extension CircleDividerView {
    //MARK: - End Of Day Marker
    
    private func endOfDayMarker(_ geometry: GeometryProxy) -> some View {
        
        let end = isDaySetByMidnight ? 24 : sleepTime.start
        
        let radius = min(geometry.size.width, geometry.size.height) / 2
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let angleIncrement = 360.0 / Double(numberOfSegments)
        let degreeRotation = wheelRotatesWithEOD ? degreeRotation : 90
        
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
    CircleDividerView(day: .constant(Date()),
                    isDaySetByMidnight: .constant(false),
                      wheelRotatesWithEOD: .constant(true), sleepTime: .constant((start: 22, end: 30, duration: 8)))
    .frame(width: 250, height: 250)
}

