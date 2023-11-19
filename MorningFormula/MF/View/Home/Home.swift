//
//  Home.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/25/23.
//

import SwiftUI

struct Home: View {
    
    @ObservedObject var viewModel = HomeViewModel.instance
    @ObservedObject var spotifyManager = SpotifyManager.instance
    
    var body: some View {
        let showStressedPrompt = viewModel.stressedOutPrompt != nil
        NavigationStack {
            ZStack {
                List {
                    greeting
                    songRecommendationView
                    imStressedButton
                    
                }
                .scrollContentBackground(.hidden)
                .blur(radius: showStressedPrompt ? 7 : 0)
                .overlay(showStressedPrompt ? Color.gray.opacity(0.3) : Color.clear)
                if showStressedPrompt {
                    StressedOutView(viewModel: viewModel)
                        .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showRecommendedSong, content: {
            SpotifyRecommendationView(song: viewModel.recommendedSong)
        })
    
    }
    
    private var greeting: some View {
        Section {
            Text("Good Evening Spencer")
                .font(.roboto(size: 30, weight: .Medium))
        }
    }
    
    private var songRecommendationView: some View {
        Button {
            spotifyManager.getRecommendedSong { song in
                DispatchQueue.main.async {
                    viewModel.recommendedSong = song
                    viewModel.showRecommendedSong = true
                }
            }
        } label: {
            
            HStack(spacing: 30) {
                Image("SpotifyIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                Text("Check out Spotifys song of the day for you.")
                    .font(.roboto(size: 20, weight: .LightItalic))
            }
        }
    }
    
    private var imStressedButton: some View {
        Section {
            Button(action: {
                viewModel.imStressedTapped()
            }, label: {
                Text("I'm Stressed")
                    .font(.roboto(size: 20, weight: .Medium))
                    .foregroundStyle(.red)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red, lineWidth: 3))
            })
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    Home()
}
