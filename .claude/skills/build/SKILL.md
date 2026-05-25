---
name: build
description: Build the FitChick iOS project using xcodebuild
---

# FitChick iOS Build Skill

## Build Command

```bash
cd /Users/neuhendra/Developer/FitChick && xcodebuild -project FitChick.xcodeproj -scheme FitChick -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

## Project Info

- **Project**: FitChick
- **Scheme**: FitChick
- **Default Simulator**: iPhone 17 Pro
- **Target**: FitChick
- **Config**: Debug / Release

## Available Simulators

- iPhone 17 Pro
- iPhone 17 Pro Max
- iPhone 17e
- iPhone Air
- iPhone 17
- iPhone 16e
- iPad Pro / iPad Air / iPad mini

## How to Build

```bash
# Build for iPhone 17 Pro simulator
xcodebuild -project FitChick.xcodeproj -scheme FitChick -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build

# Build for specific simulator
xcodebuild -project FitChick.xcodeproj -scheme FitChick -configuration Debug -destination 'platform=iOS Simulator,name=<SIMULATOR_NAME>' build
```

## How to Run (with boot)

```bash
# Boot simulator first
xcrun simctl boot "iPhone 17 Pro"

# Then build and run
xcodebuild -project FitChick.xcodeproj -scheme FitChick -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

## Clean Build

```bash
xcodebuild -project FitChick.xcodeproj -scheme FitChick clean
```
