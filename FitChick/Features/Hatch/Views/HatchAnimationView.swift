//
//  HatchAnimationView.swift
//  FitChick
//
//  Created by Codex on 22/05/26.
//

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

        private func animatedGIF(named assetName: String) -> GIFAnimation? {
            GIFAnimationCache.shared.animation(dataAssetNamed: assetName)
        }
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
