//
//  SpotifyImage.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/7/23.
//

import Foundation

struct SpotifyImage: Codable {
    
    var urlString: String
    var width: Int
    var height: Int
    
    static let example = SpotifyImage(urlString: "example.url", width: 300, height: 300)
}
