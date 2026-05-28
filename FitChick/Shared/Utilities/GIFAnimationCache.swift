import Foundation
import ImageIO
import UIKit

struct GIFAnimation {
    let frames: [UIImage]
    let duration: TimeInterval
}

final class GIFAnimationCache {
    static let shared = GIFAnimationCache()

    private let animations = NSCache<NSString, CachedGIFAnimation>()

    private init() {
        animations.countLimit = 3
    }

    func animation(
        named animationName: String,
        fileExtension: String,
        bundle: Bundle = .main
    ) -> GIFAnimation? {
        let animationKey = "bundle:\(bundle.bundleIdentifier ?? "main"):\(animationName).\(fileExtension)"

        if let cachedAnimation = cachedAnimation(for: animationKey) {
            return cachedAnimation
        }

        guard let animationURL = bundle.url(
            forResource: animationName,
            withExtension: fileExtension
        ) else {
            return nil
        }

        let animation = PerformanceProbe.measure("GIFDecode") {
            GIFAnimation.load(from: animationURL)
        }

        if let animation {
            cache(animation, for: animationKey)
        }

        return animation
    }

    func animation(dataAssetNamed assetName: String) -> GIFAnimation? {
        let animationKey = "dataAsset:\(assetName)"

        if let cachedAnimation = cachedAnimation(for: animationKey) {
            return cachedAnimation
        }

        guard let dataAsset = NSDataAsset(name: assetName) else {
            return nil
        }

        let animation = PerformanceProbe.measure("GIFDecode") {
            GIFAnimation.load(from: dataAsset.data)
        }

        if let animation {
            cache(animation, for: animationKey)
        }

        return animation
    }

    func preloadBundleResources(_ resources: [(name: String, fileExtension: String)]) {
        resources.forEach { resource in
            _ = animation(named: resource.name, fileExtension: resource.fileExtension)
        }
    }

    func preloadDataAssets(_ assetNames: [String]) {
        assetNames.forEach { assetName in
            _ = animation(dataAssetNamed: assetName)
        }
    }

    private func cachedAnimation(for key: String) -> GIFAnimation? {
        animations.object(forKey: NSString(string: key))?.animation
    }

    private func cache(_ animation: GIFAnimation, for key: String) {
        animations.setObject(CachedGIFAnimation(animation), forKey: NSString(string: key))
    }

    private final class CachedGIFAnimation: NSObject {
        let animation: GIFAnimation

        init(_ animation: GIFAnimation) {
            self.animation = animation
        }
    }
}

private extension GIFAnimation {
    static func load(from url: URL) -> GIFAnimation? {
        let sourceOptions = [
            kCGImageSourceShouldCache: false
        ] as CFDictionary

        guard let imageSource = CGImageSourceCreateWithURL(
            url as CFURL,
            sourceOptions
        ) else {
            return nil
        }

        return load(from: imageSource)
    }

    static func load(from data: Data) -> GIFAnimation? {
        let sourceOptions = [
            kCGImageSourceShouldCache: false
        ] as CFDictionary

        guard let imageSource = CGImageSourceCreateWithData(
            data as CFData,
            sourceOptions
        ) else {
            return nil
        }

        return load(from: imageSource)
    }

    private static func load(from imageSource: CGImageSource) -> GIFAnimation? {
        let frameCount = CGImageSourceGetCount(imageSource)
        guard frameCount > 0 else {
            return nil
        }

        let rawFrames = (0..<frameCount).compactMap { frameIndex -> GIFFrame? in
            guard let cgImage = CGImageSourceCreateImageAtIndex(
                imageSource,
                frameIndex,
                nil
            ) else {
                return nil
            }

            return GIFFrame(
                image: UIImage(cgImage: cgImage),
                durationInMilliseconds: frameDurationInMilliseconds(
                    from: imageSource,
                    at: frameIndex
                )
            )
        }

        guard rawFrames.isEmpty == false else {
            return nil
        }

        let frameDurationUnit = rawFrames
            .map(\.durationInMilliseconds)
            .reduce(rawFrames[0].durationInMilliseconds, greatestCommonDivisor)

        let frames = rawFrames.flatMap { frame in
            Array(
                repeating: frame.image,
                count: max(frame.durationInMilliseconds / frameDurationUnit, 1)
            )
        }

        let duration = rawFrames
            .map(\.durationInMilliseconds)
            .reduce(0, +)

        return GIFAnimation(
            frames: frames,
            duration: TimeInterval(duration) / 1_000
        )
    }

    private static func frameDurationInMilliseconds(
        from imageSource: CGImageSource,
        at frameIndex: Int
    ) -> Int {
        guard
            let frameProperties = CGImageSourceCopyPropertiesAtIndex(
                imageSource,
                frameIndex,
                nil
            ) as? [CFString: Any],
            let gifProperties = frameProperties[kCGImagePropertyGIFDictionary] as? [CFString: Any]
        else {
            return 100
        }

        let unclampedDelay = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? Double
        let delay = unclampedDelay
            ?? gifProperties[kCGImagePropertyGIFDelayTime] as? Double
            ?? 0.1

        return max(Int((delay * 1_000).rounded()), 20)
    }

    nonisolated private static func greatestCommonDivisor(_ firstValue: Int, _ secondValue: Int) -> Int {
        var firstValue = firstValue
        var secondValue = secondValue

        while secondValue != 0 {
            let remainder = firstValue % secondValue
            firstValue = secondValue
            secondValue = remainder
        }

        return max(firstValue, 1)
    }

    private struct GIFFrame {
        let image: UIImage
        let durationInMilliseconds: Int
    }
}
