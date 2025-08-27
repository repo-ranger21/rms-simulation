# RMS Simulation - CivicAI Backend Service

A Swift package providing comprehensive backend services for CivicAI applications through Supabase integration.

## Features

- **Authentication**: Complete auth flow including sign in/up, OAuth, and session management
- **Real-time Updates**: Live database change subscriptions
- **Database Operations**: Type-safe CRUD operations
- **Storage Management**: File upload/download capabilities  
- **SwiftUI Integration**: Reactive ViewModels with Combine publishers

## Quick Start

```swift
import RMSSimulation

// Initialize service
let service = SupabaseService(
    supabaseURL: URL(string: "https://your-project.supabase.co")!,
    supabaseKey: "your-anon-key"
)

// Authenticate user
try await service.signIn(email: "user@example.com", password: "password")

// Query data
let users = try await service.query("users", as: User.self)
    .select()
    .execute()
    .value
```

## Documentation

See [SupabaseService Documentation](Documentation/SupabaseService.md) for complete usage examples and API reference.

## Installation

Add this package to your Swift project:

```swift
.package(url: "https://github.com/repo-ranger21/rms-simulation.git", from: "1.0.0")
```

## Requirements

- iOS 16.0+ / macOS 13.0+
- Swift 5.9+