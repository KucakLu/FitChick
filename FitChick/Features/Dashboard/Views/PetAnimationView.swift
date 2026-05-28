//
//  PetAnimationView.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI
import UIKit

struct PetAnimationView: View {
    private let animationName: String
    private let fileExtension: String
    private let equipment: EquippedPetItems
    private let contentMode: ContentMode
    private let fallbackImageName: String
    private let isPlaying: Bool

    init(
        animationName: String = "PetBlinkAnimation",
        fileExtension: String = "gif",
        equipment: EquippedPetItems = .empty,
        contentMode: ContentMode = .fit,
        fallbackImageName: String = "ChickIddle",
        isPlaying: Bool = true
    ) {
        self.animationName = animationName
        self.fileExtension = fileExtension
        self.equipment = equipment
        self.contentMode = contentMode
        self.fallbackImageName = fallbackImageName
        self.isPlaying = isPlaying
    }

    var body: some View {
        AnimatedGIFView(
            animationName: currentAnimationName,
            fileExtension: fileExtension,
            contentMode: contentMode,
            fallbackImageName: fallbackImageName,
            isPlaying: isPlaying
        )
        .accessibilityLabel("Pet animation")
    }

    private var currentAnimationName: String {
        if equipment.hasBlackHatEquipped {
            return "BlackHatPetAnimation"
        }

        return animationName
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
        imageView.clipsToBounds = false
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
        ) -> GIFAnimation? {
            GIFAnimationCache.shared.animation(
                named: animationName,
                fileExtension: fileExtension
            )
        }
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
            .frame(width: 640, height: 360)
    }
}
