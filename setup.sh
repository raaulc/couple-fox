#!/bin/bash

# CoupleFox Setup Script
# This script helps set up the project on a new machine

echo "🚀 CoupleFox Setup Script"
echo "========================="

# Check if we're in the right directory
if [ ! -f "settings.gradle.kts" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    echo "   cd couple-fox && ./setup.sh"
    exit 1
fi

echo "✅ Found project files"

# Check for required tools
echo ""
echo "🔍 Checking prerequisites..."

# Check for Java
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
    echo "✅ Java found: $JAVA_VERSION"
else
    echo "❌ Java not found. Please install Java 8+ or use Android Studio"
fi

# Check for Xcode
if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -n 1)
    echo "✅ $XCODE_VERSION found"
else
    echo "❌ Xcode not found. Please install Xcode from Mac App Store"
fi

# Check for Android SDK
if [ -d "$HOME/Library/Android/sdk" ]; then
    echo "✅ Android SDK found"
else
    echo "⚠️  Android SDK not found. Android Studio will set this up"
fi

echo ""
echo "🔧 Setting up project..."

# Make gradlew executable
chmod +x gradlew
echo "✅ Made gradlew executable"

# Create local.properties if it doesn't exist
if [ ! -f "local.properties" ]; then
    echo "📝 Creating local.properties..."
    cat > local.properties << EOF
# Android SDK location
sdk.dir=$HOME/Library/Android/sdk

# Alternative paths to try if the above doesn't work:
# sdk.dir=/Applications/Android Studio.app/Contents/jbr/Contents/Home
# sdk.dir=/usr/local/android-sdk
EOF
    echo "✅ Created local.properties"
else
    echo "✅ local.properties already exists"
fi

echo ""
echo "🏗️  Building shared module..."

# Try to build the shared module
if ./gradlew :shared:embedAndSignAppleFrameworkForXcode --quiet; then
    echo "✅ Shared module built successfully!"
else
    echo "⚠️  Shared module build failed. This is normal if:"
    echo "   - Xcode Command Line Tools are not installed"
    echo "   - Android SDK is not set up"
    echo ""
    echo "💡 Solutions:"
    echo "   1. Install Xcode Command Line Tools: xcode-select --install"
    echo "   2. Use Android Studio to build the project"
    echo "   3. Use the mock version to test SwiftUI (see QUICK_START.md)"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Open the project in Android Studio:"
echo "      open -a 'Android Studio' ."
echo ""
echo "   2. Or open iOS project in Xcode:"
echo "      open iosApp/iosApp.xcodeproj"
echo ""
echo "   3. For quick testing, see QUICK_START.md"
echo ""
echo "📚 Documentation:"
echo "   - SETUP.md - Detailed setup guide"
echo "   - QUICK_START.md - 5-minute quick start"
echo "   - README.md - Project overview"
echo ""
echo "🆘 Need help? Check the troubleshooting section in SETUP.md"
