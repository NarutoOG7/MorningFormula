//
//  TimeTrackerView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/29/23.
//

import SwiftUI

struct TimeTrackerView: View {
    
    var events: [(time: Double, label: String)] = [
         (time: 2, label: "Event 1"),
         (time: 5, label: "Event 2"),
         (time: 8, label: "Event 3"),
     ]
    
    var body: some View {
        circle
    }
    
    private var circle: some View {
            BendShape()
                .stroke(lineWidth: 3)
                .frame(width: 300, height: 6)
        
    }
}

#Preview {
    TimeTrackerView()
}

struct BendShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let radius = min(rect.size.width, rect.size.height) / 2
            let center = CGPoint(x: rect.midX, y: rect.midY)
            path.addArc(center: center, radius: radius, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
            path.closeSubpath()
        }
    }
}

struct EventCapsule: View {
    let startTime: Double // Time in hours (0-24)
    let endTime: Double
    let color: Color

    var body: some View {
        Capsule()
            .fill(color)
            .frame(width: 20, height: 30) // Adjust the size as needed
            .rotationEffect(.degrees(startTime * 5))  //Rotate the capsule vertically
            .position(x: 150 * cos(startTime * 15 * .pi / 180) + 150, y: 150 * sin(startTime * 15 * .pi / 180) + 150)
            // Calculate the position based on time (15 degrees per hour)
    }
}

struct CircleMask: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addEllipse(in: rect)
        }
    }
}
