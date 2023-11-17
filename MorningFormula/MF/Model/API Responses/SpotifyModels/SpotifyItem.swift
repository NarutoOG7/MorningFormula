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
    var artists: [Artist]
    var uri: String
    
    var firstArtistName: String {
        artists.first?.name ?? ""
    }
    
    var stringValue: String {
        "\(name) · \(firstArtistName)"
    }
    
    init(id: String = "", name: String = "", album: SpotifyAlbum = SpotifyAlbum(), artists: [Artist] = [], uri: String = "") {
        self.id = id
        self.name = name
        self.album = album
        self.artists = artists
        self.uri = uri
    }
    
    //MARK: - Examples
        
    static let dream = SpotifyItem(id: "1", name: "Dream", album: SpotifyAlbum.example, artists: [Artist.shaboozey])
    static let rollUp = SpotifyItem(id: "2", name: "Roll Up", album: SpotifyAlbum.example, artists: [Artist.wizKhalifa])
    static let colorsNShapes = SpotifyItem(id: "3", name: "Colors and Shapes", album: SpotifyAlbum.example, artists: [Artist.macMiller])
        
        static let examples = [
            dream, rollUp, colorsNShapes
        ]
}

