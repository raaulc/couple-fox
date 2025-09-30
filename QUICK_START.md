# 🚀 Quick Start Guide

**Get CoupleFox running on a new machine in 5 minutes!**

## Step 1: Clone & Open
```bash
git clone https://github.com/raaulc/couple-fox.git
cd couple-fox
```

## Step 2: Open in Android Studio
1. Open **Android Studio**
2. **Open Project** → Select the `couple-fox` folder
3. Wait for Gradle sync to complete

## Step 3: Build Shared Module
In Android Studio terminal:
```bash
./gradlew :shared:embedAndSignAppleFrameworkForXcode
```

## Step 4: Open iOS Project
```bash
open iosApp/iosApp.xcodeproj
```

## Step 5: Run iOS App
1. Select a simulator in Xcode
2. Press **Cmd+R** to build and run

## ⚡ Quick Test (No Build Required)

Want to see the SwiftUI interface immediately?

1. **In Xcode**, rename files:
   - `ContentView.swift` → `ContentView-Original.swift`
   - `ContentView-NoShared.swift` → `ContentView.swift`

2. **Build and run** - works with mock data!

## 🆘 Troubleshooting

### "No such module 'shared'" Error
**Fix**: Build shared module first (Step 3 above)

### Android SDK Not Found
**Fix**: Android Studio will set this up automatically

### Xcode Issues
**Fix**: Install Xcode Command Line Tools:
```bash
xcode-select --install
```

## 📱 What You'll See

- Beautiful SwiftUI interface with heart icon
- User profile loading with animations
- Messages view with native iOS design
- Error handling and retry functionality

## 🎯 Next Steps

Once running, you can:
- Customize the UI colors and layout
- Add more SwiftUI views
- Integrate with the shared Kotlin module
- Add real backend API calls

**That's it! Your Kotlin Multiplatform app is running! 🎉**
