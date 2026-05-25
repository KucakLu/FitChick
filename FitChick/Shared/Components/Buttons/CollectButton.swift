import SwiftUI

struct CollectButton: View {
    let title: String
    var amount: Int
    let isDisabled: Bool
    let action: () -> Void

    init(
        title: String = "Collect",
        amount: Int = 10,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.amount = amount
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button {
            if !isDisabled {
                SoundManager.shared.playButtonSound()
                action()
            }
        } label: {
            HStack(spacing: CollectButtonSize.contentSpacing) {
                Text(title)
                    .font(AppFont.subheadBold)
                    .kerning(AppFont.calloutBold.letterSpacing)
                    .foregroundStyle(titleColor)
                    

                HStack(spacing: CollectButtonSize.coinSpacing) {
                    Image("RewardCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: CollectButtonSize.coinSize)

                    Text("\(amount)")
                        .font(AppFont.footnoteBold)
                        .kerning(AppFont.footnoteBold.letterSpacing)
                        .foregroundStyle(amountColor)
                }
            }
            .frame(width: CollectButtonSize.contentWidth)
            .frame(height: CollectButtonSize.contentHeight)
        }
        .buttonStyle(CollectButtonStyle(isDisabled: isDisabled))
        .disabled(isDisabled)
    }

    private var titleColor: Color {
        isDisabled ? AppColor.neutral400 : AppColor.primary300Main
    }

    private var amountColor: Color {
        isDisabled ? AppColor.neutral500 : AppColor.neutral900
    }
}

private struct CollectButtonStyle: ButtonStyle {
    let isDisabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .topLeading) {
            bottomLayer(isPressed: configuration.isPressed)

            configuration.label
                .background {
                    RoundedRectangle(cornerRadius: CollectButtonSize.cornerRadius)
                        .fill(backgroundColor)
                }
                .overlay(alignment: .topLeading) {
                    if !configuration.isPressed {
                        highlight
                    }
                }
                .offset(y: configuration.isPressed ? CollectButtonSize.pressedOffset : 0)
        }
        .frame(width: CollectButtonSize.contentWidth)
        .frame(height: CollectButtonSize.totalHeight)
        .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
    }

    private var backgroundColor: Color {
        isDisabled ? AppColor.neutral100 : AppColor.neutral0
    }

    private var shadowColor: Color {
        isDisabled ? AppColor.neutral300 : AppColor.neutral300
    }

    private func bottomLayer(isPressed: Bool) -> some View {
        RoundedRectangle(cornerRadius: CollectButtonSize.cornerRadius)
            .fill(shadowColor)
            .frame(width: CollectButtonSize.contentWidth)
            .frame(height: CollectButtonSize.contentHeight)
            .offset(y: isPressed ? CollectButtonSize.pressedShadowOffset : CollectButtonSize.defaultShadowOffset)
    }

    private var highlight: some View {
        Capsule()
            .fill(.white.opacity(isDisabled ? 0.55 : 0.95))
            .frame(width: 12, height: 4)
            .padding(.leading, 8)
            .padding(.top, 6)
    }
}

private enum CollectButtonSize {
    static let contentWidth: CGFloat = 117
    static let contentHeight: CGFloat = 42
    static let totalHeight: CGFloat = 48

    static let cornerRadius: CGFloat = 10
    static let coinSize: CGFloat = 24
    static let contentSpacing: CGFloat = 8
    static let coinSpacing: CGFloat = 4

    static let defaultShadowOffset: CGFloat = 7
    static let pressedShadowOffset: CGFloat = 7
    static let pressedOffset: CGFloat = 4
}

#Preview {
    VStack(spacing: 24) {
        CollectButton(amount: 50) {
            print("Collect tapped")
        }

        CollectButton(amount: 30, isDisabled: true) {
            print("Disabled")
        }
    }
    .padding()
    .background(AppColor.secondary0Surface)
}
