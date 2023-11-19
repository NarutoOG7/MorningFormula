//
//  SpotifyRecommendationView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 11/8/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SpotifyRecommendationView: View {
        
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var spotifyManager = SpotifyManager.instance
    
    var song: SpotifyItem
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                GeometryReader { geo in
                    VStack(alignment: .center, spacing: 10) {
                        albumArt(geo)
                            .padding(.bottom, 50)
                        songTitle
                        artistName
                        Spacer()
                        if spotifyManager.isSpotifyInstalledOnDevice() {
                            openInSpotifyButton
                                .padding(.vertical, 30)
                        }
                    }
                    .padding()
                    /// Makes View listen to alignment in stack by limiting container size
                    .frame(width: geo.size.width, height: geo.size.height)
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        backButton
                    }
                }
            }
        }
    }
    
    private var songTitle: some View {
        Text(song.name)
//        Text("Song Name")
            .font(.title3)
            .bold()
    }

    private var artistName: some View {
        Text(song.firstArtistName)
//        Text("Artist Name")
            .font(.subheadline)
            .foregroundStyle(.gray)

    }
    
    private func albumArt(_ geo: GeometryProxy) -> some View {
        WebImage(url: URL(string: song.album.images.first?.url ?? ""))
//        WebImage(url: URL(string: "https://i.scdn.co/image/ab67616d0000b273e9afc4cd4b7d009ea37540d7"))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .shadow(radius: 7, x: 0, y: 5)
            .frame(width: geo.size.width / 1.5)

    }
    
    
    private var openInSpotifyButton: some View {
        Button {
            spotifyManager.openSpotify(uri: song.uri)
        } label: {
            Text("Open in Spotify")
                .foregroundStyle(.green)
        }

    }
    
    private var backButton: some View {
        Button {
            self.dismiss()
        } label: {
            Image(systemName: "x.circle")
                .foregroundStyle(.gray.opacity(0.6))
                .font(.title)
        }

    }
}

#Preview {
    SpotifyRecommendationView(song: SpotifyItem.colorsNShapes)
}
