//
//  TTSViewTryOut.swift
//  MorningFormula
//
//  Created by Spencer Belton on 9/29/23.
//

import SwiftUI
import AVFoundation

struct Voice: Identifiable {
    
    let id: String
    let name: String
    let gender: Int
    let language: String
    let isAVVoice: Bool
    
    init(avVoice: AVSpeechSynthesisVoice) {
        id = avVoice.identifier
        name = avVoice.name
        gender = avVoice.gender.rawValue
        language = avVoice.language
        isAVVoice = true
    }
    
    func speak(_ text: String, rate: Float = 1) {
        
        if isAVVoice {
            avVoiceSpeech(text, rate: rate)
        }
    }
    
    private func avVoiceSpeech(_ text: String, rate: Float) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = rate
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func genderFromID(_ id: Int) -> String {
        id == 0 ? "male" : "female"
    }
}

class TTSManager: ObservableObject {
    static let instance = TTSManager()
    
    @Published var text = "I'm sick and tired of all thes goddamn snakes on this motherfucking plane."
    
    func speak() {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.1
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

struct TTSViewTryOut: View {
    let synthesizer = AVSpeechSynthesizer()
    let utteranceOne = AVSpeechUtterance(string: "I'm sick and tired")
    let utteranceTwo = AVSpeechUtterance(string: "of all these goddamn snakes on this mother-fucking plane.")
    var body: some View {
        Button {
//            printVoices()
            utteranceOne.voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.compact.en-ZA.Tessa")
            utteranceTwo.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.Cellos")
            utteranceOne.rate = 0.4
            utteranceTwo.rate = 0.5

            synthesizer.speak(utteranceOne)
            synthesizer.speak(utteranceTwo)
        } label: {
        Text("Speak")
        }

    }
    
    func printVoices() {
        let voices = AVSpeechSynthesisVoice.speechVoices()

        for voice in voices {
            let id = "id: \(voice.identifier),"
            let name = "name: \(voice.name)"
            let gender = "gender: \(voice.gender)"
            let language = "language: \(voice.language)"
            let quality = "quality: \(voice.quality)"
            print(id + "\n" +
                  name + "\n" +
                  gender + "\n" +
                  language + "\n" +
                  quality + "\n"
                  )
        }
    }
}

struct TTSViewTryOut_Previews: PreviewProvider {
    static var previews: some View {
        TTSViewTryOut()
    }
}
