# CoupleFox Setup Guide

This guide will help you set up the CoupleFox Kotlin Multiplatform project on a new machine.

## Prerequisites

### For iOS Development
- **macOS** (required for iOS development)
- **Xcode 15+** from Mac App Store
- **Xcode Command Line Tools**:
  ```bash
  xcode-select --install
  ```

### For Android Development
- **Android Studio** (recommended) or Android SDK
- **Java 8+** (JDK 8, 11, or 17)
- **Android SDK** (API level 24+)

## Quick Setup (Recommended)

### 1. Clone the Repository
```bash
git clone https://github.com/raaulc/couple-fox.git
cd couple-fox
```

### 2. Use Android Studio (Easiest Method)
1. **Open Android Studio**
2. **Open Project** → Select the `couple-fox` folder
3. **Android Studio will automatically**:
   - Download Gradle wrapper
   - Set up Android SDK
   - Download dependencies
   - Build the shared module

### 3. Build Shared Module for iOS
In Android Studio terminal or command line:
```bash
./gradlew :shared:embedAndSignAppleFrameworkForXcode
```

### 4. Open iOS Project in Xcode
```bash
open iosApp/iosApp.xcodeproj
```

### 5. Build and Run
- Select a simulator or device in Xcode
- Press Cmd+R to build and run

## Manual Setup (Alternative)

### 1. Install Prerequisites

#### macOS
```bash
# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Java (if needed)
brew install openjdk@17

# Install Xcode Command Line Tools
xcode-select --install
```

#### Android SDK (if not using Android Studio)
1. Download Android Studio or SDK command line tools
2. Set environment variables:
   ```bash
   export ANDROID_HOME=/path/to/android-sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
   ```

### 2. Configure Local Properties
Create or update `local.properties`:
```properties
# Update this path to your Android SDK location
sdk.dir=/Users/YourUsername/Library/Android/sdk
```

### 3. Build the Project
```bash
# Make gradlew executable
chmod +x gradlew

# Build shared module
./gradlew :shared:build

# Build Android app
./gradlew :androidApp:assembleDebug

# Build iOS framework
./gradlew :shared:embedAndSignAppleFrameworkForXcode
```

## Troubleshooting

### Common Issues

#### 1. "No such module 'shared'" Error
**Solution**: Build the shared module first
```bash
./gradlew :shared:embedAndSignAppleFrameworkForXcode
```

#### 2. Android SDK Not Found
**Solution**: Update `local.properties` with correct SDK path
```properties
sdk.dir=/path/to/your/android-sdk
```

#### 3. Xcode Command Line Tools Issues
**Solution**: Reinstall command line tools
```bash
sudo xcode-select --reset
xcode-select --install
```

#### 4. Java Version Issues
**Solution**: Set JAVA_HOME
```bash
export JAVA_HOME=/path/to/java
```

### Quick Test (Without Shared Module)

If you want to test the SwiftUI interface immediately:

1. **In Xcode**, temporarily rename files:
   - Rename `ContentView.swift` to `ContentView-Original.swift`
   - Rename `ContentView-NoShared.swift` to `ContentView.swift`

2. **Build and run** - this version uses mock data and doesn't require the shared module

## Project Structure

```
couple-fox/
├── shared/                 # Kotlin Multiplatform shared module
├── androidApp/             # Android app (Jetpack Compose)
├── iosApp/                 # iOS app (SwiftUI)
├── build.gradle.kts        # Root build configuration
├── settings.gradle.kts     # Project settings
├── local.properties        # Local configuration (create this)
└── SETUP.md               # This file
```

## Development Workflow

### Building for iOS
```bash
./gradlew :shared:embedAndSignAppleFrameworkForXcode
open iosApp/iosApp.xcodeproj
```

### Building for Android
```bash
./gradlew :androidApp:assembleDebug
```

### Running Tests
```bash
./gradlew test
```

## Need Help?

1. **Check the logs** in Android Studio or Xcode
2. **Verify all prerequisites** are installed
3. **Try the mock version** first to test SwiftUI
4. **Use Android Studio** for easiest setup

## Environment-Specific Notes

### macOS with Apple Silicon (M1/M2)
- Use ARM64 versions of tools
- Xcode will handle architecture automatically

### macOS with Intel
- Standard x86_64 setup
- No special configuration needed

### Different Java Versions
- Java 8, 11, or 17 are supported
- Set JAVA_HOME if multiple versions installed
