//
//  AVNarratorView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/11/23.
//

import SwiftUI
import AVFoundation

struct AVNarratorView: View {
    
    let voices = AVSpeechSynthesisVoice.speechVoices()
    let synthesizer = AVSpeechSynthesizer()
    
    @State var selectedNarrator = "Majed"

    @ObservedObject var userStore = UserManager.instance
    
    var body: some View {
        HStack {
            picker
            testButton
        }
    }
    
    var picker: some View {
        Picker("", selection: $selectedNarrator) {
            ForEach(voices, id: \.name) { voice in
                Text(voice.name)
            }
        }
    }
    
    var testButton: some View {
        let utterance = AVSpeechUtterance(string: "Hello \(userStore.userName), my name is \(selectedNarrator)")
        
        return Button {
            if let voice = voiceFromName(selectedNarrator) {
                utterance.voice = voice
                utterance.rate = 0.5
                synthesizer.speak(utterance)
            }
        } label: {
            Image(systemName: "speaker.wave.3")
        }
        
    }
    
    func voiceFromName(_ name: String) -> AVSpeechSynthesisVoice? {
        voices.first(where: { $0.name == selectedNarrator })
    }
}

struct AVNarratorView_Previews: PreviewProvider {
    static var previews: some View {
        AVNarratorView()
    }
}
