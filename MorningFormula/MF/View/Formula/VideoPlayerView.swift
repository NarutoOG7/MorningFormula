//
//  VideoBuilder.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/22/23.
//

import SwiftUI
import AVFoundation
import AVKit
import VideoToolbox

//class H264Encoder: NSObject {
//    
//    enum ConfigurationError: Error {
//        case cannotCreateSession
//        case cannotSetProperties
//        case cannotPrepareToEncode
//    }
//    
//    private static let naluStartCode = Data([UInt8](arrayLiteral: 0x00, 0x00, 0x00, 0x01))
//    var naluHandling: ((Data) -> Void)?
//
//    override init() {
//        super.init()
//    }
//}
//extension H264Encoder: AVCaptureVideoDataOutputSampleBufferDelegate {
//    
//    // a point to receive raw video data
//    func captureOutput(_ output: AVCaptureOutput,
//                       didOutput sampleBuffer: CMSampleBuffer,
//                       from connection: AVCaptureConnection) {
//        
//        //        encode(buffer: sampleBuffer)
//    }
//    
//    private func encode(buffer: CMSampleBuffer) {
//        guard let session = _session,
//              let px = CMSampleBufferGetImageBuffer(buffer) else { return }
//        let timeStamp = CMSampleBufferGetPresentationTimeStamp(buffer)
//        let duration = CMSampleBufferGetDuration(buffer)
//        
//        VTCompressionSessionEncodeFrame(session,
//                                        imageBuffer: px,
//                                        presentationTimeStamp: timeStamp,
//                                        duration: duration,
//                                        frameProperties: nil,
//                                        sourceFrameRefcon: nil,
//                                        infoFlagsOut: nil)
//    }
//}

extension URL {
    func fileSize() -> UInt64? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: self.path)
            if let fileSize = attributes[.size] as? UInt64 {
                return fileSize
            } else {
                return nil
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}

struct VideoPlayerView: View {
        
    @State var url: URL? = nil
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                HStack {
                    Image(uiImage: UIImage(named: "SampleOne")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Image(uiImage: UIImage(named: "SampleTwo")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Image(uiImage: UIImage(named: "SampleThree")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                }
                .onAppear {
                    VideoManager.instance.buildMovie(geo, imagesWithDuration: [
                        (UIImage(named: "SampleOne")!, 13),
                        (UIImage(named: "SampleTwo")!, 13),
                        (UIImage(named: "SampleThree")!, 14)
                    ], outputFileName: "example", totalDuration: 30, frameRate: 1) { url in
                        self.url = url
                        print(url?.fileSize())
                    }
                }
                
                //            if let videoURL = VideoBuilderManager.instance.buildVideo() {
                //        if let videoURL = Bundle.main.url(forResource: "VideoSample", withExtension: "mp4") {
                //            if let videoURL = VideoManager.instance.createPixelBuffer(image: UIImage(named: "SampleTwo")) {
                if let videoURL = url {
                    let _ = print(videoURL)
                    let player = AVPlayer(url: videoURL)
                    VideoPlayer(player: player)
                        .onAppear() {
                            player.play()
                        }
                        .onDisappear() {
                            player.pause()
                        }
                } else {
                    Text("No Video URL")
                }
            }
        }
    }
}
#Preview {
    VideoPlayerView()
}

class VideoBuilderManager {
    
    static let instance = VideoBuilderManager()
    
    @ObservedObject var formulaManager = FormulaManager.instance
    
    func buildVideo() -> AVAssetWriter? {
        guard let videoURL = videoURL() else {
            print("Error making video URL")
            return nil
        }
        return writeVideo(videoURL)
    }
    
    private func videoSettings() -> [String : Any] {
        [
            AVVideoCodecKey : AVVideoCodecType.h264,
            AVVideoWidthKey : 1920,
            AVVideoHeightKey : 1080
        ]
    }
    
    private func videoURL() -> URL? {
        try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("output.mp4")
    }
    
    private func writeVideo(_ videoURL: URL) -> AVAssetWriter? {
        do {
            let videoWriter = try AVAssetWriter(outputURL: videoURL, fileType: .mp4)
            let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings())
            videoWriterInput.expectsMediaDataInRealTime = false
            
            if videoWriter.canAdd(videoWriterInput) {
                videoWriter.add(videoWriterInput)
            }
            
            videoWriter.startWriting()
            videoWriter.startSession(atSourceTime: .zero)
            
            addImages(videoWriterInput)
//            finishWriting(videoWriter)
            
            return videoWriter
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func addImages(_ input: AVAssetWriterInput) {
//        let images = formulaManager.images
        let images = [
            UIImage(named: "SampleOne")!,
            UIImage(named: "SampleTwo")!,
            UIImage(named: "SampleThree")!,
            UIImage(named: "SampleFour")!,
            UIImage(named: "SampleFive")!,
            UIImage(named: "SampleSix")!,
            UIImage(named: "SampleSeven")!

        ]
        var presentationTime = CMTime.zero

        for image in images {
            if let sampleBuffer = CMSampleBufferCreateForImage(image, presentationTime: presentationTime) {
                input.append(sampleBuffer)
            }
            presentationTime = CMTimeAdd(presentationTime, CMTimeMake(value: 2, timescale: 1))

        }
    }
    
    private func finishWriting(_ videoWriter: AVAssetWriter) {
        videoWriter.finishWriting {
            if let error = videoWriter.error {
                print("Error finishing video writing: \(error.localizedDescription)")
            }
        }
    }
    
    private func CMSampleBufferCreateForImage(_ image: UIImage, presentationTime: CMTime) -> CMSampleBuffer? {
        
        var sampleBuffer: CMSampleBuffer?
        
        guard let cgImage = image.cgImage else {
            print("Error with CGImage")
            return nil
        }
        
        var pixelBUffer: CVPixelBuffer?
        let options: [String:Any] = [
            String(kCVPixelBufferCGImageCompatibilityKey) : true,
            String(kCVPixelBufferCGBitmapContextCompatibilityKey) : true
        ]
        
        let status = CVPixelBufferCreate(kCFAllocatorDefault, cgImage.width, cgImage.height, kCVPixelFormatType_32ARGB, options as CFDictionary, &pixelBUffer)
        
        if status != kCVReturnSuccess {
            return nil
        }
        
        if let pixelBUffer = pixelBUffer {
            CVPixelBufferLockBaseAddress(pixelBUffer, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBUffer)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pixelData, width: cgImage.width, height: cgImage.height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBUffer), space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
            
            CVPixelBufferUnlockBaseAddress(pixelBUffer, CVPixelBufferLockFlags(rawValue: 0))
                        
            var timing = CMSampleTimingInfo(duration: CMTime.invalid, presentationTimeStamp: presentationTime, decodeTimeStamp: CMTime.invalid)
            if let formatDescription = createFormatDescription() {
                
                let sampleBufferStatus = CMSampleBufferCreateForImageBuffer(allocator: kCFAllocatorDefault, imageBuffer: pixelBUffer, dataReady: true, makeDataReadyCallback: nil, refcon: nil, formatDescription: formatDescription, sampleTiming: &timing, sampleBufferOut: &sampleBuffer)
                
                if sampleBufferStatus != noErr {
                    print(sampleBufferStatus)
                    return nil
                }
                
                return sampleBuffer
            }
        }
        return sampleBuffer
    }
    
    func createFormatDescription() -> CMFormatDescription? {
        
        var formatDescription: CMFormatDescription?
        
        CMVideoFormatDescriptionCreate(allocator: kCFAllocatorDefault,
                                       codecType: kCMVideoCodecType_H264,
                                       width: Int32(1920), // Set to the desired width
                                       height: Int32(1080), // Set to the desired height
                                       extensions: nil,
                                       formatDescriptionOut: &formatDescription)
        
        return formatDescription
    }
}

