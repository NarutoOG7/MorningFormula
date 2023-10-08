//
//  SpotifyAlbum.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/7/23.
//

import Foundation

struct SpotifyAlbum: Codable Identifiable {
    
    var id: String
    var image: SpotifyImage
    
    static let example = SpotifyAlbum(id: "example", image: SpotifyImage.example)
}
