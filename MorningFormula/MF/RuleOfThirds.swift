//
//  RuleOfThirds.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/2/23.
//

import SwiftUI

struct RuleOfThirds: View {
    
    enum ThirdsLines {
        case firstVertical
        case secondVertical
        case firstHorizontal
        case secondHorizontal
    }
    
    
    var body: some View {
        GeometryReader { geo in
            Group {
                Rectangle()
                    .frame(width: geo.size.width, height: 2)
                    .offset(y: geo.size.height / 3)
                            Rectangle()
                                .frame(width: geo.size.width, height: 2)
                                .offset(y: geo.size.height * (2/3))

                            Rectangle()
                                .frame(width: 2, height: geo.size.height)
                                .offset(x: geo.size.width * (2/3))
                Rectangle()
                    .frame(width: 2, height: geo.size.height)
                    .offset(x: geo.size.width / 3)
            }
        }
//        .ignoresSafeArea()
    }

}

struct RuleOfThirds_Previews: PreviewProvider {
    static var previews: some View {
        RuleOfThirds()
    }
}
