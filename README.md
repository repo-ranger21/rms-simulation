# RMS Simulation - Restaurant Management System

A SwiftUI-based Restaurant Management System simulation with integrated Supabase authentication.

## Features

### 🔐 Authentication
- **Email/Password Authentication**: Secure sign-in and sign-up
- **OAuth Integration**: Support for Google, Facebook, and X/Twitter
- **Session Management**: Automatic session handling with Supabase
- **Error Handling**: User-friendly error messages and validation

### 🎨 User Interface
- **Animated Components**: Smooth transitions and hover effects
- **Modular Design**: Reusable sign-in button components
- **Loading States**: Visual feedback for asynchronous operations
- **Responsive Layout**: Optimized for different screen sizes

### 🏗️ Architecture
- **Swift Package Manager**: Clean dependency management
- **Modular Components**: Separated Views, Components, and Services
- **Cross-Platform**: Supports iOS 15+ and macOS 12+
- **Modern Swift**: Uses async/await patterns

## Quick Start

1. **Clone the repository**
2. **Configure Supabase** following the instructions in `SUPABASE_SETUP.md`
3. **Open in Xcode** or build with Swift Package Manager
4. **Run the sample app** to see the authentication flow

## Project Structure

```
Sources/RMSSimulation/
├── Views/
│   └── LoginView.swift          # Main login interface
├── Components/
│   ├── OAuthSignInButton.swift  # Reusable OAuth buttons
│   └── AnimatedTextField.swift  # Animated input fields
├── Services/
│   └── SupabaseService.swift    # Authentication service
├── RMSSimulation.swift          # Main library file
└── RMSApp.swift                 # Sample app implementation
```

## Usage

```swift
import SwiftUI
import RMSSimulation

struct ContentView: View {
    var body: some View {
        LoginView()
    }
}
```

## Requirements

- iOS 15.0+ / macOS 12.0+
- Swift 5.8+
- Xcode 14.0+

## License

MIT License - see `LICENSE` file for details.