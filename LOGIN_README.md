# CivicAI Login Implementation

This repository contains a SwiftUI-based login interface for CivicAI with Supabase backend integration.

## Features

### LoginView.swift
- **User-friendly Interface**: Clean, modern SwiftUI design with gradient background
- **Email & Password Fields**: Proper validation and secure input handling
- **Login Button**: Disabled state management based on form validation
- **Error Handling**: Comprehensive error messages for invalid credentials
- **Loading States**: Visual feedback during authentication process
- **Password Visibility Toggle**: Eye icon to show/hide password
- **Form Validation**: Real-time validation for email format and password requirements

### SupabaseService.swift
- **Authentication Methods**: Sign in, sign out, and sign up functionality
- **Error Handling**: Proper error propagation and user-friendly messages
- **Session Management**: Automatic session checking and user state management
- **Observable Pattern**: Uses `@Published` properties for reactive UI updates
- **Singleton Pattern**: Shared instance for app-wide authentication state

## Setup Instructions

1. **Install Dependencies**: 
   ```bash
   swift package resolve
   ```

2. **Configure Supabase**:
   - Update `Sources/SupabaseConfig.swift` with your Supabase project credentials
   - Replace `url` with your Supabase project URL
   - Replace `anonKey` with your Supabase anonymous API key

3. **Build and Run**:
   ```bash
   swift build
   swift run
   ```

## Architecture

```
Sources/
├── App.swift              # Main app entry point and navigation logic
├── LoginView.swift        # Login UI with form validation and error handling
├── SupabaseService.swift  # Authentication service with backend integration
└── SupabaseConfig.swift   # Configuration for Supabase credentials

Tests/
└── CivicAITests.swift     # Unit tests for validation logic
```

## Integration

The LoginView seamlessly integrates with SupabaseService through:
- **Reactive State Management**: Uses `@StateObject` and `@Published` for real-time updates
- **Async/Await Pattern**: Modern Swift concurrency for authentication calls  
- **Error Propagation**: Clear error messaging from backend to UI
- **Authentication Flow**: Automatic navigation between login and authenticated states

## Security Features

- **Input Validation**: Email format and password length requirements
- **Secure Text Entry**: Password field with toggle visibility
- **Form Sanitization**: Proper handling of user input
- **Session Management**: Automatic session validation and cleanup
- **Error Handling**: No sensitive information exposed in error messages

## Customization

The UI can be easily customized by modifying:
- **Colors**: Update gradient and accent colors in LoginView
- **Fonts**: Modify font styles and sizes
- **Layout**: Adjust spacing and component arrangement
- **Validation Rules**: Update password requirements and email validation

## Testing

Run tests with:
```bash
swift test
```

Current tests cover:
- Email validation logic
- Service initialization
- Basic error handling

## Requirements

- iOS 15.0+ / macOS 12.0+
- Swift 5.7+
- Xcode 14.0+
- Active Supabase project