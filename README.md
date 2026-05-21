# FitChick 🐣

FitChick adalah aplikasi iOS berbasis **SwiftUI** yang mengubah aktivitas harian (seperti jalan kaki) menjadi pengalaman yang lebih menyenangkan dengan karakter chick virtual, alur onboarding yang playful, serta integrasi HealthKit.

## ✨ Fitur Utama

- **Onboarding bertahap** dengan ilustrasi karakter dan narasi motivasi.
- **Login dengan Sign in with Apple**.
- **Integrasi HealthKit** untuk meminta izin akses data aktivitas dan membaca jumlah langkah harian.
- **Reward screen** untuk menampilkan coin reward.
- **Hatch progression screen** (animasi telur bertahap) sebagai gamification journey.

## 🧱 Teknologi yang Digunakan

- **SwiftUI** untuk UI dan navigasi.
- **AuthenticationServices** untuk Sign in with Apple.
- **HealthKit** untuk data aktivitas (step count & distance walking/running).
- **Keychain** (via utility manager) untuk penyimpanan data user Apple ID secara lokal.

## 📂 Struktur Proyek

```text
FitChick/
├── FitChickApp.swift                    # Entry point aplikasi
├── ContentView.swift                    # View default template (belum dipakai di flow utama)
├── Features/
│   ├── Onboarding/Views/                # Onboarding intro + 3 step onboarding
│   ├── Login/Views/                     # LoginView (Sign in with Apple)
│   ├── ConnectHealth/
│   │   ├── Datas/                       # HealthStore (akses HealthKit)
│   │   └── Views/                       # ConnectHealth screen
│   ├── Reward/Views/                    # RewardCoinRegister screen
│   └── Hatch/Views/                     # HatchView (animasi telur)
├── Shared/
│   ├── Components/Buttons/              # Komponen button reusable
│   ├── DesignSystem/                    # AppColor & AppFont
│   └── Utilities/                       # KeychainManager
└── Resources/
    ├── Assets.xcassets/                 # Ikon, ilustrasi, warna, gambar UI
    └── Fonts/                           # Font aplikasi
```

## 🚀 Menjalankan Proyek

1. Buka file `FitChick.xcodeproj` menggunakan Xcode.
2. Pilih target **FitChick**.
3. Pilih simulator iOS (atau perangkat fisik).
4. Jalankan aplikasi dengan tombol **Run** (`⌘R`).

## 🔐 Konfigurasi & Permission

### 1) Sign in with Apple
Pastikan capability **Sign In with Apple** aktif di target aplikasi.

### 2) HealthKit
Pastikan capability **HealthKit** aktif dan aplikasi memiliki permission yang relevan untuk membaca:
- Step Count
- Distance Walking/Running

> Catatan: Data HealthKit tidak tersedia secara penuh pada semua simulator. Untuk pengujian paling akurat, gunakan perangkat fisik.

## 🧭 Alur Aplikasi Saat Ini

1. App launch ke `Onboarding`.
2. Intro screen otomatis transisi ke `Onboarding1`.
3. User lanjut ke `Onboarding2` → `Onboarding3`.
4. Lanjut ke `LoginView` untuk Sign in with Apple.
5. Fitur lain yang sudah tersedia sebagai layar terpisah:
   - `ConnectHealth`
   - `RewardCoinRegister`
   - `HatchView`

## 🛠️ Catatan Pengembangan

- `ContentView.swift` masih berisi template bawaan SwiftUI dan belum menjadi bagian dari flow utama.
- Beberapa screen gamification sudah siap sebagai fondasi dan bisa diintegrasikan lebih lanjut ke alur utama aplikasi.

## 🤝 Kontribusi

Silakan buat branch baru untuk setiap perubahan fitur, lalu ajukan pull request dengan ringkasan perubahan yang jelas.

---

Dibuat dengan semangat untuk bikin hidup lebih aktif dan lebih fun. 💛
