import SwiftUI

struct PrimaryButton: View {
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
                .foregroundStyle(.white)
                .frame(width: PrimaryButtonSize.contentWidth)
                .frame(height: PrimaryButtonSize.contentHeight)
        }
        .buttonStyle(PrimaryButtonStyle(isDisabled: isDisabled))
        .disabled(isDisabled)
    }
}

private struct PrimaryButtonStyle: ButtonStyle {
    let isDisabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .topLeading) {
            bottomLayer(isPressed: configuration.isPressed)

            configuration.label
                .background {
                    RoundedRectangle(cornerRadius: PrimaryButtonSize.cornerRadius)
                        .fill(backgroundColor)
                }
                .overlay(alignment: .topLeading) {
                    if !configuration.isPressed && !isDisabled {
                        highlight
                    }
                }
                .offset(y: configuration.isPressed ? PrimaryButtonSize.pressedOffset : 0)
        }
        .frame(height: PrimaryButtonSize.totalHeight)
        .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
    }

    private var backgroundColor: Color {
        isDisabled ? AppColor.neutral400 : AppColor.primary300Main
    }

    private var shadowColor: Color {
        isDisabled ? AppColor.neutral500 : AppColor.primary400Border
    }

    private func bottomLayer(isPressed: Bool) -> some View {
        RoundedRectangle(cornerRadius: PrimaryButtonSize.cornerRadius)
            .fill(shadowColor)
            .frame(width: PrimaryButtonSize.contentWidth)
            .frame(height: PrimaryButtonSize.contentHeight)
            .offset(y: isPressed ? PrimaryButtonSize.pressedShadowOffset : PrimaryButtonSize.defaultShadowOffset)
    }

    private var highlight: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(.white.opacity(0.95))
            .frame(width: 12, height: 4)
            .padding(.leading, 8)
            .padding(.top, 8)
    }
}

private enum PrimaryButtonSize {
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
        PrimaryButton(title: "Next") {
            print("Next tapped")
        }

        PrimaryButton(title: "Claim Reward") {
            print("Reward claimed")
        }

        PrimaryButton(title: "Disabled", isDisabled: true) {
            print("Disabled")
        }
    }
    .padding()
}
