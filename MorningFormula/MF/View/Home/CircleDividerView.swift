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
        CircleTask(title: "Sleep", duration: 8, start: 22, end: 6, color: .teal),
        CircleTask(title: "Code", duration: 0.5, start: 6, end: 6.6, color: .yellow),
        CircleTask(title: "Workout", duration: 1, start: 7, end: 8, color: .purple),
        CircleTask(title: "Work", duration: 5, start: 9, end: 14, color: .red),
        CircleTask(title: "Code", duration: 3, start: 16, end: 19, color: .yellow),
        CircleTask(title: "Play", duration: 1, start: 20, end: 21, color: .green)
    ]
}

struct CircleDividerView: View {
    var numberOfSegments: Double = 24
    
    var tasks: [CircleTask] = CircleTask.examples
    
    @State var bedTime: Double = 22
    @State var selectedTask: CircleTask?
    @Binding var day: Date
    @Binding var isDaySetByMidnight: Bool
    
    var eodTime: Double {
        isDaySetByMidnight ? 24 : bedTime
    }
    
    var angleIncrement: Double {
        360.0 / Double(numberOfSegments)
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
                    let isPassed = Double(currentHour) > (task.start + task.duration)
//                    let isPassed = taskStartIsBeforeEOD ? Double(currentHour) < task.start : currentHourIsPassedTaskDuration
                    
                    let color: Color = isPassed ? .gray : task.color
                    if eodIsInTask {
                        Path { path in
                            let firstStart = Angle(degrees: (Double(task.start) * angleIncrement) - 90)
                            let firstEnd = Angle(degrees: (eodTime * angleIncrement) - 90)
                            path.addArc(center: center, radius: radius, startAngle: firstStart, endAngle: firstEnd, clockwise: false)
                            
                        }
                        .stroke(color,  lineWidth: 30)
                        
                        Path { path in
                            let secondStart = Angle(degrees: (eodTime * angleIncrement) - 90)
                            let secondEnd = Angle(degrees: (Double(task.start + task.duration) * angleIncrement) - 90)
                            path.addArc(center: center, radius: radius, startAngle: secondStart, endAngle: secondEnd, clockwise: false)
                        }
                        .stroke(.gray,  lineWidth: 30)
                        
                        
                    } else {
                        
                        Path { path in
                            let startAngle = Angle(degrees: (Double(task.start) * angleIncrement) - 90)
                            let endAngle = Angle(degrees: (Double(task.start + task.duration) * angleIncrement) - 90)
                            
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
        
        let currentMilitaryHourGrade: Double = Double(currentHour) + Double(militaryMinutes / 60)
        
        let _ = print(militaryMinutes / 60)
        
        return Path { path in
            let startAngle = Angle(degrees: ((currentMilitaryHourGrade - 0.125) * angleIncrement) - 90)
            let endAngle = Angle(degrees: ((currentMilitaryHourGrade + 0.125) * angleIncrement) - 90)
            
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
        }
        .stroke(.blue, lineWidth: 60)
    }
    
    private var currentTime: some View {
        let components = Calendar.current.dateComponents([.hour, .minute], from: day)
        let currentHour = components.hour ?? 0
        let militaryMinutes = components.minute ?? 0
        
        return VStack {
            Text(day.formatted(date: .omitted, time: .shortened))
            Text("\(currentHour):\(militaryMinutes)")
        }
    }
}

extension CircleDividerView {
    //MARK: - End Of Day Marker
    
    //    private func endOfDayMarker(_ geometry: GeometryProxy) -> some View {
    //        let end = isDaySetByMidnight ? 24 : bedTime
    //
    //        let radius = min(geometry.size.width, geometry.size.height) / 2
    //        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
    //        let angleIncrement = 360.0 / Double(numberOfSegments)
    //
    //        let startAngle = Angle(degrees: (end - 0.025) * angleIncrement - 90)
    //        let endAngle = Angle(degrees: (end + 0.025) * angleIncrement - 90)
    //
    //        // Calculate the endpoint for the marker line
    //        let dotOnCircle = CGPoint(x: center.x + Foundation.cos(endAngle.radians) * radius, y: center.y + Foundation.sin(endAngle.radians) * radius)
    //
    //
    //        // Calculate the angle perpendicular to the endAngle
    //        let perpendicularAngle = endAngle + Angle(degrees: 90.0)  // Adding 90 degrees for a perpendicular angle
    //
    //        // Calculate the position of the xPoint
    //        let xOffset = cos(perpendicularAngle.radians) * 30.0  // 30.0 is the distance from the dotOnCircle
    //        let yOffset = sin(perpendicularAngle.radians) * 30.0
    //
    //        let xPoint = CGPoint(x: dotOnCircle.x + xOffset, y: dotOnCircle.y + yOffset)
    //
    //
    //        return Path { path in
    //            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
    //        }
    //        .stroke(.red, lineWidth: 60)
    //        .overlay {
    //            Text("\(startAngle.degrees)")
    //                .position(xPoint)
    //        }
    //    }
    
    private func calculateDotOnCircle(geo: GeometryProxy, _ angle: Angle) -> CGPoint {
        let center = center(geo)
        let radius = radius(geo)
        let xAngle = angle.radians // Angle in radians
        let xPositionX = center.x + radius * cos(xAngle)
        let xPositionY = center.y + radius * sin(xAngle)
        
        let pointX = CGPoint(x: xPositionX, y: xPositionY)
        
        return pointX
    }
    
    private func calculateLineEndpoint(_ geo: GeometryProxy, _ angle: Angle) -> CGPoint {
        let center = center(geo)
        let radius = radius(geo)
        
        let x = center.x + radius * cos(angle.degrees)
        let y = center.y + radius * sin(angle.degrees)
        return CGPoint(x: x, y: y)
    }
    
    
    private func endOfDayMarker(_ geometry: GeometryProxy) -> some View {
        
        let end = isDaySetByMidnight ? 24 : bedTime
        
        let radius = min(geometry.size.width, geometry.size.height) / 2
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let angleIncrement = 360.0 / Double(numberOfSegments)
        
        let startAngle = Angle(degrees: ((end - 0.025) * angleIncrement) - 90)
        let endAngle = Angle(degrees: ((end + 0.025) * angleIncrement) - 90)
        
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
        .stroke(.blue, lineWidth: 60)
        //        .overlay {
        //            Text("\(startAngle.degrees)")
        //                .position(calculateLineEndpoint(geometry, startAngle))
        //        }
    }
    
    
    //    func pointOnCircle(center: CGPoint, radius: Double, angle: Angle) -> CGPoint {
    //                let x = center.x + (radius * cos(angle.radians))
    //                let y = center.y + (radius * sin(angle.radians))
    //                return CGPoint(x: x, y: y)
    //    }
    
    func pointOnCircle(center: CGPoint, radius: Double, angle: Angle) -> CGPoint {
        let x = center.x + (radius * cos(angle.radians))
        let y = center.y + (radius * sin(angle.radians))
        let offset = offset(from: angle)
        // Ensure the calculated point is within the canvas bounds
        let clampedX = min(max(x, 0), Double(center.x) * 2) + offset.x
        let clampedY = min(max(y, 0), Double(center.y) * 2) - offset.y
        
        return CGPoint(x: clampedX, y: clampedY)
    }
    
    func offset(from angle: Angle) -> (x: Double, y: Double) {
        switch angle.degrees {
        case -75...(-45):
            return (x: 30, y: 50)
        case -45...(-15):
            return (x: 60, y: 30)
        case -15...0:
            return (x: 60, y: 15)
        case 0...15:
            return (x: 60, y: -20)
        default:
            return (x: 30, y: 50)
            
        }
    }
}

extension CircleDividerView {
    //MARK: - Maths
    
    // Calculate the start and end angles for a given segment
    private func angles(forSegment segment: Int) -> (start: Angle, end: Angle) {
        let angleIncrement = 360.0 / self.numberOfSegments
        let startAngle = Angle(degrees: Double(segment) * angleIncrement - 90)
        let endAngle = Angle(degrees: Double(segment + 1) * angleIncrement - 90)
        return (start: startAngle, end: endAngle)
    }
    
    func offset(forSegment segment: Int) -> (x: Double, y: Double) {
        let angleIncrement = 360.0 / self.numberOfSegments
        // Calculate the midpoint angle for the segment
        let midpointAngle = Angle(degrees: (Double(segment) + 0.5) * angleIncrement - 90)
        
        // Calculate the offset using trigonometry
        let offsetMagnitude: Double = 20.0  // Adjust this value as needed
        
        // Calculate the X and Y offset based on the angle
        let x = cos(midpointAngle.radians) * offsetMagnitude
        let y = sin(midpointAngle.radians) * offsetMagnitude
        
        return (x: x, y: y)
    }
    //
    //    // Calculate the offset for a given segment
    //    private func offset(forSegment segment: Int) -> (x: Double, y: Double) {
    //        let angleIncrement = 360.0 / numberOfSegments
    //        let midAngle = Angle(degrees: Double(segment) * angleIncrement + angleIncrement / 2 - 90)
    //        // Your offset logic here
    //        // Example offset calculation:
    //        let x = cos(midAngle.radians) * offsetValue
    //        let y = sin(midAngle.radians) * offsetValue
    //        return (x: x, y: y)
    //    }
}

#Preview {
    CircleDividerView(bedTime: 29,
                      day: .constant(Date()),
                      isDaySetByMidnight: .constant(false))
    .frame(width: 250, height: 250)
}

