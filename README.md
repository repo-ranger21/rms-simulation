# CivicAI - RMS Simulation

A comprehensive SwiftUI-based dashboard workspace for CivicAI, designed to provide authenticated access to documents, datasets, and task management with integrated chat functionality.

## Features

### 🏠 DashboardView - Main Workspace
- **Authentication Support**: Secure login system with user state management
- **Documents Section**: Document management with upload, search, and recent files
- **Datasets Section**: Dataset overview, analysis tools, and data management
- **Task Management**: Task tracking, assignment, and progress monitoring
- **Responsive Design**: Adaptive layout for different screen sizes
- **Modular Architecture**: Clean, maintainable SwiftUI components

### 💬 ChatView - AI Assistant
- **Conversational Interface**: Interactive chat with CivicAI assistant
- **Context-Aware**: Understands workspace context (documents, datasets, tasks)
- **Real-time Messaging**: Live chat interface with typing indicators
- **Export Functionality**: Save and export chat conversations
- **Suggestion System**: Quick action suggestions for common queries

## Architecture

### Project Structure
```
Sources/CivicAI/
├── CivicAIApp.swift        # Main app entry point
├── DashboardView.swift     # Main workspace dashboard
└── ChatView.swift          # AI chat interface

Tests/CivicAITests/
└── CivicAITests.swift      # Unit tests
```

### Key Components

#### DashboardView.swift
- **Tab-based Navigation**: Documents, Datasets, Tasks sections
- **Quick Actions**: Context-sensitive action buttons
- **Overview Cards**: Summary statistics and metrics
- **List Views**: Recent items with status indicators
- **Navigation Integration**: Seamless chat access

#### ChatView.swift
- **Message Management**: Threaded conversation handling
- **AI Response Simulation**: Intelligent response generation
- **UI Components**: Modern chat interface with bubbles
- **State Management**: Message history and loading states

## Requirements

- **iOS 16.0+** or **macOS 13.0+**
- **Xcode 14.0+**
- **Swift 5.9+**

## Building and Running

### Prerequisites
This project uses SwiftUI and requires building on macOS with Xcode installed.

### Build Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/repo-ranger21/rms-simulation.git
   cd rms-simulation
   ```

2. **Open in Xcode**:
   ```bash
   open Package.swift
   ```
   Or drag the project folder to Xcode.

3. **Build and Run**:
   - Select your target device (iOS Simulator or Mac)
   - Press `Cmd+R` to build and run

### Swift Package Manager
```bash
# Build (requires macOS/Xcode environment)
swift build

# Run tests (requires macOS/Xcode environment)  
swift test
```

**Note**: SwiftUI requires Apple platforms. Building on Linux will fail as SwiftUI is not available.

## Usage

### Authentication
- Launch the app to see the login screen
- Tap "Sign In" to access the authenticated workspace
- Use the profile button to sign out

### Navigation
- **Tab Bar**: Switch between Documents, Datasets, and Tasks
- **Chat Button**: Access AI assistant (top-right toolbar)
- **Quick Actions**: Tap action buttons for common operations
- **Profile**: Access user settings and sign out

### Chat Integration
- Tap the chat icon in the navigation bar
- Ask questions about your workspace data
- Use suggested queries for common tasks
- Export chat history when needed

## Development

### Adding New Features
1. Create new SwiftUI views in `Sources/CivicAI/`
2. Follow the existing modular pattern
3. Add appropriate navigation and state management
4. Include tests in `Tests/CivicAITests/`

### Testing
- Unit tests cover basic functionality
- UI tests can be added for integration testing
- Preview providers enable rapid UI development

### Code Style
- SwiftUI declarative syntax
- MVVM pattern where appropriate
- Clear separation of concerns
- Comprehensive documentation

## Demo Data
The app includes sample data for demonstration:
- Mock documents with status indicators
- Sample datasets with processing states  
- Example tasks with priorities and due dates
- AI chat responses for testing

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

---

**CivicAI Dashboard** - Your comprehensive workspace for civic AI management.