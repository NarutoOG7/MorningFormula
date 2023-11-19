//
//  HomeViewModel.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/18/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    static let instance = HomeViewModel()
    
    @Published var showRecommendedSong = false
    @Published var recommendedSong = SpotifyItem()
    
}

