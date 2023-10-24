//
//  UpdatedVideoView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/23/23.
//

import SwiftUI
import AVFoundation

class VideoManager {
    static let instance = VideoManager()
    
    let speechSynthesizer = AVSpeechSynthesizer()
    let speechUtterance = AVSpeechUtterance(string: "I'm sick and tired of all of these goddamn snakes on this motherfucking plane! - Samuel Jackson")

 
    func getMovieURL(image: UIImage?) -> URL? {
        guard let uiKitImage = image,
              var staticImage = CIImage(image: uiKitImage)
        else { return nil }
        
        var pixelBuffer: CVPixelBuffer?
        let attributions = [
            kCVPixelBufferCGImageCompatibilityKey : kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey : kCFBooleanTrue
        ] as CFDictionary
        
        let width: Int = Int(staticImage.extent.size.width)
        let height: Int = Int(staticImage.extent.size.height)
        
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attributions, &pixelBuffer)
        
        let context = CIContext()
        if let pxBuffer = pixelBuffer {
            context.render(staticImage, to: pxBuffer)
            
            let assetWriterSettings: [String : Any] = [
                AVVideoCodecKey : AVVideoCodecType.h264,
                AVVideoWidthKey : 400,
                AVVideoHeightKey: 400
            ]
            
            let fileToSave = "example"
            guard let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(fileToSave).mov") else { return nil }
            
            //delete any old file
            do {
                try FileManager.default.removeItem(at: outputURL)
            } catch {
                print("Could not remove file \(error.localizedDescription)")
            }
            //create an assetwriter instance
            guard let assetWriter = try? AVAssetWriter(outputURL: outputURL, fileType: .mov) else {
                abort()
            }
            
            let settingsAssistant = AVOutputSettingsAssistant(preset: .preset1920x1080)?.videoSettings
            let assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: settingsAssistant)
            let assetWriterAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput)
            
            assetWriter.add(assetWriterInput)
            assetWriter.startWriting()
            assetWriter.startSession(atSourceTime: CMTime.zero)
            
            let framesPerSecond = 5
            let totalFrames = 120 * 5
            var frameCount = 0
            
            while frameCount < totalFrames {
                if assetWriterInput.isReadyForMoreMediaData {
                    let frameTime = CMTimeMake(value: Int64(frameCount), timescale: Int32(framesPerSecond))
                    
                    assetWriterAdaptor.append(pxBuffer, withPresentationTime: frameTime)
                    frameCount += 1
                }
            }
            
            assetWriterInput.markAsFinished()
            assetWriter.finishWriting {
                pixelBuffer = nil
                print("Finished video: \(outputURL)")
            }
            return outputURL
        }
        return nil
    }
    
    func deleteOld(_ outputURL: URL) {
        // Delete any old file
        do {
            try FileManager.default.removeItem(at: outputURL)
        } catch {
            print("Could not remove file \(error.localizedDescription)")
        }
    }
    
 
  
    
    func createVideoFromImages(_ geo: GeometryProxy, imagesWithDuration: [(UIImage , Int)], outputFileName: String, totalDuration: Double, frameRate: Int, completion: @escaping (URL?) -> Void) {
        
        var pixelBuffersWithDuration: [(CVPixelBuffer , Int)] = []
        
        for image in imagesWithDuration {
            guard let staticImage = CIImage(image: image.0) else {
                completion(nil)
                return
            }
            
            var pixelBuffer: CVPixelBuffer?
            let attributions = [
                kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
            ] as CFDictionary
            
            let width: Int = Int(staticImage.extent.size.width)
            let height: Int = Int(staticImage.extent.size.height)
            
            CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attributions, &pixelBuffer)
            
            let context = CIContext()
                    
            if let pxBuffer = pixelBuffer {
                context.render(staticImage, to: pxBuffer)
                pixelBuffersWithDuration.append((pxBuffer , image.1))
            }
            
        }
            
            guard !pixelBuffersWithDuration.isEmpty else {
                completion(nil)
                return
            }
            
            guard let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(outputFileName).mov") else {
                completion(nil)
                return
            }
            
        deleteOld(outputURL)
            
            // Create an asset writer instance
            guard let assetWriter = try? AVAssetWriter(outputURL: outputURL, fileType: .mov) else {
                completion(nil)
                return
            }
 
        let assetWriterSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: 1080,
            AVVideoHeightKey: 1920
        ]
        let assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: assetWriterSettings)
            let assetWriterAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput)
        
   
            
            assetWriter.add(assetWriterInput)
            assetWriter.startWriting()
            assetWriter.startSession(atSourceTime: CMTime.zero)
            
            var frameTime = CMTime.zero
            
            for pxBuffer in pixelBuffersWithDuration {
                let frameDuration = CMTimeMake(value: Int64(pxBuffer.1), timescale: Int32(frameRate))
                if assetWriterInput.isReadyForMoreMediaData {
                    assetWriterAdaptor.append(pxBuffer.0, withPresentationTime: frameTime)
                    frameTime = CMTimeAdd(frameTime, frameDuration)
                }
            }
            
            assetWriterInput.markAsFinished()
            assetWriter.finishWriting {
                pixelBuffersWithDuration = []
                completion(outputURL)
            }
        }
    
    func createMovie(_ geo: GeometryProxy, imagesWithDuration: [(UIImage, Int)], outputFileName: String, totalDuration: Double, frameRate: Int, completion: @escaping (URL?) -> Void) {
          let dispatchGroup = DispatchGroup()

        var url: URL?
          dispatchGroup.enter()
          createVideoFromImages(geo, imagesWithDuration: imagesWithDuration, outputFileName: outputFileName, totalDuration: totalDuration, frameRate: frameRate) { videoURL in
              if let videoURL = videoURL {
                  // Your TTS text
                  let ttsText = "Hello, this is a TTS audio example."

                  // Call the createTTSAsset function to generate TTS audio
                  self.createTTSAsset(text: ttsText) { audioURL in
                      if let audioURL = audioURL {
                          print("TTS audio was successfully generated and saved at: \(audioURL)")

                          // Call the addAudioToVideoURL function to merge the video and TTS audio
                          dispatchGroup.enter()
                          self.addAudioToVideoURL(videoURL: videoURL, audioURL: audioURL) { mergedVideoURL in
                              if let mergedVideoURL = mergedVideoURL {
                                  print("Video with TTS audio was successfully created and saved at: \(mergedVideoURL)")
                                  // Now, you have the final video with TTS audio.
                                  url = mergedVideoURL
                                  completion(mergedVideoURL)
                              } else {
                                  print("Error adding TTS audio to the video.")
                                  completion(nil)
                              }
                              dispatchGroup.leave()
                          }
                      } else {
                          print("Error generating TTS audio.")
                          completion(nil)
                      }
                      dispatchGroup.leave()
                  }
              } else {
                  print("Error creating the base video.")
                  completion(nil)
              }
          }

          dispatchGroup.notify(queue: .main) {
              // This closure will be called when all tasks in the dispatch group are completed
              
              completion(url)
          }
      }
    
    
    func addAudioToVideoURL(videoURL: URL, audioURL: URL, completion: @escaping (URL?) -> Void) {
        // Load the video and audio assets
        let videoAsset = AVAsset(url: videoURL)
        let audioAsset = AVAsset(url: audioURL)

        // Create a mutable composition
        let composition = AVMutableComposition()

        // Add the video track
        if let videoAssetTrack = videoAsset.tracks(withMediaType: .video).first {
            let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
            do {
                try videoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAssetTrack, at: CMTime.zero)
            } catch {
                print("Error inserting video track: \(error.localizedDescription)")
                completion(nil)
                return
            }
        }

        // Add the audio track
        if let audioAssetTrack = audioAsset.tracks(withMediaType: .audio).first {
            let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            do {
                try audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: audioAssetTrack, at: CMTime.zero)
            } catch {
                print("Error inserting audio track: \(error.localizedDescription)")
                completion(nil)
                return
            }
        }

        // Create an export session
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            print("Error creating export session")
            completion(nil)
            return
        }

        // Set the output file URL
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         let outputURL = documentsDirectory.appendingPathComponent("EXAMPLESAMPLE.mov") // Output filename with .mov extension
        exportSession.outputURL = outputURL

        // Set the output file type
        exportSession.outputFileType = .mov // or choose an appropriate file type

        // Export the video with audio
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("Video with audio was successfully created and saved at: \(outputURL)")
                completion(outputURL)
            case .failed:
                print("Error exporting the video with audio: \(exportSession.error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            case .cancelled:
                print("Video export was canceled.")
                completion(nil)
            default:
                print("Video export session completed with an unexpected status.")
                completion(nil)
            }
        }
    }
    
    
    func createTTSAsset(text: String, completion: @escaping (URL?) -> Void) {
        // Initialize the speech synthesizer

        let audioEngine = AVAudioEngine()
        let audioPlayerNode = AVAudioPlayerNode()
        let audioMixer = audioEngine.mainMixerNode
         audioEngine.attach(audioPlayerNode)

        do {
            try audioEngine.start()
            print("Audio engine started")
        } catch {
            print("Error starting the audio engine: \(error.localizedDescription)")
            completion(nil)
            return
        }

        audioEngine.connect(audioPlayerNode, to: audioMixer, format: audioPlayerNode.outputFormat(forBus: 0))

        // Create an audio file URL to save the TTS output
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let audioFileURL = documentsDirectory.appendingPathComponent("tts_audio.wav")

        // Prepare an AVAudioFile for writing audio to the file
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
        guard let audioFile = try? AVAudioFile(forWriting: audioFileURL, settings: audioFormat?.settings ?? [:]) else {
            print("Error creating AVAudioFile")
            completion(nil)
            return
        }

        // Set up the speech synthesis completion handler to record audio
        completion(audioFile.url)
        speechSynthesizer.write(speechUtterance) { buffer in
            if let pcmBuffer = buffer as? AVAudioPCMBuffer {
                do {
                    try audioFile.write(from: pcmBuffer)
                    print("Wrote audio buffer to file")
                } catch {
                    print("Error writing audio to file: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
            } else if buffer == nil {
                // Speech synthesis is complete
                completion(audioFileURL)
                print("TTS synthesis complete")
            }
        }
    }


//    func addAudioFileToVideoURL(videoURL: URL, audioURL: URL, completion: @escaping (URL?) -> Void) {
//        let videoAsset = AVURLAsset(url: videoURL)
//        let audioAsset = AVURLAsset(url: audioURL)
//        
//        // Create a mutable composition to hold the video and audio tracks
//        let composition = AVMutableComposition()
//        
//        // Add video and audio tracks to the composition
//        if let videoAssetTrack = videoAsset.tracks(withMediaType: .video).first,
//            let audioAssetTrack = audioAsset.tracks(withMediaType: .audio).first {
//            let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
//            let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
//            
//            do {
//                try videoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAssetTrack, at: CMTime.zero)
//                try audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: audioAsset.duration), of: audioAssetTrack, at: CMTime.zero)
//            } catch {
//                print("Error inserting video and audio tracks: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//        }
//        
//        // Export the final video with merged audio
//        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let outputURL = documentsDirectory.appendingPathComponent("output_video.mov")
//        
//        // Configure the export session
//        exportSession?.outputURL = outputURL
//        exportSession?.outputFileType = .mov
//        
//        exportSession?.exportAsynchronously {
//            switch exportSession?.status {
//            case .completed:
//                print("Video with audio was successfully created and saved.")
//                completion(outputURL)
//            case .failed:
//                print("Error exporting the video with audio: \(exportSession?.error?.localizedDescription ?? "Unknown error")")
//                completion(nil)
//            case .cancelled:
//                print("Video export was canceled.")
//                completion(nil)
//            default:
//                print("Video export session completed with an unexpected status.")
//                completion(nil)
//            }
//        }
//        completion(outputURL)
//    }
    func addAudioFileToVideoURL(videoURL: URL, audioURL: URL, completion: @escaping (URL?) -> Void) {
        let videoAsset = AVURLAsset(url: videoURL)
        
        do {
            // Load the audio asset and verify it
            let audioAsset = try AVURLAsset(url: audioURL, options: nil)
            
            // Verify that the assets can be loaded
            guard let videoAssetTrack = videoAsset.tracks(withMediaType: .video).first,
                  let audioAssetTrack = audioAsset.tracks(withMediaType: .audio).first else {
                print("Video or audio asset tracks not found.")
                completion(nil)
                return
            }
            
            // Create a mutable composition
            let composition = AVMutableComposition()
            
            // Add video and audio tracks to the composition
            let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
            let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            
            // Check if audio duration matches video duration
//            if CMTimeCompare(audioAsset.duration, videoAsset.duration) != 0 {
//                print("Audio and video durations do not match.")
//                completion(nil)
//                return
//            }
            
            do {
                // Insert video and audio tracks
                try videoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAssetTrack, at: CMTime.zero)
                try audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: audioAssetTrack, at: CMTime.zero)
            } catch {
                print("Error inserting video and audio tracks: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Create an export session
            guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
                print("Error creating export session")
                completion(nil)
                return
            }
            
            // Set the output file URL
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let outputURL = documentsDirectory.appendingPathComponent("output_video.mov")
            exportSession.outputURL = outputURL
            
            // Set the output file type
            exportSession.outputFileType = .mov
            
            // Export the video with audio
            exportSession.exportAsynchronously {
                switch exportSession.status {
                case .completed:
                    print("Video with audio was successfully created and saved at: \(outputURL)")
                    completion(outputURL)
                case .failed:
                    print("Error exporting the video with audio: \(exportSession.error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                case .cancelled:
                    print("Video export was canceled.")
                    completion(nil)
                default:
                    print("Video export session completed with an unexpected status.")
                    completion(nil)
                }
            }
            completion(outputURL)
        } catch {
            print("Error loading the audio asset: \(error.localizedDescription)")
            completion(nil)
        }
    }


    func buildMoveWithAudioFile(_ geo: GeometryProxy, imagesWithDuration: [(UIImage, Int)], outputFileName: String, totalDuration: Double, frameRate: Int, completion: @escaping (URL?) -> Void) {
        
        createVideoFromImages(geo, imagesWithDuration: imagesWithDuration, outputFileName: outputFileName, totalDuration: totalDuration, frameRate: frameRate) { videoURL in
            if let videoURL = videoURL {
                if let audioURL = Bundle.main.url(forResource: "hold-on-to-your-butts", withExtension: "mp3") {
                    self.addAudioFileToVideoURL(videoURL: videoURL, audioURL: audioURL) { finalURL in
                        if let finalURL = finalURL {
                            completion(finalURL)
                        }
                    }
                }
            }
        }
    }
    
    func buildMovie(_ geo: GeometryProxy, imagesWithDuration: [(UIImage, Int)], outputFileName: String, totalDuration: Double, frameRate: Int, completion: @escaping (URL?) -> Void) {
        
        self.createTTSAsset(text: "Hold on to your butts") { audioURL in
            if let audioURL = audioURL {
                print(audioURL)
                self.createVideoFromImages(geo, imagesWithDuration: imagesWithDuration, outputFileName: outputFileName, totalDuration: totalDuration, frameRate: frameRate) { videoURL in
                    if let videoURL = videoURL {
                        self.addAudioFileToVideoURL(videoURL: videoURL, audioURL: audioURL) { finalURL in
                            if let finalURL = finalURL {
                                completion(finalURL)
                            }
                        }
                    }
                }
            }
        }
    }

    
    func basicTTSAsset(text: String, completion: @escaping (URL?) -> Void) {
        // Initialize the speech synthesizer
        let speechUtterance = AVSpeechUtterance(string: text)

        // Create an audio file URL to save the TTS output
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let audioFileURL = documentsDirectory.appendingPathComponent("tts_audio.wav")

        // Prepare an AVAudioFile for writing audio to the file
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
        
        guard let audioFile = try? AVAudioFile(forWriting: audioFileURL, settings: audioFormat?.settings ?? [:]) else {
            print("Error creating AVAudioFile")
            completion(nil)
            return
        }

        // Set up the speech synthesis completion handler to record audio
        speechSynthesizer.write(speechUtterance) { buffer in
            if let pcmBuffer = buffer as? AVAudioPCMBuffer {
                do {
                    try audioFile.write(from: pcmBuffer)
                } catch {
                    print("Error writing audio to file: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
            } else if buffer == nil {
                // Speech synthesis is complete
                completion(audioFileURL)
            }
        }
    }
    
    func urlForTTS(completion: @escaping(URL?) -> Void) {
        let ttsText = "Hello, this is a TTS audio example."
        basicTTSAsset(text: ttsText) { audioURL in
            if let audioURL = audioURL {
                print("TTS audio was successfully generated and saved at: \(audioURL)")
                // You can use the audioURL for other purposes.
                completion(audioURL)
            }
        }
    }
}

struct UpdatedVideoView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    UpdatedVideoView()
}
