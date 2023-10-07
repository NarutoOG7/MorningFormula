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
    
    var body: some View {

        VStack {
            accessCodeView
            getSongView
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
            SpotifyManager.inestance.getSongFromEmotion(.excited) { item, error in
                if let item = item {
                    print(item.name)
                }
            }
        } label: {
            Text("Get Song")
        }
    }
    

}

struct SpotifyView_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyView()
    }
}

