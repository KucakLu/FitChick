import SwiftUI

struct IconButton: View {
    let icon: Image
    let isDisabled: Bool
    let action: () -> Void

    init(
        icon: Image,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button {
            if !isDisabled {
                action()
            }
        } label: {
            icon
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: IconButtonSize.contentWidth)
                .frame(height: IconButtonSize.contentHeight)
        }
        .buttonStyle(IconButtonStyle(isDisabled: isDisabled))
        .disabled(isDisabled)
    }
}

private struct IconButtonStyle: ButtonStyle {
    let isDisabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .topLeading) {
            bottomLayer(isPressed: configuration.isPressed)

            configuration.label
                .background {
                    RoundedRectangle(cornerRadius: IconButtonSize.cornerRadius)
                        .fill(backgroundColor)
                }
                .offset(y: configuration.isPressed ? IconButtonSize.pressedOffset : 0)
        }
        .frame(height: IconButtonSize.totalHeight)
        .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
    }

    private var backgroundColor: Color {
        isDisabled ? AppColor.neutral400 : AppColor.primary300Main
    }

    private var shadowColor: Color {
        isDisabled ? AppColor.neutral500 : AppColor.primary400Border
    }

    private func bottomLayer(isPressed: Bool) -> some View {
        RoundedRectangle(cornerRadius: IconButtonSize.cornerRadius)
            .fill(shadowColor)
            .frame(width: IconButtonSize.contentWidth)
            .frame(height: IconButtonSize.contentHeight)
            .offset(y: isPressed ? IconButtonSize.pressedShadowOffset : IconButtonSize.defaultShadowOffset)
    }
}

private enum IconButtonSize {
    static let contentWidth: CGFloat = 48
    static let contentHeight: CGFloat = 42
    static let totalHeight: CGFloat = 54

    static let cornerRadius: CGFloat = 10

    static let defaultShadowOffset: CGFloat = 7
    static let pressedShadowOffset: CGFloat = 7

    static let pressedOffset: CGFloat = 4
}

#Preview {
    VStack(spacing: 24) {
        IconButton(icon: Image(systemName: "chevron.right")) {
            print("Next")
        }

        IconButton(icon: Image(systemName: "gift.fill")) {
            print("Reward claimed")
        }

        IconButton(icon: Image(systemName: "xmark"), isDisabled: true) {
            print("Disabled")
        }
    }
    .padding()
}
