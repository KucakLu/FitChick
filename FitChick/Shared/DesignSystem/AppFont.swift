import CoreText
import SwiftUI

enum AppFont {

    struct Token {
        let fontFamily: String
        let fontName: String
        let fontSize: CGFloat
        let fontWeight: CGFloat
        let letterSpacing: CGFloat
        let lineHeightMultiple: CGFloat
        let isItalic: Bool

        var font: Font {
            let variations: [Int: CGFloat] = [
                AppFont.weightAxisIdentifier: fontWeight,
                AppFont.widthAxisIdentifier: AppFont.defaultWidth
            ]
            let descriptor = CTFontDescriptorCreateWithAttributes([
                kCTFontNameAttribute: fontName as CFString,
                kCTFontVariationAttribute: variations as CFDictionary
            ] as CFDictionary)
            let ctFont = CTFontCreateWithFontDescriptor(descriptor, fontSize, nil)

            return Font(ctFont)
        }

        var lineHeight: CGFloat {
            fontSize * lineHeightMultiple
        }

        var lineSpacing: CGFloat {
            max(0, lineHeight - fontSize)
        }
    }

    private static let family = "Sour Gummy"
    private static let regularFontName = "SourGummy-Black"
    private static let italicFontName = "SourGummy-BlackItalic"
    private static let defaultWidth: CGFloat = 100
    private static let weightAxisIdentifier = 2_003_265_652 // "wght"
    private static let widthAxisIdentifier = 2_003_072_104 // "wdth"

    // MARK: - Large Title
    static let largeTitle = token(fontSize: 34, fontWeight: 400, lineHeightMultiple: 1.2058823529411764)
    static let largeTitleBold = token(fontSize: 34, fontWeight: 700, lineHeightMultiple: 1.2058823529411764)

    // MARK: - Title 1
    static let title1 = token(fontSize: 28, fontWeight: 400, lineHeightMultiple: 1.2142857142857142)
    static let title1Bold = token(fontSize: 28, fontWeight: 700, lineHeightMultiple: 1.2142857142857142)

    // MARK: - Title 2
    static let title2 = token(fontSize: 22, fontWeight: 400, lineHeightMultiple: 1.2727272727272727)
    static let title2Bold = token(fontSize: 22, fontWeight: 700, lineHeightMultiple: 1.2727272727272727)

    // MARK: - Title 3
    static let title3 = token(fontSize: 20, fontWeight: 400, lineHeightMultiple: 1.25)
    static let title3Bold = token(fontSize: 20, fontWeight: 600, lineHeightMultiple: 1.25)

    // MARK: - Headline
    static let headline = token(fontSize: 17, fontWeight: 600, lineHeightMultiple: 1.2941176470588236)
    static let headlineBoldItalic = token(fontSize: 17, fontWeight: 400, lineHeightMultiple: 1.2941176470588236, isItalic: true)

    // MARK: - Body
    static let body = token(fontSize: 17, fontWeight: 400, lineHeightMultiple: 1.2941176470588236)
    static let bodyBold = token(fontSize: 17, fontWeight: 700, lineHeightMultiple: 1.2941176470588236)
    static let bodyItalic = token(fontSize: 17, fontWeight: 400, lineHeightMultiple: 1.2941176470588236, isItalic: true)
    static let bodyBoldItalic = token(fontSize: 17, fontWeight: 400, lineHeightMultiple: 1.2941176470588236, isItalic: true)

    // MARK: - Callout
    static let callout = token(fontSize: 16, fontWeight: 400, lineHeightMultiple: 1.3125)
    static let calloutBold = token(fontSize: 16, fontWeight: 600, lineHeightMultiple: 1.3125)
    static let calloutItalic = token(fontSize: 16, fontWeight: 400, lineHeightMultiple: 1.3125, isItalic: true)
    static let calloutBoldItalic = token(fontSize: 16, fontWeight: 400, lineHeightMultiple: 1.3125, isItalic: true)

    // MARK: - Subhead
    static let subhead = token(fontSize: 15, fontWeight: 400, lineHeightMultiple: 1.3333333333333333)
    static let subheadBold = token(fontSize: 15, fontWeight: 600, lineHeightMultiple: 1.3333333333333333)
    static let subheadItalic = token(fontSize: 15, fontWeight: 400, lineHeightMultiple: 1.3333333333333333, isItalic: true)
    static let subheadBoldItalic = token(fontSize: 15, fontWeight: 400, lineHeightMultiple: 1.3333333333333333, isItalic: true)
    static let subheadline = subhead
    static let subheadlineBold = subheadBold
    static let subheadlineItalic = subheadItalic
    static let subheadlineBoldItalic = subheadBoldItalic

    // MARK: - Footnote
    static let footnote = token(fontSize: 13, fontWeight: 400, lineHeightMultiple: 1.3846153846153846)
    static let footnoteBold = token(fontSize: 13, fontWeight: 600, lineHeightMultiple: 1.3846153846153846)
    static let footnoteItalic = token(fontSize: 13, fontWeight: 400, lineHeightMultiple: 1.3846153846153846, isItalic: true)
    static let footnoteBoldItalic = token(fontSize: 13, fontWeight: 400, lineHeightMultiple: 1.3846153846153846, isItalic: true)

    // MARK: - Caption 1
    static let caption1 = token(fontSize: 12, fontWeight: 400, lineHeightMultiple: 1.3333333333333333)
    static let caption1Bold = token(fontSize: 12, fontWeight: 500, lineHeightMultiple: 1.3333333333333333)
    static let caption1Italic = token(fontSize: 12, fontWeight: 400, lineHeightMultiple: 1.3333333333333333, isItalic: true)
    static let caption1BoldItalic = token(fontSize: 12, fontWeight: 400, lineHeightMultiple: 1.3333333333333333, isItalic: true)

    // MARK: - Caption 2
    static let caption2 = token(fontSize: 11, fontWeight: 400, lineHeightMultiple: 1.1818181818181819)
    static let caption2Bold = token(fontSize: 11, fontWeight: 600, lineHeightMultiple: 1.1818181818181819)
    static let caption2Italic = token(fontSize: 11, fontWeight: 400, lineHeightMultiple: 1.1818181818181819, isItalic: true)
    static let caption2BoldItalic = token(fontSize: 11, fontWeight: 400, lineHeightMultiple: 1.1818181818181819, isItalic: true)

    private static func token(
        fontSize: CGFloat,
        fontWeight: CGFloat,
        lineHeightMultiple: CGFloat,
        isItalic: Bool = false
    ) -> Token {
        Token(
            fontFamily: family,
            fontName: isItalic ? italicFontName : regularFontName,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: 0,
            lineHeightMultiple: lineHeightMultiple,
            isItalic: isItalic
        )
    }
}

extension View {
    func font(_ appFont: AppFont.Token) -> some View {
        font(appFont.font)
    }
}
