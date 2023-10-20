//
//  CodableColor.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/12/23.
//

import SwiftUI

struct CodableColor: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double

    init(_ color: UIColor) {
        var redValue: CGFloat = 0.0
        var greenValue: CGFloat = 0.0
        var blueValue: CGFloat = 0.0
        var alphaValue: CGFloat = 0.0
        color.getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: &alphaValue)

        red = Double(redValue)
        green = Double(greenValue)
        blue = Double(blueValue)
        alpha = Double(alphaValue)
    }

    func color() -> Color {
        return Color(uiColor: UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)))
    }
}
