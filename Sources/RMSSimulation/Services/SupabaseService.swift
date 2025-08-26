import Foundation
import Supabase

/// Configuration and client setup for Supabase authentication
public class SupabaseService {
    public static let shared = SupabaseService()
    
    public let client: SupabaseClient
    
    private init() {
        // Configure these with your actual Supabase project credentials
        let supabaseURL = URL(string: "https://your-project-id.supabase.co")!
        let supabaseKey = "your-anon-key"
        
        client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
    }
    
    /// Sign in with email and password
    public func signInWithEmail(email: String, password: String) async throws -> User {
        let response = try await client.auth.signIn(email: email, password: password)
        return response.user
    }
    
    /// Sign in with OAuth provider
    public func signInWithOAuth(provider: Provider) async throws -> URL {
        return try await client.auth.getOAuthSignInURL(provider: provider, redirectTo: nil)
    }
    
    /// Sign up with email and password
    public func signUpWithEmail(email: String, password: String) async throws -> User {
        let response = try await client.auth.signUp(email: email, password: password)
        return response.user
    }
    
    /// Sign out current user
    public func signOut() async throws {
        try await client.auth.signOut()
    }
    
    /// Get current session
    public func getCurrentSession() async throws -> Session? {
        return try await client.auth.session
    }
    
    /// Get current user
    public func getCurrentUser() -> User? {
        return client.auth.currentUser
    }
}