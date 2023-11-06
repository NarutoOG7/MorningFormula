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

struct CircleTask: Identifiable, Hashable {
    var id = UUID().uuidString
    var title: String
    var duration: Double
    var start: Double
    var end: Double
    var color: Color
    
    static let examples = [
//        CircleTask(title: "Sleep", duration: 8, start: 22, end: 6, color: .teal),
        CircleTask(title: "Code", duration: 0.5, start: 6, end: 6.5, color: .yellow),
        CircleTask(title: "Workout", duration: 1, start: 7, end: 8, color: .purple),
        CircleTask(title: "Work", duration: 5, start: 9, end: 14, color: .red),
        CircleTask(title: "Code", duration: 3, start: 16, end: 19, color: .yellow),
        CircleTask(title: "Play", duration: 1, start: 20, end: 21, color: .green)
    ]
}

struct CircleDividerView: View {
    var numberOfSegments: Double = 24
    
    var tasks: [CircleTask] {
        let sleep = CircleTask(title: "Sleep", duration: sleepTime.duration, start: sleepTime.start, end: sleepTime.end, color: .cyan)
        var tasks = CircleTask.examples

        tasks.append(sleep)
        return tasks
    }
    
    @State var selectedTask: CircleTask?
    @Binding var day: Date
    @Binding var isDaySetByMidnight: Bool
    @Binding var wheelRotatesWithEOD: Bool
    @Binding var sleepTime: (start: Double, end: Double, duration: Double)

    
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
                    Text("EOD: \(Int(eodTime))")

                }
                ForEach(tasks) { task in
//                    let range = 0.0...24.0
//                    let topEnd = task.start < task.end ? task.end : task.start
//                    let bottomEnd = task.start < task.end ? task.start : task.end
                    let taskDurationRange = task.start...task.start + task.duration
                    let eodIsInTask = taskDurationRange.contains(eodTime)
//                    let currentHourIsPassedTaskDuration = Double(currentHour) > (task.start + task.duration)
//                    let taskStartIsBeforeEOD = eodIsInTask &&  task.start < eodTime
                    let mTime = getMilitaryTime()
                    let minDecimal = Double(mTime.min) / 60.0
                    let time = Double(mTime.hr) + minDecimal
                    
                    let isPassed = time > (task.start + task.duration)
//                    let isPassed = taskStartIsBeforeEOD ? Double(currentHour) < task.start : currentHourIsPassedTaskDuration

                    let color: Color = isPassed ? .gray : task.color
                    let degreeRotation = wheelRotatesWithEOD ? degreeRotation : 90
                    if eodIsInTask {
                        Path { path in
                            

                            let firstStart = Angle(degrees: (Double(task.start) * angleIncrement) - degreeRotation)
                            let firstEnd = Angle(degrees: (eodTime * angleIncrement) - degreeRotation)
                            path.addArc(center: center, radius: radius, startAngle: firstStart, endAngle: firstEnd, clockwise: false)
                            
                        }
                        .stroke(color,  lineWidth: 30)
                        
                        Path { path in
                            let secondStart = Angle(degrees: (eodTime * angleIncrement) - degreeRotation)
                            let secondEnd = Angle(degrees: (Double(task.start + task.duration) * angleIncrement) - degreeRotation)
                            path.addArc(center: center, radius: radius, startAngle: secondStart, endAngle: secondEnd, clockwise: false)
                        }
                        .stroke(.gray,  lineWidth: 30)
                        
                        
                    } else {
                        
                        Path { path in
                            let startAngle = Angle(degrees: (Double(task.start) * angleIncrement) - degreeRotation)
                            let endAngle = Angle(degrees: (Double(task.start + task.duration) * angleIncrement) - degreeRotation)
                            
                            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                            
                        }
                        .stroke(color,  lineWidth: 30)
                        
                        .onTapGesture {
                            self.selectedTask = task
                        }
                    }
                }
                endOfDayMarker(geo)
                
                
            }
        }
    }
    
    
    private var taskTitle: some View {
        Text(selectedTask?.title ?? "")
            .foregroundStyle(selectedTask?.color ?? .blue)
    }
    
    private func taskTapped() {
        
    }
    
    
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

