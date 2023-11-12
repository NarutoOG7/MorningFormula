//
//  ColorSelection.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/25/23.
//

import SwiftUI

struct ColorSelection: View {
    
    enum ColorsToChoose: Int, CaseIterable {
        case blue = 0
        case red = 1
        case green = 2
        case orange = 3
        case custom = 4
        
        var color: Color {
            switch self {
            case .blue:
                return Color.blue
            case .red:
                return Color.red
            case .green:
                return Color.green
            case .orange:
                return Color.orange
            case .custom:
                return Color.yellow
            }
        }
    }
    
    @Binding var selectedColor: Color
    
    @State private var predeterminedColorChoice = Color.red
    @State private var customColor: Color? = nil
    
    var body: some View {
        HStack {
            ForEach(ColorsToChoose.allCases, id: \.rawValue) { color in
                if color == .custom {
                    specialCircle
                } else {
                    circleForColor(color.color)
                }
            }
        }
    }
    
    func circleForColor(_ color: Color) -> some View {
        ZStack {
            let isSelected = predeterminedColorChoice == color
            Circle()
                .stroke(color, lineWidth: isSelected ? 5 : 0)
                .frame(width: 35)
            
            Circle()
                .fill(color)
                .frame(width: 25)
        }
        .onTapGesture {
            predeterminedColorChoice = color
            selectedColor = color
            customColor = nil
        }
    }
    
    var specialCircle: some View {
        ZStack(alignment: .leading) {
//            Circle()
//                .stroke(customColor ?? .clear, lineWidth: 4)
//                .frame(width: 35)
//                .offset(x: 1.2)
            ColorPicker("", selection: $customColor.toNonOptional())
                .frame(width: 30)
                
                .onChange(of: customColor) { newValue in
                    if newValue != nil {
                        self.predeterminedColorChoice = .clear
                        if let newValue = newValue {
                            self.selectedColor = newValue
                        }
                    }
                }
                
        }
    }
}

struct ColorSelection_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelection(selectedColor: .constant(.red))
    }
}
