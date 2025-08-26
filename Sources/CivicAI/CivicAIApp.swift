import SwiftUI

/// Main entry point for the CivicAI application
@main
struct CivicAIApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
    }
}

/// ContentView for compatibility and testing
struct ContentView: View {
    var body: some View {
        DashboardView()
    }
}

#Preview {
    ContentView()
}