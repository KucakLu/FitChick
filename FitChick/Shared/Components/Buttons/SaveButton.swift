//
//  SaveButton.swift
//  FitChick
//
//  Created by Hendra Irawan on 23/05/26.
//

import SwiftUI

struct SaveButton: View {
    let title: String
    let isDisabled: Bool
    let action: () -> Void

    init(
        title: String = "Save",
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
                .foregroundStyle(titleColor)
                .frame(width: SaveButtonSize.contentWidth)
                .frame(height: SaveButtonSize.contentHeight)
        }
        .buttonStyle(SaveButtonStyle(isDisabled: isDisabled))
        .disabled(isDisabled)
    }

    private var titleColor: Color {
        isDisabled ? AppColor.neutral400 : AppColor.primary300Main
    }
}

private struct SaveButtonStyle: ButtonStyle {
    let isDisabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .topLeading) {
            bottomLayer(isPressed: configuration.isPressed)

            configuration.label
                .background {
                    RoundedRectangle(cornerRadius: SaveButtonSize.cornerRadius)
                        .fill(backgroundColor)
                }
                .overlay(alignment: .topLeading) {
                    if !configuration.isPressed && !isDisabled {
                        highlight
                    }
                }
                .offset(y: configuration.isPressed ? SaveButtonSize.pressedOffset : 0)
        }
        .frame(width: SaveButtonSize.contentWidth)
        .frame(height: SaveButtonSize.totalHeight)
        .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
    }

    private var backgroundColor: Color {
        isDisabled ? AppColor.neutral100 : AppColor.neutral0
    }

    private var shadowColor: Color {
        AppColor.neutral300
    }

    private func bottomLayer(isPressed: Bool) -> some View {
        RoundedRectangle(cornerRadius: SaveButtonSize.cornerRadius)
            .fill(shadowColor)
            .frame(width: SaveButtonSize.contentWidth)
            .frame(height: SaveButtonSize.contentHeight)
            .offset(y: isPressed ? SaveButtonSize.pressedShadowOffset : SaveButtonSize.defaultShadowOffset)
    }

    private var highlight: some View {
        Capsule()
            .fill(.white.opacity(0.95))
            .frame(width: 12, height: 4)
            .padding(.leading, 8)
            .padding(.top, 6)
    }
}

private enum SaveButtonSize {
    static let contentWidth: CGFloat = 70
    static let contentHeight: CGFloat = 42
    static let totalHeight: CGFloat = 48

    static let cornerRadius: CGFloat = 8

    static let defaultShadowOffset: CGFloat = 6
    static let pressedShadowOffset: CGFloat = 6

    static let pressedOffset: CGFloat = 4
}

#Preview {
    VStack(spacing: 24) {
        SaveButton {
            print("Save tapped")
        }

        SaveButton(isDisabled: true) {
            print("Disabled")
        }
    }
    .padding()
}
