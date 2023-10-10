//
//  SpotifyView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/3/23.
//

import SwiftUI
import WebKit

struct SpotifyView: View {
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    @ObservedObject var spotifyManager = SpotifyManager.instance
    @ObservedObject var formulaManager = FormulaManager.instance

    var body: some View {

        VStack {
            accessCodeView
//            HStack {
//                searchBar
//                searchButton
//            }
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(.blue, lineWidth: 2)
//                )
//            if spotifyManager.pauseSearch {
//                ProgressView()
//            } else {
            AnyGroupInputView(title: "Spotify", subTitle: "Add songs", textFieldPlaceholder: "ex. Dream", onTextChange: { newInput in
                if newInput.count > 2 {
                    spotifyManager.searchSongs(newInput)
                }
            }, submissions: $formulaManager.favoriteSongTitles, autoFillOptions: $spotifyManager.songTitlesForInputGroup)
//            AnyGroupInputView(title: "Spotify", subTitle: "Add songs", textFieldPlaceholder: "ex. Dream", onTextChange: <#(String) -> Void#>, submissions: $spotifyManager.songTitlesForInputGroup)
//                itemsList
//            }
        }
            
    }
    
    var accessCodeView: some View {
            getAccessCodeButton
    }
    
    var getAccessCodeButton: some View {
        Button {
            spotifyManager.getAccessCodeTapped()
        } label: {
            Text("Spotify Token")
        }
    }
    
    var itemsList: some View {
        List(spotifyManager.songs) { song in
            VStack(alignment: .leading) {
                Text(song.name)
                    .foregroundColor(.purple)
                    .fontWeight(.medium)
                    .font(.title3)
                Text(song.firstArtistName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .frame(minHeight: minRowHeight * 10)
    }
    
    var searchBar: some View {
        TextField("", text: $spotifyManager.searchInput)
    }
    
    var searchButton: some View {
        Button {
            spotifyManager.searchSongs(spotifyManager.searchInput)
        } label: {
            Text("Search")
        }

    }

}

struct SpotifyView_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyView()
//        (items: SpotifyItem.examples)
    }
}

