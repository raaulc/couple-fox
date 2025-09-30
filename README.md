# CoupleFox - Kotlin Multiplatform Project

A Kotlin Multiplatform project demonstrating a clean architecture pattern with shared business logic between Android and iOS platforms.

## Architecture Overview

This project follows a **Clean Architecture** pattern with clear separation of concerns across multiple layers:

### Project Structure

```
couple-fox/
├── shared/                 # Kotlin Multiplatform shared module
│   ├── src/commonMain/kotlin/
│   │   ├── domain/         # Domain layer (models, use cases)
│   │   ├── data/           # Data layer (repositories, DTOs, mappers)
│   │   ├── network/        # Network layer (API client, services)
│   │   └── di/             # Dependency injection
├── androidApp/             # Android application (Jetpack Compose)
└── iosApp/                 # iOS application (SwiftUI)
```

### Architecture Layers

#### 1. Domain Layer (`shared/domain/`)
- **Models**: Core business entities (`User`, `Message`)
- **Use Cases**: Business logic operations
  - `GetCurrentUserUseCase`
  - `UpdateUserUseCase`
  - `GetMessagesUseCase`
  - `SendMessageUseCase`

#### 2. Data Layer (`shared/data/`)
- **Repositories**: Data access abstraction
  - `UserRepository` / `UserRepositoryImpl`
  - `MessageRepository` / `MessageRepositoryImpl`
- **DTOs**: Data transfer objects for API communication
  - `UserDto`, `MessageDto`, `ApiResponse`
- **Mappers**: Convert between domain models and DTOs
  - `UserMapper`, `MessageMapper`

#### 3. Network Layer (`shared/network/`)
- **ApiClient**: HTTP client configuration with Ktor
- **ApiService**: API endpoint definitions and implementations
- **Features**:
  - JSON serialization with Kotlinx Serialization
  - Timeout configuration
  - Content negotiation

#### 4. Dependency Injection (`shared/di/`)
- **ServiceLocator**: Lightweight manual DI implementation
- **Benefits**:
  - No external DI framework dependencies
  - Simple and explicit dependency wiring
  - Easy to understand and maintain

### Platform-Specific Implementation

#### Android App (`androidApp/`)
- **UI Framework**: Jetpack Compose
- **Architecture**: MVVM with ViewModels
- **Features**:
  - Material Design 3 theming
  - State management with StateFlow
  - Error handling and loading states

#### iOS App (`iosApp/`)
- **UI Framework**: SwiftUI
- **Architecture**: MVVM with ObservableObject
- **Features**:
  - Native iOS design patterns
  - Combine framework integration
  - Async/await support

## Key Technologies

### Shared Module
- **Kotlin Multiplatform**: 1.9.20
- **Ktor**: HTTP client and networking
- **Kotlinx Serialization**: JSON serialization
- **Kotlinx Coroutines**: Asynchronous programming
- **Kotlinx DateTime**: Date/time handling

### Android
- **Jetpack Compose**: Modern declarative UI
- **Material Design 3**: Design system
- **ViewModel**: UI state management
- **Navigation Compose**: Navigation handling

### iOS
- **SwiftUI**: Declarative UI framework
- **Combine**: Reactive programming
- **Async/Await**: Modern concurrency

## Data Flow

1. **UI Layer** (Android/iOS) triggers a use case
2. **Use Case** calls the appropriate repository
3. **Repository** makes network requests via ApiService
4. **ApiService** uses ApiClient to perform HTTP operations
5. **Response** flows back through mappers to convert DTOs to domain models
6. **UI** updates based on the result

## Getting Started

### 🚀 Quick Start (5 minutes)
```bash
# Clone the repository
git clone https://github.com/raaulc/couple-fox.git
cd couple-fox

# Run setup script
./setup.sh

# Open in Android Studio (recommended)
open -a "Android Studio" .

# Or open iOS project directly
open iosApp/iosApp.xcodeproj
```

**📖 For detailed setup instructions, see [SETUP.md](SETUP.md)**  
**⚡ For quick testing, see [QUICK_START.md](QUICK_START.md)**

### Prerequisites
- **macOS** (required for iOS development)
- **Android Studio** (recommended) or Android SDK
- **Xcode 15+** (for iOS development)
- **Java 8+** (JDK 8, 11, or 17)

### Building the Project

#### Method 1: Android Studio (Recommended)
1. Open project in Android Studio
2. Wait for Gradle sync
3. Build shared module: `./gradlew :shared:embedAndSignAppleFrameworkForXcode`
4. Open iOS project in Xcode

#### Method 2: Command Line
```bash
# Make gradlew executable
chmod +x gradlew

# Build shared module
./gradlew :shared:embedAndSignAppleFrameworkForXcode

# Build Android app
./gradlew :androidApp:assembleDebug

# Open iOS project
open iosApp/iosApp.xcodeproj
```

#### Quick Test (No Build Required)
If you want to test the SwiftUI interface immediately:
1. In Xcode, rename `ContentView-NoShared.swift` to `ContentView.swift`
2. Build and run - works with mock data!

## Architecture Benefits

1. **Code Reuse**: Business logic shared between platforms
2. **Maintainability**: Clear separation of concerns
3. **Testability**: Each layer can be tested independently
4. **Scalability**: Easy to add new features and platforms
5. **Type Safety**: Kotlin's type system ensures compile-time safety
6. **Performance**: Native platform UIs with shared business logic

## Future Enhancements

- Add local database with SQLDelight
- Implement offline support
- Add unit and integration tests
- Include dependency injection with Koin or Hilt
- Add push notifications
- Implement real-time messaging with WebSockets

## License

This project is for educational and demonstration purposes.
