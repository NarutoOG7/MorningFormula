//
//  Roboto.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/17/23.
//

import SwiftUI

extension Font {
    
    static func roboto(size: Int, weight: RobotoWeight) -> Font {
        Font.custom("Roboto-\(weight)", size: CGFloat(size))
    }
}

enum RobotoWeight: String {
    case Thin
    case Light
    case Medium
    case Regular
    case Bold
    case Black
    case ThinItalic
    case LightItalic
    case Italic
    case MediumItalic
    case BoldItalic
    case BlackItalic
}
