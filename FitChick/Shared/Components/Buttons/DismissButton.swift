//
//  DismissButton.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 22/05/26.
//

import SwiftUI

enum DismissButtonVariant {
    case neutral
    case secondary
}

struct DismissButton: View {
    let icon: Image
    let variant: DismissButtonVariant
    let action: () -> Void

    init(
        icon: Image = Image(systemName: "xmark"),
        variant: DismissButtonVariant = .neutral,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.variant = variant
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            icon
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color(.init(white: 0.15, alpha: 1.0)))
                .frame(width: DismissButtonSize.contentWidth)
                .frame(height: DismissButtonSize.contentHeight)
        }
        .buttonStyle(DismissButtonStyle(variant: variant))
    }
}

private struct DismissButtonStyle: ButtonStyle {
    let variant: DismissButtonVariant

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .topLeading) {
            bottomLayer(isPressed: configuration.isPressed)

            configuration.label
                .background {
                    RoundedRectangle(cornerRadius: DismissButtonSize.cornerRadius)
                        .fill(backgroundColor)
                }
                .offset(y: configuration.isPressed ? DismissButtonSize.pressedOffset : 0)
        }
        .frame(height: DismissButtonSize.totalHeight)
        .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
    }

    private var backgroundColor: Color {
        switch variant {
        case .neutral:
            return AppColor.neutral100
        case .secondary:
            return AppColor.secondary100
        }
    }

    private var shadowColor: Color {
        AppColor.neutral400
    }

    private func bottomLayer(isPressed: Bool) -> some View {
        RoundedRectangle(cornerRadius: DismissButtonSize.cornerRadius)
            .fill(shadowColor)
            .frame(width: DismissButtonSize.contentWidth)
            .frame(height: DismissButtonSize.contentHeight)
            .offset(y: isPressed ? DismissButtonSize.pressedShadowOffset : DismissButtonSize.defaultShadowOffset)
    }
}

private enum DismissButtonSize {
    static let contentWidth: CGFloat = 48
    static let contentHeight: CGFloat = 42
    static let totalHeight: CGFloat = 54

    static let cornerRadius: CGFloat = 10

    static let defaultShadowOffset: CGFloat = 7
    static let pressedShadowOffset: CGFloat = 7

    static let pressedOffset: CGFloat = 4
}


#Preview {

    DismissButton(variant: .neutral) {
        print("Dismiss Neutral Clicked")
    }

    DismissButton(variant: .secondary) {
        print("Dismiss Secondary Clicked")
    }
}
