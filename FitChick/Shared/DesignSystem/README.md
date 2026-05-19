# Design System Usage

Panduan singkat penggunaan `AppColor.swift` dan `AppFont.swift` di SwiftUI.

## AppColor

Gunakan `AppColor` untuk mengambil warna dari asset catalog. Hindari memanggil `Color("NamaAsset")` langsung di view.

```swift
Text("Hello")
    .foregroundStyle(AppColor.neutral800Text)

RoundedRectangle(cornerRadius: 10)
    .fill(AppColor.primary300Main)
```

Contoh untuk state:

```swift
private var backgroundColor: Color {
    isDisabled ? AppColor.neutral400 : AppColor.primary300Main
}
```

Kategori warna yang tersedia:

- `primary*`: warna utama brand, button, CTA.
- `secondary*`: warna pendukung dan field.
- `neutral*`: background, text, disabled, border netral.
- `success*`: pesan/status berhasil.
- `error*`: pesan/status error.
- `labels*`, `fills*`, `separators*`: token UI sistem.

## AppFont

Gunakan `AppFont` lewat modifier `.font(...)`. `AppFont.Token` sudah mengarah ke font Sour Gummy yang didaftarkan di `Info.plist`.

```swift
Text("Claim Reward")
    .font(AppFont.bodyBold)
    .kerning(AppFont.bodyBold.letterSpacing)
```

Jika butuh line spacing sesuai token:

```swift
Text("Long body text")
    .font(AppFont.body)
    .kerning(AppFont.body.letterSpacing)
    .lineSpacing(AppFont.body.lineSpacing)
```

Token font yang tersedia:

- `largeTitle`, `largeTitleBold`
- `title1`, `title1Bold`
- `title2`, `title2Bold`
- `title3`, `title3Bold`
- `headline`, `headlineBoldItalic`
- `body`, `bodyBold`, `bodyItalic`, `bodyBoldItalic`
- `callout`, `calloutBold`, `calloutItalic`, `calloutBoldItalic`
- `subhead`, `subheadBold`, `subheadItalic`, `subheadBoldItalic`
- `subheadline`, `subheadlineBold`, `subheadlineItalic`, `subheadlineBoldItalic`
- `footnote`, `footnoteBold`, `footnoteItalic`, `footnoteBoldItalic`
- `caption1`, `caption1Bold`, `caption1Italic`, `caption1BoldItalic`
- `caption2`, `caption2Bold`, `caption2Italic`, `caption2BoldItalic`

## Contoh Lengkap

```swift
Text("Next")
    .font(AppFont.bodyBold)
    .kerning(AppFont.bodyBold.letterSpacing)
    .foregroundStyle(.white)
    .padding(.horizontal, 24)
    .padding(.vertical, 12)
    .background(AppColor.primary300Main)
    .clipShape(RoundedRectangle(cornerRadius: 10))
```
