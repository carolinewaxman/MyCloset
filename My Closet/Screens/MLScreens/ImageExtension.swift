import UIKit
import CoreVideo
import CoreML

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized
    }
    
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else { return nil }
        CVPixelBufferLockBaseAddress(buffer, [])
        let pixelData = CVPixelBufferGetBaseAddress(buffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer), space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        if let cgImage = self.cgImage {
            context?.draw(cgImage, in: CGRect(x: 0, y:0, width:size.width, height:size.height))
        }
        CVPixelBufferUnlockBaseAddress(buffer, [])
        return buffer

    }
}

func imageToMultiArray(_ image: UIImage, size: CGSize = CGSize(width: 224, height: 224)) -> MLMultiArray? {
    guard let cgImage = image.cgImage else {
        return nil
    }
    
    let width = Int(size.width)
    let height = Int(size.height)
    
    let byteCount = width * height * 4
    var pixelData = [UInt8](repeating: 0, count: byteCount)
    let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
    
    context?.draw(cgImage, in: CGRect(x: 0, y:0, width: width, height: height))
    guard let array = try? MLMultiArray(shape: [1, 224, 224, 3] as [NSNumber], dataType: .float32) else { return nil }
    
    for y in 0..<height {
        for x in 0..<width {
            let pixelIndex = (y * width + x) * 4
            let r = Float(pixelData[pixelIndex]) / 255.0
            let g = Float(pixelData[pixelIndex + 1]) / 255.0
            let b = Float(pixelData[pixelIndex + 2]) / 255.0

            array[[0, y as NSNumber, x as NSNumber, 0]] = NSNumber(value: r)
            array[[0, y as NSNumber, x as NSNumber, 1]] = NSNumber(value: g)
            array[[0, y as NSNumber, x as NSNumber, 2]] = NSNumber(value: b)
            
        }
    }
    return array
}

