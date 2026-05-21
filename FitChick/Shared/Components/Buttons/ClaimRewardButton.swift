//
//  ClaimRewardButton.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 21/05/26.
//

import SwiftUI

struct ClaimRewardButton: View {
    let coinAmount: Int
    let claimText: String
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        coinAmount: Int,
        claimText: String,
        isSelected: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.coinAmount = coinAmount
        self.claimText = claimText
        self.isSelected = isSelected
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
            Button(action: {
                if !isDisabled {
                    action()
                }
            }) {
                HStack(spacing: 0) {
                    Image(isDisabled ? "RewardCoinDisabled" : "RewardCoin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: ClaimButtonSize.coinIconSize, height: ClaimButtonSize.coinIconSize)
                    
                    Color.clear
                        .frame(width: 4, height: 1)
                    
                    Text("\(coinAmount)")
                        .font(AppFont.bodyBold)
                        .kerning(AppFont.bodyBold.letterSpacing)
                        .foregroundStyle(isDisabled ? AppColor.neutral500 : AppColor.secondary100)
                    
                    Spacer(minLength: 4)
                    
                    Text(claimText)
                        .font(AppFont.bodyBold)
                        .kerning(AppFont.bodyBold.letterSpacing)
                        .foregroundStyle(isDisabled ? AppColor.neutral500 : .white)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .padding(.horizontal, ClaimButtonSize.contentHorizontalPadding)
                .frame(width: ClaimButtonSize.contentWidth, height: ClaimButtonSize.contentHeight, alignment: .leading)
            }
            .buttonStyle(ClaimButtonStyle(isDisabled: isDisabled, isSelected: isSelected))
            .disabled(isDisabled)
        }
}

private struct ClaimButtonStyle: ButtonStyle {
    let isDisabled: Bool
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .topLeading) {
            bottomLayer(isPressed: configuration.isPressed)
            
            configuration.label
                .background {
                    if !isDisabled {
                        RoundedRectangle(cornerRadius: ClaimButtonSize.cornerRadius)
                            .fill(backgroundHaloColor)
                            .blur(radius: ClaimButtonSize.haloBlurRadius)
                            .padding(-ClaimButtonSize.haloPadding)
                    }
                    
                    RoundedRectangle(cornerRadius: ClaimButtonSize.cornerRadius)
                        .fill(backgroundColor)
                }
                .offset(y: isDisabled ? 0 : (configuration.isPressed ? ClaimButtonSize.pressedOffset : 0))
        }
        .frame(height: ClaimButtonSize.totalHeight)
        .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
    }
    
    private var backgroundColor: Color {
        if isDisabled {
            return AppColor.neutral200
        } else if isSelected {
            return AppColor.primary400Border
        } else {
            return AppColor.primary300Main
        }
    }
    
    private var shadowColor: Color {
        if isDisabled {
            return Color.clear
        } else if isSelected {
            return AppColor.primary500Dark
        } else {
            return AppColor.primary400Border
        }
    }
    
    private var backgroundHaloColor: Color {
        if isDisabled {
            return Color.clear
        } else {
            return AppColor.primary100.opacity(0.15)
        }
    }
    
    private func bottomLayer(isPressed: Bool) -> some View {
        RoundedRectangle(cornerRadius: ClaimButtonSize.cornerRadius)
            .fill(shadowColor)
            .frame(width: ClaimButtonSize.contentWidth, height: ClaimButtonSize.contentHeight)
            .offset(y: isPressed ? ClaimButtonSize.pressedShadowOffset : ClaimButtonSize.defaultShadowOffset)
    }
    
    private var highlight: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(.white.opacity(0.95))
            .frame(width: 8, height: 3)
            .padding(.leading, 6)
            .padding(.top, 5)
    }
}

private enum ClaimButtonSize {
    static let contentWidth: CGFloat = 110
    static let contentHeight: CGFloat = 44
    static let totalHeight: CGFloat = 48
    
    static let coinIconSize: CGFloat = 24
    static let contentHorizontalPadding: CGFloat = 12
    
    static let cornerRadius: CGFloat = 14
    static let haloBlurRadius: CGFloat = 6
    static let haloPadding: CGFloat = 4
    
    static let defaultShadowOffset: CGFloat = 4
    static let pressedShadowOffset: CGFloat = 4
    static let pressedOffset: CGFloat = 2
}

#Preview {
    VStack(spacing: 24) {
        HStack(spacing: 16) {
            ClaimRewardButton(coinAmount: 10, claimText: "1x") {
                print("1x koin diklaim!")
            }
            
            ClaimRewardButton(coinAmount: 50, claimText: "5x") {
                print("5x koin diklaim!")
            }
        }
        
        HStack(spacing: 16) {
            ClaimRewardButton(coinAmount: 10, claimText: "1x", isDisabled: true) {
            }
            
            ClaimRewardButton(coinAmount: 50, claimText: "5x", isDisabled: true) {
            }
        }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColor.appBackground.ignoresSafeArea())
}
