import SwiftUI

/// Main app entry point for CivicAI
/// Use this in your main app target
struct CivicAIApp: App {
    @StateObject private var supabaseService = SupabaseService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(supabaseService)
        }
    }
}

/// Root content view that handles navigation between login and main app
struct ContentView: View {
    @EnvironmentObject private var supabaseService: SupabaseService
    
    var body: some View {
        Group {
            if supabaseService.isAuthenticated {
                // Main authenticated app view
                MainAppView()
            } else {
                // Login view for unauthenticated users
                LoginView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: supabaseService.isAuthenticated)
    }
}

/// Placeholder main app view for authenticated users
struct MainAppView: View {
    @EnvironmentObject private var supabaseService: SupabaseService
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to CivicAI!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let user = supabaseService.currentUser {
                    Text("Hello, \(user.email ?? "User")!")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Sign Out") {
                    Task {
                        await signOut()
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(12)
                .padding(.horizontal, 30)
            }
            .padding()
            .navigationTitle("CivicAI")
        }
    }
    
    private func signOut() async {
        let result = await supabaseService.signOut()
        if !result.success {
            // Handle sign out error if needed
            print("Sign out failed: \(result.error ?? "Unknown error")")
        }
    }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SupabaseService.shared)
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
            .environmentObject(SupabaseService.shared)
    }
}