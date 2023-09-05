//
//  MonthView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/2/23.
//

import SwiftUI
import SwiftUICalendar

struct MonthView: View {
    var body: some View {
        GeometryReader { geo in
            InformationWithSelectionView()
//                .frame(height: geo.size.height / 1.5)
                .padding(.horizontal, 20)
        }
            
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthView()
    }
}
