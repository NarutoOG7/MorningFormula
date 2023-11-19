//
//  CustomCurvedBar.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/18/23.
//

import SwiftUI

struct CustomCurvedBar: View {
    var body: some View {
        GeometryReader { geo in
            
            Path { path in
//                let leftTop = CGPoint(x: 50, y: 50)
//                let leftBott = CGPoint(x: 50, y: 125)
//                let rightBott = CGPoint(x: 350, y: 125)
//                let rightTop = CGPoint(x: 350, y: 50)
//                let rightCurveStart = CGPoint(x: 250, y: 50)       
                
//                let leftTop = CGPoint(x: 20, y: 0)
//                let leftBott = CGPoint(x: 20, y: 70)
//                let rightBott = CGPoint(x: 380, y: 70)
//                let rightTop = CGPoint(x: 380, y: 0)
//                let rightCurveStart = CGPoint(x: 250, y: 0)
//                let arcCenter = CGPoint(x: 200, y: 0)
                
                let twelfthWidth = geo.size.width / 12
                let leftTop = CGPoint(x: twelfthWidth, y: 0)
                let leftBott = CGPoint(x: twelfthWidth, y: 70)
                let rightBott = CGPoint(x: geo.size.width - twelfthWidth , y: 70)
                let rightTop = CGPoint(x: geo.size.width - twelfthWidth, y: 0)
                let rightCurveStart = CGPoint(x: 250, y: 0)
                let arcCenter = CGPoint(x: 200, y: 0)

                path.move(to: leftTop)
                path.addLine(to: leftBott)
                path.addLine(to: rightBott)
                path.addLine(to: rightTop)
                path.addLine(to: rightCurveStart)
                path.addArc(center: arcCenter, radius: 35, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: leftTop)



//                path.addArc(center: CGPoint(x: geo.size.width / 2, y: 0), radius: 50, startAngle: Angle(degrees: 45), endAngle: Angle(degrees: 90), clockwise: true)
//                path.addLine(to: CGPoint(x: geo.size.width / 2, y: 0))
//                path.addLine(to: CGPoint(x: geo.size.width / 2, y: 100))
//                path.addLine(to: CGPoint(x: 0, y: 100))
            }
            .stroke(lineWidth: 2)
//            .padding(.horizontal)
        }
    }
}

struct MyShape : Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()

//        p.addLine(to: CGPoint(x: 100, y: 100))
        p.addArc(center: CGPoint(x: 100, y:100), radius: 50, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: true)
        p.addLine(to: CGPoint(x: 200, y: 200))

        return p
//        return p.strokedPath(.init(lineWidth: 3, dash: [5, 3], dashPhase: 10))
    }
}

#Preview {
    CustomCurvedBar()
}
