//
//  SpotifyAlbum.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/7/23.
//

import Foundation

struct SpotifyRoot: Codable {
    var tracks: Track
}

struct SpotifyAlbum: Codable, Identifiable {
    
    var id: String
    var images: [SpotifyImage]
    
    static let example = SpotifyAlbum(id: "example", images: [SpotifyImage.example])
}
