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
    
    /// Get Recommended Song
    func urlRequestForSongRecommendation(accessCode: String, _ formula: Formula) -> URLRequest?
    func getRecommendedSong(accessCode: String, _ formula: Formula, withCompletion completion: @escaping(RecommendedRoot?, Error?) -> Void)
    
    /// Data Task
    func performURLSessionDataTask(request: URLRequest?, withCompletion completion: @escaping(RecommendedRoot?, Error?) -> Void)

}
