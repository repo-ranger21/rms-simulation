# CivicAI iOS App

This directory contains the iOS application components for CivicAI, an app focused on empowering civic engagement.

## Structure

```
CivicAI/
├── Views/
│   └── LoginView.swift    # User authentication screen
└── README.md             # This file
```

## Views

### LoginView.swift

A comprehensive SwiftUI login screen featuring:

- **CivicAI Branding**: Custom color scheme and logo integration
- **OAuth Authentication**: Support for Google, Facebook, and X (Twitter)
- **Email/Password Login**: Traditional authentication option
- **Accessibility Support**: Full VoiceOver compatibility with proper labels and hints
- **Responsive Design**: Adapts to different screen sizes using GeometryReader
- **User Experience**: Loading states, form validation, and intuitive navigation
- **Security Features**: Password visibility toggle and secure text entry

## Features

- Modern SwiftUI implementation following iOS design guidelines
- Custom reusable components (`OAuthButton`, `CustomTextField`)
- Accessibility-first design with proper semantic labels
- Brand-consistent color scheme and typography
- Support for both light and dark mode
- Responsive layout that works across device sizes

## Usage

This LoginView can be integrated into an iOS app project by:

1. Adding the file to an Xcode project
2. Implementing the authentication methods
3. Connecting to actual OAuth providers and backend services
4. Adding proper error handling and navigation

## Dependencies

- SwiftUI (iOS 14.0+)
- Standard iOS frameworks (no external dependencies required)