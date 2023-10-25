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

    var recordingPath:  URL {
        let soundName = "Brianna.caf"
         // I've tried numerous file extensions.  .caf was in an answer somewhere else.  I would think it would be
         // .pcm, but that doesn't work either.
         
         // Local Directory
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         return paths[0].appendingPathComponent(soundName)
     }
 
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
    
 
  
    
    func createVideoFromImages(imagesWithDuration: [FormulaImage : Int], outputFileName: String, frameRate: Int, completion: @escaping (URL?) -> Void) {
        
        var pixelBuffersWithDuration: [(CVPixelBuffer , Int)] = []
        
        for image in imagesWithDuration {
            guard let uiImage = image.key.image(),
                  let staticImage = CIImage(image: uiImage) else {
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
    
    func createMovie(imagesWithDuration: [FormulaImage : Int], outputFileName: String, totalDuration: Double, frameRate: Int, completion: @escaping (URL?) -> Void) {
          let dispatchGroup = DispatchGroup()

        var url: URL?
          dispatchGroup.enter()
          createVideoFromImages(imagesWithDuration: imagesWithDuration, outputFileName: outputFileName, frameRate: frameRate) { videoURL in
              if let videoURL = videoURL {
                  // Your TTS text
                  let ttsText = "Hello, this is a TTS audio example."

                  // Call the createTTSAsset function to generate TTS audio
                  self.saveTTSAudio(formula: Formula.example) { audioURL in
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
        let timestamp = Int(Date().timeIntervalSince1970)
         let outputURL = documentsDirectory.appendingPathComponent("Example\(timestamp).mov") // Output filename with .mov extension
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

    func buildMovie(imagesWithDuration: [FormulaImage : Int], outputFileName: String, totalDuration: Double, frameRate: Int, completion: @escaping (URL?) -> Void) {
        
        self.saveTTSAudio(formula: Formula.example) { audioURL in
            if let audioURL = audioURL {
                print(audioURL)
                self.createVideoFromImages(imagesWithDuration: imagesWithDuration, outputFileName: outputFileName, frameRate: frameRate) { videoURL in
                    if let videoURL = videoURL {
                        self.addAudioToVideoURL(videoURL: videoURL, audioURL: audioURL) { finalURL in
                            if let finalURL = finalURL {
                                completion(finalURL)
                            }
                        }
                    }
                }
            }
        }
    }
        
    private func saveTTSAudio(formula: Formula, completion: @escaping(URL?) -> Void) {
         
        let utterance = AVSpeechUtterance(string: formula.chatResponse)
        utterance.voice = AVSpeechSynthesisVoice(identifier: formula.narratorID)
         utterance.rate = 0.50
         
         // Only create new file handle if `output` is nil.
         var output: AVAudioFile?
         
         speechSynthesizer.write(utterance) { [self] (buffer: AVAudioBuffer) in
             guard let pcmBuffer = buffer as? AVAudioPCMBuffer else {
                 fatalError("unknown buffer type: \(buffer)")
             }
             if pcmBuffer.frameLength == 0 {
                 // Done
                 debugPrint("Done")
                 completion(recordingPath)
             } else {
                 // append buffer to file
                 do{
                     if output == nil {
                         try  output = AVAudioFile(
                             forWriting: recordingPath,
                             settings: pcmBuffer.format.settings,
                             commonFormat: pcmBuffer.format.commonFormat,
                             interleaved: false)
                     }
                     try output?.write(from: pcmBuffer)
                 }catch {
                     print(error.localizedDescription)
                 }
             }
         }
     }
    
    func formulate(formula: Formula, frameRate: Int, withCompletion completion: @escaping(URL?) -> Void) {
        createVideoFromImages(imagesWithDuration: formula.imagesWithDuration, outputFileName: formula.id, frameRate: frameRate) { videoURL in
            if let videoURL = videoURL {
                self.saveTTSAudio(formula: formula) { audioURL in
                    if let audioURL = audioURL {
                        self.addAudioToVideoURL(videoURL: videoURL, audioURL: audioURL) { finalURL in
                            completion(finalURL)
                        }
                    }
                }
            }
        }
    }
}

/*
 1. Build Formula
 2. Get ChatGPT Response
 3. Build Video from images and chatGPT response TTS
 4. Play Video
 */
