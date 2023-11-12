//
//  Artist.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/6/23.
//

import Foundation

struct Artist: Codable, Identifiable {
    
    var id: String
    var name: String
    
    static let shaboozey = Artist(id: "1", name: "Shaboozey")
    static let wizKhalifa = Artist(id: "2", name: "Wiz Khalifa")
    static let macMiller = Artist(id: "3", name: "Mac Miller")

}
