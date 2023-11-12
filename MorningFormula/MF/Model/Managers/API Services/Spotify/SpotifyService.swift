//
//  SpotifyService.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/8/23.
//

import SwiftUI

protocol SpotifyService {
    
    /// Token
    func getAccessToken(withCompletion completion: @escaping(String?, Error?) -> Void)
        
    /// Search
    func getSongFromSearch(accessCode: String, _ query: String, withCompletion completion: @escaping(SpotifyRoot?, Error?) -> Void)
    func urlRequestFromQuery(accessCode: String, _ query: String) -> URLRequest?

}
