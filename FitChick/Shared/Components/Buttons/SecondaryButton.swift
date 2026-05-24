//
//  SecondaryButton.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 24/05/26.
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let isDisabled: Bool
    let action: () -> Void

    init(
        title: String,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button {
            if !isDisabled {
                action()
            }
        } label: {
            Text(title)
                .font(AppFont.bodyBold)
                .kerning(AppFont.bodyBold.letterSpacing)
                .foregroundStyle(textColor)
                .frame(width: SecondaryButtonSize.contentWidth)
                .frame(height: SecondaryButtonSize.contentHeight)
        }
        .buttonStyle(SecondaryButtonStyle(isDisabled: isDisabled))
        .disabled(isDisabled)
    }

    private var textColor: Color {
        isDisabled
        ? AppColor.neutral400
        : AppColor.primary300Main
    }
}

private struct SecondaryButtonStyle: ButtonStyle {
    let isDisabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .topLeading) {
            bottomLayer(isPressed: configuration.isPressed)

            configuration.label
                .background {
                    RoundedRectangle(
                        cornerRadius: SecondaryButtonSize.cornerRadius
                    )
                    .fill(backgroundColor)
                }
                .overlay(alignment: .topLeading) {
                    if !configuration.isPressed && !isDisabled {
                        highlight
                    }
                }
                .offset(
                    y: configuration.isPressed
                    ? SecondaryButtonSize.pressedOffset
                    : 0
                )
        }
        .frame(height: SecondaryButtonSize.totalHeight)
        .animation(
            .easeInOut(duration: 0.08),
            value: configuration.isPressed
        )
    }

    private var backgroundColor: Color {
        isDisabled
        ? AppColor.neutral200
        : AppColor.neutral100
    }

    private var shadowColor: Color {
        isDisabled
        ? AppColor.neutral300
        : AppColor.neutral300
    }

    private func bottomLayer(isPressed: Bool) -> some View {
        RoundedRectangle(
            cornerRadius: SecondaryButtonSize.cornerRadius
        )
        .fill(shadowColor)
        .frame(width: SecondaryButtonSize.contentWidth)
        .frame(height: SecondaryButtonSize.contentHeight)
        .offset(
            y: isPressed
            ? SecondaryButtonSize.pressedShadowOffset
            : SecondaryButtonSize.defaultShadowOffset
        )
    }

    private var highlight: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(.white.opacity(0.9))
            .frame(width: 12, height: 4)
            .padding(.leading, 8)
            .padding(.top, 8)
    }
}

private enum SecondaryButtonSize {
    static let contentWidth: CGFloat = 320
    static let contentHeight: CGFloat = 46
    static let totalHeight: CGFloat = 54

    static let cornerRadius: CGFloat = 10

    static let defaultShadowOffset: CGFloat = 7
    static let pressedShadowOffset: CGFloat = 7

    static let pressedOffset: CGFloat = 4
}

#Preview {
    VStack(spacing: 24) {
        SecondaryButton(title: "Skip") {
            print("Skip tapped")
        }

        SecondaryButton(title: "Disabled", isDisabled: true) {
            print("Disabled")
        }
    }
    .padding()
}
