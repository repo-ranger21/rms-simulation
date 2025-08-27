import Foundation
import RMSSimulation

/// Example demonstrating basic SupabaseService usage
@main
struct SupabaseServiceExample {
    static func main() async {
        print("🚀 SupabaseService Example")
        print("========================")
        
        // Initialize service with custom configuration
        let service = SupabaseService(
            supabaseURL: URL(string: "https://your-project.supabase.co")!,
            supabaseKey: "your-anon-key"
        )
        
        print("✅ SupabaseService initialized")
        print("📊 Initial state:")
        print("   - Authenticated: \(service.isAuthenticated)")
        print("   - Current user: \(service.currentUser?.email ?? "none")")
        print("   - Session state: \(service.sessionState)")
        
        // Demonstrate error handling with executeOperation
        print("\n🔧 Testing error handling...")
        let result = await service.executeOperation {
            // This will fail since we don't have real Supabase credentials
            try await service.signIn(email: "test@example.com", password: "password")
        }
        
        switch result {
        case .success:
            print("✅ Authentication successful")
        case .failure(let error):
            print("❌ Expected authentication error: \(error.localizedDescription)")
        }
        
        print("\n📚 Service features available:")
        print("   - Authentication (sign in/up, OAuth)")
        print("   - Session management")
        print("   - Database operations (CRUD)")
        print("   - Real-time subscriptions")
        print("   - File storage")
        print("   - Error handling & batch operations")
        
        #if canImport(Combine)
        print("   - Combine publishers for reactive programming")
        #else
        print("   - Basic state management (Combine not available)")
        #endif
        
        print("\n🎉 SupabaseService is ready for integration!")
    }
}