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
                SoundManager.shared.playButtonSound()
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
                    .foregroundStyle(isDisabled ? AppColor.neutral400 : AppColor.secondary100)
                
                Spacer(minLength: 4)
                
                Text(claimText)
                    .font(AppFont.bodyBold)
                    .kerning(AppFont.bodyBold.letterSpacing)
                    .foregroundStyle(isDisabled ? AppColor.neutral400 : .white)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .padding(.horizontal, ClaimButtonSize.contentHorizontalPadding)
        }
        .buttonStyle(ClaimButtonStyle(isDisabled: isDisabled, isSelected: isSelected, coinAmount: coinAmount))
        .disabled(isDisabled)
    }
}

private struct ClaimButtonStyle: ButtonStyle {
    let isDisabled: Bool
    let isSelected: Bool
    let coinAmount: Int
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .center) {
            
            if !isDisabled {
                if coinAmount == 50 {
                    RoundedRectangle(cornerRadius: ClaimButtonSize.cornerRadius + 8)
                        .stroke(AppColor.primary300Main.opacity(0.15), lineWidth: 16)
                        .frame(width: ClaimButtonSize.contentWidth + 16, height: ClaimButtonSize.contentHeight + 16)
                }
                
                RoundedRectangle(cornerRadius: ClaimButtonSize.cornerRadius + 4)
                    .stroke(AppColor.primary400Border.opacity(0.3), lineWidth: 8)
                    .frame(width: ClaimButtonSize.contentWidth + 8, height: ClaimButtonSize.contentHeight + 8)
            }
            
            configuration.label
                .frame(width: ClaimButtonSize.contentWidth, height: ClaimButtonSize.contentHeight, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: ClaimButtonSize.cornerRadius)
                        .fill(backgroundColor)
                }
                .overlay {
                    if !isDisabled {
                        RoundedRectangle(cornerRadius: ClaimButtonSize.cornerRadius)
                            .stroke(AppColor.primary400Border, lineWidth: 4)
                            .offset(y: -4)
                            .clipShape(RoundedRectangle(cornerRadius: ClaimButtonSize.cornerRadius))
                    }
                }
                .opacity(configuration.isPressed && !isDisabled ? 0.9 : 1.0)
        }
        .frame(width: ClaimButtonSize.contentWidth + 32, height: ClaimButtonSize.contentHeight + 32)
    }
    
    private var backgroundColor: Color {
        guard !isDisabled else {
            return AppColor.neutral200
        }
        return isSelected
            ? AppColor.primary400Border
            : AppColor.primary300Main
    }
    
}

internal enum ClaimButtonSize {
    static let contentWidth: CGFloat = 110
    static let contentHeight: CGFloat = 44
    static let coinIconSize: CGFloat = 24
    static let contentHorizontalPadding: CGFloat = 12
    static let cornerRadius: CGFloat = 14
}

#Preview {
    VStack(spacing: 40) {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 32) {
                ClaimRewardButton(coinAmount: 10, claimText: "1x") {
                    print("1x diklaim!")
                }
                
                ClaimRewardButton(coinAmount: 50, claimText: "5x") {
                    print("5x diklaim!")
                }
            }
        }
        
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 32) {
                ClaimRewardButton(coinAmount: 10, claimText: "1x", isDisabled: true) {}
                ClaimRewardButton(coinAmount: 50, claimText: "5x", isDisabled: true) {}
            }
        }
    }
    .padding(40)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColor.appBackground.ignoresSafeArea())
}
