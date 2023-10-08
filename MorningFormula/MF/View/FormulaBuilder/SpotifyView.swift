//
//  SpotifyView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/3/23.
//

import SwiftUI
import WebKit

struct SpotifyView: View {
    
    @State var accessCode = ""
    @State var items: [SpotifyItem] = []
    
    var body: some View {

        VStack {
            accessCodeView
            getSongView
            itemsList
        }
            
    }
    
    var accessCodeView: some View{
        VStack {
            getAccessCodeButton
            Text(accessCode)
        }
    }
    
    var getAccessCodeButton: some View {
        Button {
            SpotifyManager.inestance.getAccessToken { token, error in
                if let token = token {
                    print(token)
                }
            }
        } label: {
            Text("Spotify Token")
        }
    }
    
    var getSongView: some View {
        Button {
            SpotifyManager.inestance.getSongFromEmotionUsingComponents(.excited) { item, error in
                if let item = item {
                    items.append(item)
                    print(item.name)
                }
            }
        } label: {
            Text("Get Song")
        }
    }
    
    var itemsList: some View {
        List(items) { item in
            VStack(alignment: .leading) {
                Text(item.name)
                    .fontWeight(.medium)
                    .font(.title3)
                Text(item.firstArtistName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }

}

struct SpotifyView_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyView(items: SpotifyItem.examples)
    }
}

