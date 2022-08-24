//
//  SwirlProcessing.swift
//  InStore Console
//
//  Created by Atirek Pothiwala on 09/05/20.
//  Copyright © 2020 GetNatty. All rights reserved.
//

import AVFoundation
import AVKit
import Metal
import UIKit

protocol VideoProcessDelegate {
    func onVideoProcessStart()
    func onVideoProcessEnd()
    func onVideoProcessError(_ message: String)
    func onVideoProcessErrorMessage(_ message: String)
    func onVideoProcessResult(_ processedUrl: URL)
}

let kImageBitsPerComponent: Int = 8
let kImageBitsPerPixel: Int = 32
let kImageBytesCount: Int = 4

let kMediaContentDefaultScale: CGFloat = 1
let kMediaContentTimeValue: Int64 = 1
let kMediaContentTimeScale: Int32 = 30

class VideoProcessing: NSObject {
        
    fileprivate static let shared: VideoProcessing = {
        let instance = VideoProcessing()
        // Do any additional Configuration
        return instance
    }()
    
    public enum ProcessingType: Int {
        case slowMotion = 0
        case slowMotionWithWatermark = 1
        case fastMotion = 2
        case fastMotionWithWatermark = 3
        case compress = 4
        case compressWithWatermark = 5
    }
    
    private var delegate: VideoProcessDelegate?
    private var addWatermark: Bool = true
    public static var checkImageFlag: Int = 0
    public static var imageData: Data = Data()
    
    func endProcess(_ resultUrl: URL?, errorMessage: String) {
        self.delegate?.onVideoProcessEnd()
        if let url = resultUrl {
            self.delegate?.onVideoProcessResult(url)
        } else {
            self.delegate?.onVideoProcessError(errorMessage)//Something went wrong while processing video, try again.
        }
    }
    
    func endProcessWithMessage(errorMessage: String) {
        self.delegate?.onVideoProcessEnd()
        self.delegate?.onVideoProcessErrorMessage(errorMessage)
    }

    func startProcess() {
        self.delegate?.onVideoProcessStart()
    }
    
    private override init() {
        super.init()
    }
    
    public static func convert(_ delegate: VideoProcessDelegate?, _ asset: AVAsset, processType: ProcessingType) {
        
        DispatchQueue.main.async {
            
            self.shared.delegate = delegate
            switch(processType){
            case .slowMotionWithWatermark:
                self.shared.addWatermark = false // 17-Dec-21 set false for not add watermark
                self.shared.controlMotion(asset, 2.0)
                break
            case .slowMotion:
                self.shared.addWatermark = false
                self.shared.controlMotion(asset, 2.0)
                break
            case .fastMotion:
                self.shared.addWatermark = false
                self.shared.controlMotion(asset, 0.5)
                break
            case .fastMotionWithWatermark:
                self.shared.addWatermark = false // 17-Dec-21 set false for not add watermark
                self.shared.controlMotion(asset, 0.5)
                break
            case .compress:
                self.shared.addWatermark = false
                self.shared.compress(asset)
                break
            case .compressWithWatermark:
                self.shared.addWatermark = false // 17-Dec-21 set false for not add watermark
                self.shared.compress(asset)
                break
            }
            
        }
    }

    fileprivate func controlMotion(_ asset: AVAsset, _ videoScaleFactor: Double){
                
        do {
            self.startProcess()
            
            let mixComposition = AVMutableComposition.init()
            let timeRange = CMTimeRange.init(start: CMTime.zero, duration: asset.duration)
            let duration = asset.duration
            let value = CMTimeValue.init(Double(duration.value) * videoScaleFactor)
            let timeScale = duration.timescale
            let toDuration = CMTime.init(value: value, timescale: timeScale)
            
            let videoTracks = asset.tracks(withMediaType: .video)
            if videoTracks.count > 0 {
                let track = videoTracks[0]
                let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
                try compositionVideoTrack?.insertTimeRange(timeRange, of: track, at: .zero)
                compositionVideoTrack?.scaleTimeRange(timeRange, toDuration: toDuration)
                compositionVideoTrack?.preferredTransform = track.preferredTransform
            }
            
            let audioTracks = asset.tracks(withMediaType: .audio)
            if audioTracks.count > 0 {
                let track = audioTracks[0]
                let compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                try compositionAudioTrack?.insertTimeRange(timeRange, of: track, at: .zero)
                compositionAudioTrack?.scaleTimeRange(timeRange, toDuration: toDuration)
            }
            
            self.compress(mixComposition)
            
        } catch {
            VideoProcessing.checkLog(error)
            self.endProcess(nil, errorMessage: "Something went wrong while processing video, try again.")
        }
        
    }
    
    fileprivate func compress(_ asset: AVAsset) {
        self.startProcess()
        
        guard let assetSizeBytes = asset.tracks(withMediaType: .video).first?.totalSampleDataLength else {
            self.endProcess(nil, errorMessage: "Something went wrong while processing video, try again.")
            return
        }
        
        let assetSizeMegaBytes = Double(assetSizeBytes / (1024 * 1024))
        VideoProcessing.checkLog("Original File Size: \(assetSizeMegaBytes) MB")
        let isBigSize = assetSizeMegaBytes > 150 //AVAssetExportPreset960x540
        
        guard isBigSize == false else {
            self.endProcessWithMessage(errorMessage: "Video size is too big.")
            return
        }
        
        print("From isBigSize : ", isBigSize)
        //AVAssetExportPreset960x540
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: isBigSize ? AVAssetExportPreset640x480 : AVAssetExportPresetHighestQuality) else {
            self.endProcess(nil, errorMessage: "Something went wrong while processing video, try again.")
            return
        }
        
        if self.addWatermark {
            exportSession.videoComposition = self.getWatermark(asset)
        } else {
            VideoProcessing.checkLog("Watermark not added")
        }
        
        let uuid = UUID().uuidString.lowercased()
        let uuidFilter = uuid.replacingOccurrences(of: "-", with: "")
        let swirlVideoName = uuidFilter + ".mp4"
        print("From Video Name : ", swirlVideoName)
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let compressedUrl = paths[0].appendingPathComponent(swirlVideoName)
        
        //let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
        //print("From compress compressedUrl : ", compressedUrl)
        
        if FileManager.default.fileExists(atPath: compressedUrl.path) {
            do {
                try FileManager.default.removeItem(at: compressedUrl)
            } catch {
                VideoProcessing.checkLog(error)
            }
        }
        
        exportSession.canPerformMultiplePassesOverSourceMediaData = true
        exportSession.timeRange = CMTimeRange.init(start: .zero, duration: asset.duration)
        exportSession.outputURL = compressedUrl
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously {
            
            if let compressedUrl = exportSession.outputURL {
                print("From compress compressedUrl :: ", compressedUrl)
                VideoProcessing.checkLog("Compressed File Size: \(compressedUrl.sizePerMB()) MB")
                self.endProcess(compressedUrl, errorMessage: "Something went wrong while processing video, try again.")
            } else  {
                self.endProcess(nil, errorMessage: "Something went wrong while processing video, try again.")
            }
        }
    }
    
    func createPath() -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = URL(fileURLWithPath: paths.first!)
        let url = documentDirectory.appendingPathComponent("FinalVideo.mp4")

        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }

        return url
    }
    
    private static func checkLog(_ value: Any) {
        debugPrint("video_processing>>", value)
    }
    
    private func getWatermark(_ avAsset: AVAsset) -> AVMutableVideoComposition? {
        
        guard let videoTrack = avAsset.tracks(withMediaType: .video).first else {
            VideoProcessing.checkLog("Watermark Not Added")
            return nil
        }
        
        var waterMark = UIImage()
        
        if VideoProcessing.checkImageFlag == 0 {
            guard let watermark = UIImage(named: "swirl_logo_white") else {
                VideoProcessing.checkLog("Watermark Not Found")
                return nil
            }
            waterMark = watermark
        } else {
            if VideoProcessing.imageData.isEmpty {
                guard let watermark = UIImage(named: "swirl_logo_white") else {
                    VideoProcessing.checkLog("Watermark Not Found")
                    return nil
                }
                waterMark = watermark
            } else {
                waterMark = UIImage(data: VideoProcessing.imageData)!
            }
        }
        
        let size = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
        let videoSize = CGSize.init(width: abs(size.width), height: abs(size.height))
        let videoFrame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        
        let imageView = UIImageView(image: waterMark)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(gestureRecognizer)
        imageView.isUserInteractionEnabled = true
        
        //Adding the image layer
        let watermarkLayer = CALayer()
        watermarkLayer.contents = imageView.image?.cgImage //waterMark.cgImage
        
        VideoProcessing.checkLog("Video Size -> \(videoSize.width) : \(videoSize.height)")
        
        let newWidth = videoSize.width * 0.20 //0.24
        let newHeight = videoSize.width * 0.06 //0.08
        
        let marginForX = videoSize.width * 0.030
        let marginForY = videoSize.height * 0.85
        
        VideoProcessing.checkLog("Watermark Original -> \(waterMark.size.width) : \(waterMark.size.height)")
        VideoProcessing.checkLog("Watermark Resized -> \(newWidth) : \(newHeight)")
        
        watermarkLayer.frame = CGRect(x: marginForX, y: marginForY, width: newWidth, height: newHeight)
        
        let optionalLayer = CALayer()
        optionalLayer.addSublayer(watermarkLayer)
        optionalLayer.frame = videoFrame
        optionalLayer.masksToBounds = true
        
        let parentlayer = CALayer()
        let videoLayer = CALayer()
        parentlayer.frame = videoFrame
        videoLayer.frame = videoFrame
        parentlayer.addSublayer(videoLayer)
        parentlayer.addSublayer(optionalLayer)

        let videoComposition = AVMutableVideoComposition()
        videoComposition.frameDuration = CMTimeMake(value: kMediaContentTimeValue, timescale: kMediaContentTimeScale)
        videoComposition.renderSize = videoSize
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentlayer)
    
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = videoTrack.timeRange

        let layerInstruction = AVMutableVideoCompositionLayerInstruction.init(assetTrack: videoTrack)
        layerInstruction.setTransform(transform(avAsset, scaleFactor: kMediaContentDefaultScale), at: CMTime.zero)
        
        instruction.layerInstructions = [layerInstruction]
        videoComposition.instructions = [instruction]
    
        return videoComposition

    }
    
    @objc func imageViewTapped() {
        print("Wow its worked ...!!")
    }
    
    private func transform(_ avAsset: AVAsset, scaleFactor: CGFloat) -> CGAffineTransform {
        var offset = CGPoint.zero
        var angle: Double = 0
        
        switch avAsset.contentOrientation {
        case .left:
            offset = CGPoint(x: avAsset.contentCorrectSize.height, y: avAsset.contentCorrectSize.width)
            angle = Double.pi
        case .right:
            offset = CGPoint.zero
            angle = 0
        case .down:
            offset = CGPoint(x: 0, y: avAsset.contentCorrectSize.width)
            angle = -(Double.pi / 2)
        default:
            offset = CGPoint(x: avAsset.contentCorrectSize.height, y: 0)
            angle = Double.pi / 2
        }
        
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let translation = scale.translatedBy(x: offset.x, y: offset.y)
        let rotation = translation.rotated(by: CGFloat(angle))
        
        return rotation
    }
}

public extension URL {
    
    func sizePerMB() -> Double {
        if self.path.isEmpty {
            return 0.0
        }
        
        do {
            print("From sizePerMB : ", self.path)
            let attribute = try FileManager.default.attributesOfItem(atPath: self.path)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / Double(1024 * 1024)
            }
        } catch {
            debugPrint("From Error : \(error)")
        }
        return 0.0
    }
}

private extension AVAsset {
    
    private var contentNaturalSize: CGSize {
        return tracks(withMediaType: AVMediaType.video).first?.naturalSize ?? .zero
    }
    
    var contentCorrectSize: CGSize {
        return isContentPortrait ? CGSize(width: contentNaturalSize.height, height: contentNaturalSize.width) : contentNaturalSize
    }
    
    var contentOrientation: UIImage.Orientation {
        var assetOrientation = UIImage.Orientation.up
        let transform = tracks(withMediaType: AVMediaType.video)[0].preferredTransform
        
        if (transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0) {
            assetOrientation = .up
        }
        
        if (transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0) {
            assetOrientation = .down
        }
        
        if (transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0) {
            assetOrientation = .right
        }

        if (transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0) {
            assetOrientation = .left
        }
        
        return assetOrientation
    }
    
    var isContentPortrait: Bool {
        let portraits: [UIImage.Orientation] = [.left, .right]
        return portraits.contains(contentOrientation)
    }
}

private extension UIImage {
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
    
    class func image(fromTexture: MTLTexture) -> UIImage {
        let width = fromTexture.width
        let height = fromTexture.height
        
        let rowBytes = width * kImageBytesCount
        let textureResize = width * height * kImageBytesCount
        
        let memory = malloc(textureResize)
        
        fromTexture.getBytes(memory!, bytesPerRow: rowBytes, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.first.rawValue
        
        let releaseMaskImagePixelData: CGDataProviderReleaseDataCallback = { (info: UnsafeMutableRawPointer?, data: UnsafeRawPointer, size: Int) -> () in
            return
        }
        
        let provider = CGDataProvider(dataInfo: nil, data: memory!, size: textureResize, releaseData: releaseMaskImagePixelData)
        let cgImageRef = CGImage(width: width,
                                 height: height,
                                 bitsPerComponent: kImageBitsPerComponent,
                                 bitsPerPixel: kImageBitsPerPixel,
                                 bytesPerRow: rowBytes,
                                 space: colorSpace,
                                 bitmapInfo: CGBitmapInfo(rawValue: bitmapInfo),
                                 provider: provider!,
                                 decode: nil,
                                 shouldInterpolate: true,
                                 intent: CGColorRenderingIntent.defaultIntent)
        
        return UIImage(cgImage: cgImageRef!)
    }
    
    public func fixedOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: (self.cgImage?.colorSpace)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            break
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
}
