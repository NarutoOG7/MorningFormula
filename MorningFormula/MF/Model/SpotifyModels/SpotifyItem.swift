//
//  SpotifyItem.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/6/23.
//

import Foundation

struct SpotifyItem: Identifiable {
    var id: String
    var name: String
    var artist: [Artist]
}
