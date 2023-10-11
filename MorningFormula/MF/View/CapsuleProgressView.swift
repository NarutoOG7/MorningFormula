//
//  CapsuleProgressView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/10/23.
//

import SwiftUI

struct CapsTangle: View {
        var body: some View {
            ZStack {
                Capsule()
                    .frame(width: 200, height: 100)
                    .foregroundColor(.blue)
                    .offset(x: -50, y: 0)
                    .clipShape(Capsule(style: .continuous))
                
                Rectangle()
                    .frame(width: 200, height: 100)
                    .foregroundColor(.green)
                    .offset(x: 25, y: 0)
                    .clipShape(Rectangle())
            }
        }
}

struct CapsuleProgressView: View {
    
    var progress: Int
    let pageCount: Int
    
    var body: some View {
        let pagesAsRange = 1...pageCount
        let pages = Array(pagesAsRange)
        GeometryReader { geometry in
            HStack(spacing: 2) {
                ForEach(pages, id: \.self) { index in
                    if index - 1 == pages.indices.first ||
                        index - 1 == pages.indices.last {
                        CapsTangle()
                            .frame(width: geometry.size.width / 10,
                                   height: 10)
                            .foregroundColor(index <= self.progress ? .blue : .gray)
                            .clipped()
                    } else {
                        Rectangle()
                            .frame(width: geometry.size.width / 10,
                                   height: 10)
                            .foregroundColor(index <= self.progress ? .blue : .gray)
                    }
                }
            }
        }
    }
}

struct TrapezoidalCapsule: Shape {
    var progress: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width / 10
        let height = rect.height

        for i in 0..<10 {
            let x = CGFloat(i) * width
            let capsuleWidth = width - 2

            if i == 4 || i == 5 {
                let yOffset = CGFloat((progress - 0.5).magnitude * 40)
                path.move(to: CGPoint(x: x, y: rect.midY - height / 2 + yOffset))
                path.addLine(to: CGPoint(x: x + capsuleWidth, y: rect.midY - height / 2 + yOffset))
                path.addLine(to: CGPoint(x: x + capsuleWidth, y: rect.midY + height / 2 - yOffset))
                path.addLine(to: CGPoint(x: x, y: rect.midY + height / 2 - yOffset))
            } else {
                let yOffset: CGFloat = 0
                path.addRoundedRect(in: CGRect(x: x, y: rect.midY - height / 2 + yOffset, width: capsuleWidth, height: height - yOffset), cornerSize: CGSize(width: 10, height: 10))
            }
        }

        return path
    }
}

struct CapsuleProgressView_Previews: PreviewProvider {
    static var previews: some View {
//        CapsuleProgressView(progress: 2, pageCount: 3)
        CapsTangle()
    }
}
