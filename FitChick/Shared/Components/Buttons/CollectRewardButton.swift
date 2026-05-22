//
//  CollectRewardButton.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 21/05/26.
//

import SwiftUI

struct CollectRewardButton: View {
    let title: String
    let action: () -> Void

    init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(AppFont.bodyBold)
                .kerning(AppFont.bodyBold.letterSpacing)
                .frame(width: CollectRewardButtonSize.contentWidth)
                .frame(height: CollectRewardButtonSize.contentHeight)
        }
        .buttonStyle(CollectRewardButtonStyle())
    }
}

private struct CollectRewardButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .topLeading) {
            bottomLayer(isPressed: configuration.isPressed)

            configuration.label
                .background {
                    RoundedRectangle(cornerRadius: CollectRewardButtonSize.cornerRadius)
                        .fill(AppColor.neutral0)
                }
                .overlay(alignment: .topLeading) {
                    if !configuration.isPressed {
                        highlight
                    }
                }
                .offset(y: configuration.isPressed ? CollectRewardButtonSize.pressedOffset : 0)
        }
        .frame(height: CollectRewardButtonSize.totalHeight)
        .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
    }

    private func bottomLayer(isPressed: Bool) -> some View {
        RoundedRectangle(cornerRadius: CollectRewardButtonSize.cornerRadius)
            .fill(AppColor.neutral100)
            .frame(width: CollectRewardButtonSize.contentWidth)
            .frame(height: CollectRewardButtonSize.contentHeight)
            .offset(y: isPressed ? CollectRewardButtonSize.pressedShadowOffset : CollectRewardButtonSize.defaultShadowOffset)
    }

    private var highlight: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(.white.opacity(0.95))
            .frame(width: 12, height: 4)
            .padding(.leading, 8)
            .padding(.top, 8)
    }
}

private enum CollectRewardButtonSize {
    static let contentWidth: CGFloat = 362
    static let contentHeight: CGFloat = 46
    static let totalHeight: CGFloat = 54

    static let cornerRadius: CGFloat = 10

    static let defaultShadowOffset: CGFloat = 7
    static let pressedShadowOffset: CGFloat = 7

    static let pressedOffset: CGFloat = 4
}

#Preview {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()
        
        VStack {
            CollectRewardButton(title: "Tap to collect") {
                print("Reward collected!")
            }
        }
        .padding()
    }
}
