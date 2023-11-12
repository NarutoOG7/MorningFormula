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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    @ObservedObject var spotifyManager = SpotifyManager.instance
    @ObservedObject var formulaManager = FormulaManager.instance
    
    let title = "What are your favorite songs?"
    let subTitle = "We will use these to recommend you songs.\n(optional)"

    func textChanged(_ text: String) {
        if text.count > 2 {
            spotifyManager.searchSongs(text)
        }
    }
    
    var body: some View {

        VStack {
            AnyGroupInputView(
                title: title,
                subTitle: subTitle,
                textFieldPlaceholder: "ex. Dream",
                onTextChange: textChanged(_:),
                submissions: $formulaManager.favoriteSongTitles,
                autoFillOptions: $spotifyManager.songTitlesForInputGroup)

            Spacer(minLength: 100)


        }
        .navigationBarBackButtonHidden()
        
        .task {
            spotifyManager.getAccessCodeTapped()
        }
    }


}

struct SpotifyView_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyView()
            .padding()
//        (items: SpotifyItem.examples)
    }
}

