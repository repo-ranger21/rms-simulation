import SwiftUI
import RMSSimulation

/// Sample app demonstrating the LoginView with Supabase authentication
@main
struct RMSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        Group {
            if isAuthenticated {
                MainAppView()
            } else {
                LoginView()
                    .onReceive(NotificationCenter.default.publisher(for: .authenticationSuccess)) { _ in
                        withAnimation {
                            isAuthenticated = true
                        }
                    }
            }
        }
    }
}

struct MainAppView: View {
    var body: some View {
        VStack {
            Text("Welcome to RMS Simulation!")
                .font(.title)
                .padding()
            
            Text("You are successfully authenticated")
                .foregroundColor(.secondary)
        }
    }
}

extension Notification.Name {
    static let authenticationSuccess = Notification.Name("authenticationSuccess")
}