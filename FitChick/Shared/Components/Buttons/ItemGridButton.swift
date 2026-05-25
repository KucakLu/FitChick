//
//  ItemGridButton.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 22/05/26.
//

import SwiftUI

enum ItemState {
    case normal
    case locked
    case selected
}

struct ItemGridButton: View {
    let svgAssetName: String
    let state: ItemState
    let action: () -> Void

    init(
        svgAssetName: String,
        state: ItemState = .normal,
        action: @escaping () -> Void
    ) {
        self.svgAssetName = svgAssetName
        self.state = state
        self.action = action
    }

    var body: some View {
        Button {
            if state != .locked {
                SoundManager.shared.playButtonSound()
                action()
            }
        } label: {
            ZStack {
                Image(svgAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: ItemButtonSize.imageSize, height: ItemButtonSize.imageSize)
                    .opacity(1.0)
                
                if state == .locked {
                    VStack {
                        HStack {
                            Spacer()
                            lockIconOverlay
                        }
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 8)
                }
                
                if state == .selected {
                    VStack {
                        HStack {
                            Spacer()
                            checkIconOverlay
                        }
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 8)
                }
            }
            .frame(
                width: ItemButtonSize.contentWidth,
                height: state == .locked ? ItemButtonSize.totalHeight : ItemButtonSize.contentHeight
            )
        }
        .buttonStyle(ItemGridButtonStyle(state: state))
        .disabled(state == .locked)
    }
    
    private var lockIconOverlay: some View {
        Image(systemName: "lock")
            .font(AppFont.caption1Bold)
            .foregroundColor(.white)
            .frame(width: 28, height: 28)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColor.neutral400)
            )
    }
    
    private var checkIconOverlay: some View {
        Image(systemName: "checkmark")
            .font(AppFont.caption1Bold)
            .foregroundColor(AppColor.success500Dark)
            .frame(width: 28, height: 28)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColor.success500Dark.opacity(0.2))
            )
    }
}

private struct ItemGridButtonStyle: ButtonStyle {
    let state: ItemState

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .topLeading) {
            if state != .locked {
                bottomLayer(isPressed: configuration.isPressed)
            }

            configuration.label
                .background {
                    RoundedRectangle(cornerRadius: ItemButtonSize.cornerRadius)
                        .fill(backgroundColor)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: ItemButtonSize.cornerRadius)
                        .stroke(strokeColor, lineWidth: state == .selected ? 2 : 0)
                }
                .overlay(alignment: .topLeading) {
                    if !configuration.isPressed && state != .locked {
                        highlight
                    }
                }
                .offset(y: (state != .locked && configuration.isPressed) ? ItemButtonSize.pressedOffset : 0)
        }
        .frame(width: ItemButtonSize.contentWidth, height: ItemButtonSize.totalHeight)
        .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
    }

    private var backgroundColor: Color {
        switch state {
        case .locked:
            return Color(AppColor.neutral300).opacity(0.6)
        case .normal:
            return AppColor.neutral0
        case .selected:
            return AppColor.success50Surface
        }
    }

    private var shadowColor: Color {
        switch state {
        case .selected:
            return AppColor.success300Main
        default:
            return AppColor.neutral300
        }
    }
    
    private var strokeColor: Color {
        state == .selected ? AppColor.success300Main : .clear
    }

    private func bottomLayer(isPressed: Bool) -> some View {
        RoundedRectangle(cornerRadius: ItemButtonSize.cornerRadius)
            .fill(shadowColor)
            .frame(width: ItemButtonSize.contentWidth, height: ItemButtonSize.contentHeight)
            .offset(y: isPressed ? ItemButtonSize.pressedShadowOffset : ItemButtonSize.defaultShadowOffset)
    }

    private var highlight: some View {
        Capsule()
            .fill(.white.opacity(0.95))
            .frame(width: 12, height: 4)
            .padding(.leading, 10)
            .padding(.top, 8)
    }
}

private enum ItemButtonSize {
    static let contentWidth: CGFloat = 100
    static let contentHeight: CGFloat = 93
    static let totalHeight: CGFloat = 100
    static let cornerRadius: CGFloat = 20
    static let imageSize: CGFloat = 52
    static let defaultShadowOffset: CGFloat = 7
    static let pressedShadowOffset: CGFloat = 7
    static let pressedOffset: CGFloat = 4
}


#Preview {
    HStack(spacing: 16) {
        ItemGridButton(svgAssetName: "black_hat", state: .normal) {
            print("Item normal dipilih")
        }
        
        ItemGridButton(svgAssetName: "black_hat", state: .locked) {
            print("Tidak akan terpanggil karena dikunci")
        }
        
        ItemGridButton(svgAssetName: "black_hat", state: .selected) {
            print("Item selected diklik ulang")
        }
    }
    .padding()
    .background(AppColor.secondary0Surface)
}
