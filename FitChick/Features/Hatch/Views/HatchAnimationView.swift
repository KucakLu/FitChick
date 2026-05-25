//
//  HatchAnimationView.swift
//  FitChick
//
//  Created by Codex on 22/05/26.
//

import ImageIO
import SwiftUI
import UIKit

struct HatchAnimationView: View {
    private let assetName: String
    private let contentMode: ContentMode
    private let fallbackImageName: String
    private let isPlaying: Bool
    private let onCompletion: (() -> Void)?

    init(
        assetName: String = "HatchAnimation",
        contentMode: ContentMode = .fit,
        fallbackImageName: String = "EggStage4",
        isPlaying: Bool = true,
        onCompletion: (() -> Void)? = nil
    ) {
        self.assetName = assetName
        self.contentMode = contentMode
        self.fallbackImageName = fallbackImageName
        self.isPlaying = isPlaying
        self.onCompletion = onCompletion
    }

    var body: some View {
        HatchAnimatedGIFView(
            assetName: assetName,
            contentMode: contentMode,
            fallbackImageName: fallbackImageName,
            isPlaying: isPlaying,
            onCompletion: onCompletion
        )
        .clipped()
        .accessibilityLabel("Hatch animation")
    }
}

private struct HatchAnimatedGIFView: UIViewRepresentable {
    let assetName: String
    let contentMode: ContentMode
    let fallbackImageName: String
    let isPlaying: Bool
    let onCompletion: (() -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = false
        imageView.clipsToBounds = true
        imageView.contentMode = contentMode.hatchUIViewContentMode
        return imageView
    }

    func updateUIView(_ imageView: UIImageView, context: Context) {
        imageView.contentMode = contentMode.hatchUIViewContentMode

        context.coordinator.configure(
            imageView,
            assetName: assetName,
            fallbackImageName: fallbackImageName
        )

        guard imageView.animationImages?.isEmpty == false else {
            return
        }

        if isPlaying {
            context.coordinator.startAnimating(imageView, onCompletion: onCompletion)
        } else {
            context.coordinator.stopAnimating(imageView)
        }
    }

    final class Coordinator {
        private var activeConfigurationKey: String?
        private var cachedAnimations: [String: HatchAnimatedGIF] = [:]
        private var completionWorkItem: DispatchWorkItem?
        private var isAnimationRunning = false
        private var currentAnimationDuration: TimeInterval = 0

        func configure(
            _ imageView: UIImageView,
            assetName: String,
            fallbackImageName: String
        ) {
            let configurationKey = "\(assetName)|\(fallbackImageName)"

            guard activeConfigurationKey != configurationKey else {
                return
            }

            if let animation = animatedGIF(named: assetName) {
                imageView.image = animation.frames.first
                imageView.animationImages = animation.frames
                imageView.animationDuration = animation.duration
                imageView.animationRepeatCount = 1
                currentAnimationDuration = animation.duration
            } else {
                stopAnimating(imageView)
                imageView.image = UIImage(named: fallbackImageName)
                imageView.animationImages = nil
                imageView.animationDuration = 0
                imageView.animationRepeatCount = 1
                currentAnimationDuration = 0
            }

            activeConfigurationKey = configurationKey
        }

        func startAnimating(
            _ imageView: UIImageView,
            onCompletion: (() -> Void)?
        ) {
            guard isAnimationRunning == false else {
                return
            }

            isAnimationRunning = true
            imageView.startAnimating()

            completionWorkItem?.cancel()
            let workItem = DispatchWorkItem { [weak self] in
                guard let self else {
                    return
                }

                self.isAnimationRunning = false
                imageView.stopAnimating()
                onCompletion?()
            }

            completionWorkItem = workItem
            DispatchQueue.main.asyncAfter(
                deadline: .now() + currentAnimationDuration,
                execute: workItem
            )
        }

        func stopAnimating(_ imageView: UIImageView) {
            completionWorkItem?.cancel()
            completionWorkItem = nil
            isAnimationRunning = false
            imageView.stopAnimating()
        }

        private func animatedGIF(named assetName: String) -> HatchAnimatedGIF? {
            if let cachedAnimation = cachedAnimations[assetName] {
                return cachedAnimation
            }

            guard
                let dataAsset = NSDataAsset(name: assetName),
                let animation = HatchAnimatedGIF.load(from: dataAsset.data)
            else {
                return nil
            }

            cachedAnimations[assetName] = animation
            return animation
        }
    }
}

private struct HatchAnimatedGIF {
    let frames: [UIImage]
    let duration: TimeInterval

    static func load(from data: Data) -> HatchAnimatedGIF? {
        let sourceOptions = [
            kCGImageSourceShouldCache: false
        ] as CFDictionary

        guard let imageSource = CGImageSourceCreateWithData(
            data as CFData,
            sourceOptions
        ) else {
            return nil
        }

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

        return HatchAnimatedGIF(
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

    nonisolated private static func greatestCommonDivisor(
        _ firstValue: Int,
        _ secondValue: Int
    ) -> Int {
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

private extension ContentMode {
    var hatchUIViewContentMode: UIView.ContentMode {
        switch self {
        case .fill:
            return .scaleAspectFill
        case .fit:
            return .scaleAspectFit
        @unknown default:
            return .scaleAspectFit
        }
    }
}

#Preview {
    ZStack {
        AppColor.secondary0Surface.ignoresSafeArea()

        HatchAnimationView()
            .frame(width: 320, height: 180)
    }
}
