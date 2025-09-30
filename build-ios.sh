#!/bin/bash

# Build script for iOS SwiftUI app with Kotlin Multiplatform

echo "🚀 Building CoupleFox iOS App..."

# Check if we're in the right directory
if [ ! -f "settings.gradle.kts" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

# Build the shared module for iOS
echo "📱 Building shared module for iOS..."
./gradlew :shared:embedAndSignAppleFrameworkForXcode

if [ $? -eq 0 ]; then
    echo "✅ Shared module built successfully!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Open iosApp/iosApp.xcodeproj in Xcode"
    echo "2. Select your target device or simulator"
    echo "3. Build and run the project (Cmd+R)"
    echo ""
    echo "🎉 Your SwiftUI app is ready to run!"
else
    echo "❌ Build failed. Please check the error messages above."
    exit 1
fi
