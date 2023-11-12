//
//  CapsuleProgressView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/10/23.
//

import SwiftUI

struct CapsuleProgressView: View {
    
    var progress: Int
    let pageCount: Int
    
    var body: some View {
        let pagesAsRange = 1...pageCount
        let pages = Array(pagesAsRange)
        GeometryReader { geometry in
            HStack(spacing: 2) {
                Spacer()
                ForEach(pages, id: \.self) { index in
                        Capsule()
                            .frame(width: geometry.size.width / 10,
                                   height: 10)
                            .foregroundColor(index <= self.progress ? .blue : .gray)
                            .clipped()
                }
                Spacer()
            }
        }
    }
}



struct CapsuleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleProgressView(progress: 2, pageCount: 3)
    }
}
