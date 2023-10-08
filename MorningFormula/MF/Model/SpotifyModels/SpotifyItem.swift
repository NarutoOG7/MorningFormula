//
//  SpotifyItem.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/6/23.
//

import Foundation

struct SpotifyItem: Codable, Identifiable {
    var id: String
    var name: String
    var album: SpotifyAlbum
    var artist: [Artist]
    
    var firstArtistName: String {
        artist.first?.name ?? ""
    }
    
    //MARK: - Examples
        
    static let dream = SpotifyItem(id: "1", name: "Dream", album: SpotifyAlbum.example, artist: [Artist.shaboozey])
    static let rollUp = SpotifyItem(id: "2", name: "Roll Up", album: SpotifyAlbum.example, artist: [Artist.wizKhalifa])
    static let colorsNShapes = SpotifyItem(id: "3", name: "Colors and Shapes", album: SpotifyAlbum.example, artist: [Artist.macMiller])
        
        static let examples = [
            dream, rollUp, colorsNShapes
        ]
}
