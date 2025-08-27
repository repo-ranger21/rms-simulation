# SupabaseService Documentation

## Overview

`SupabaseService` is a comprehensive Swift service class that handles all backend interactions for CivicAI applications. It provides a clean interface for authentication, database operations, real-time updates, and storage management using Supabase.

## Features

- **Authentication**: Sign in/up, OAuth, password management
- **Session Management**: Automatic session handling and state management
- **Real-time Updates**: Subscribe to database changes
- **Database Operations**: CRUD operations with type safety
- **Storage**: File upload/download/management
- **ViewModel Integration**: Combine publishers and async helpers

## Installation

Add this package to your Swift project:

```swift
.package(url: "https://github.com/repo-ranger21/rms-simulation.git", from: "1.0.0")
```

## Configuration

### Environment Variables
Set these environment variables or pass them during initialization:
- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_ANON_KEY`: Your Supabase anonymous key

### Basic Setup

```swift
import RMSSimulation

// Using shared instance (requires environment variables)
let service = SupabaseService.shared

// Or initialize with custom configuration
let service = SupabaseService(
    supabaseURL: URL(string: "https://your-project.supabase.co")!,
    supabaseKey: "your-anon-key"
)
```

## Usage Examples

### Authentication

```swift
// Sign up
try await service.signUp(email: "user@example.com", password: "password")

// Sign in
try await service.signIn(email: "user@example.com", password: "password")

// OAuth sign in
try await service.signInWithOAuth(provider: .google)

// Sign out
try await service.signOut()

// Reset password
try await service.resetPassword(email: "user@example.com")
```

### Database Operations

```swift
// Query data
let users = try await service.query("users", as: User.self)
    .select()
    .execute()
    .value

// Insert data
let newUser = User(name: "John", email: "john@example.com")
try await service.insert(newUser, into: "users")

// Update data
let updatedUser = User(name: "Jane", email: "jane@example.com")
try await service.update(updatedUser, in: "users", matching: "id=123")

// Delete data
try await service.delete(from: "users", matching: "id=123")
```

### Real-time Updates

```swift
// Subscribe to table changes
let tableSubscription = service.subscribeToTable("users")
    .sink { message in
        print("Table updated: \(message)")
    }

// Subscribe to specific row changes
let rowSubscription = service.subscribeToRow(in: "users", id: "123")
    .sink { message in
        print("Row updated: \(message)")
    }

// Unsubscribe from all
await service.unsubscribeAll()
```

### Storage Operations

```swift
// Upload file
let imageData = Data() // Your image data
let publicURL = try await service.uploadFile(
    bucketName: "avatars",
    fileName: "user-avatar.jpg",
    data: imageData,
    contentType: "image/jpeg"
)

// Download file
let fileData = try await service.downloadFile(
    bucketName: "avatars",
    fileName: "user-avatar.jpg"
)

// Get public URL
let url = try service.getPublicURL(
    bucketName: "avatars",
    fileName: "user-avatar.jpg"
)
```

### SwiftUI Integration

```swift
import SwiftUI
import RMSSimulation

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let supabaseService = SupabaseService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAuthListener()
    }
    
    func loadUsers() {
        isLoading = true
        
        supabaseService.performAsync(
            operation: {
                try await self.supabaseService.query("users", as: User.self)
                    .select()
                    .execute()
                    .value
            },
            onSuccess: { users in
                self.users = users
                self.isLoading = false
            },
            onError: { error in
                self.error = error.localizedDescription
                self.isLoading = false
            }
        )
    }
    
    private func setupAuthListener() {
        supabaseService.authStatePublisher
            .sink { state in
                switch state {
                case .authenticated:
                    self.loadUsers()
                case .notAuthenticated:
                    self.users = []
                case .loading:
                    self.isLoading = true
                }
            }
            .store(in: &cancellables)
    }
}

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        List(viewModel.users, id: \.id) { user in
            Text(user.name)
        }
        .refreshable {
            viewModel.loadUsers()
        }
    }
}
```

### Error Handling

```swift
// Using Result type
let result = await service.executeOperation {
    try await service.query("users", as: User.self)
        .select()
        .execute()
        .value
}

switch result {
case .success(let users):
    print("Loaded \(users.count) users")
case .failure(let error):
    switch error {
    case .authenticationFailed(let message):
        print("Auth error: \(message)")
    case .databaseError(let message):
        print("Database error: \(message)")
    default:
        print("Other error: \(error.localizedDescription)")
    }
}
```

### Batch Operations

```swift
let operations = [
    { try await self.service.insert(user1, into: "users") },
    { try await self.service.insert(user2, into: "users") },
    { try await self.service.insert(user3, into: "users") }
]

let results = await service.executeBatch(operations)
// Handle results array
```

## State Management

The service provides reactive state management through Combine:

```swift
@Published public private(set) var currentUser: User?
@Published public private(set) var isAuthenticated: Bool = false
@Published public private(set) var sessionState: SessionState = .notAuthenticated
```

Subscribe to these properties in your ViewModels for automatic UI updates.

## Thread Safety

The service is marked with `@MainActor` to ensure all operations run on the main thread, making it safe for direct UI updates.

## Best Practices

1. Use the shared instance for most cases
2. Handle errors appropriately using the provided error types
3. Unsubscribe from real-time updates when not needed
4. Use the ViewModel integration helpers for SwiftUI
5. Store sensitive configuration in environment variables
6. Use batch operations for multiple related database operations