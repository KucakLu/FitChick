//
//  PetAnimationView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import ImageIO
import SwiftUI
import UIKit

struct PetAnimationView: View {
    private let animationName: String
    private let fileExtension: String
    private let contentMode: ContentMode
    private let fallbackImageName: String
    private let isPlaying: Bool

    init(
        animationName: String = "PetBlinkAnimation",
        fileExtension: String = "gif",
        contentMode: ContentMode = .fill,
        fallbackImageName: String = "ChickIddle",
        isPlaying: Bool = true
    ) {
        self.animationName = animationName
        self.fileExtension = fileExtension
        self.contentMode = contentMode
        self.fallbackImageName = fallbackImageName
        self.isPlaying = isPlaying
    }

    var body: some View {
        AnimatedGIFView(
            animationName: animationName,
            fileExtension: fileExtension,
            contentMode: contentMode,
            fallbackImageName: fallbackImageName,
            isPlaying: isPlaying
        )
        .clipped()
        .accessibilityLabel("Pet animation")
    }
}

private struct AnimatedGIFView: UIViewRepresentable {
    let animationName: String
    let fileExtension: String
    let contentMode: ContentMode
    let fallbackImageName: String
    let isPlaying: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = false
        imageView.clipsToBounds = true
        imageView.contentMode = contentMode.uiViewContentMode
        return imageView
    }

    func updateUIView(_ imageView: UIImageView, context: Context) {
        imageView.contentMode = contentMode.uiViewContentMode

        context.coordinator.configure(
            imageView,
            animationName: animationName,
            fileExtension: fileExtension,
            fallbackImageName: fallbackImageName
        )

        guard imageView.animationImages?.isEmpty == false else {
            return
        }

        if isPlaying {
            imageView.startAnimating()
        } else {
            imageView.stopAnimating()
        }
    }

    final class Coordinator {
        private var activeAnimationKey: String?
        private var cachedAnimations: [String: AnimatedGIF] = [:]

        func configure(
            _ imageView: UIImageView,
            animationName: String,
            fileExtension: String,
            fallbackImageName: String
        ) {
            let animationKey = "\(animationName).\(fileExtension)"

            guard activeAnimationKey != animationKey else {
                return
            }

            if let animation = animatedGIF(named: animationName, fileExtension: fileExtension) {
                imageView.image = animation.frames.first
                imageView.animationImages = animation.frames
                imageView.animationDuration = animation.duration
                imageView.animationRepeatCount = 0
            } else {
                imageView.stopAnimating()
                imageView.image = UIImage(named: fallbackImageName)
                imageView.animationImages = nil
                imageView.animationDuration = 0
                imageView.animationRepeatCount = 0
            }

            activeAnimationKey = animationKey
        }

        private func animatedGIF(
            named animationName: String,
            fileExtension: String
        ) -> AnimatedGIF? {
            let animationKey = "\(animationName).\(fileExtension)"

            if let cachedAnimation = cachedAnimations[animationKey] {
                return cachedAnimation
            }

            guard let animation = AnimatedGIF.load(
                named: animationName,
                fileExtension: fileExtension
            ) else {
                return nil
            }

            cachedAnimations[animationKey] = animation
            return animation
        }
    }
}

private struct AnimatedGIF {
    let frames: [UIImage]
    let duration: TimeInterval

    static func load(
        named animationName: String,
        fileExtension: String,
        bundle: Bundle = .main
    ) -> AnimatedGIF? {
        guard let animationURL = bundle.url(
            forResource: animationName,
            withExtension: fileExtension
        ) else {
            return nil
        }

        let sourceOptions = [
            kCGImageSourceShouldCache: false
        ] as CFDictionary

        guard let imageSource = CGImageSourceCreateWithURL(
            animationURL as CFURL,
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

        return AnimatedGIF(
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

private extension ContentMode {
    var uiViewContentMode: UIView.ContentMode {
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
        AppColor.dashboardBackground.ignoresSafeArea()

        PetAnimationView()
            .frame(width: 50, height: 50)
    }
}
