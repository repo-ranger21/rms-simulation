import Foundation
import Supabase

/// Simplified Service class for handling authentication with Supabase backend
/// This is the core authentication logic without UI dependencies
class SupabaseAuthService {
    static let shared = SupabaseAuthService()
    
    private var client: SupabaseClient?
    private(set) var isAuthenticated = false
    private(set) var currentUser: User?
    
    private init() {
        setupClient()
    }
    
    /// Initialize Supabase client - called on first use
    private func setupClient() {
        guard let url = URL(string: SupabaseConfig.url) else {
            print("Invalid Supabase URL in configuration")
            return
        }
        
        // Initialize with minimal configuration for now
        // In a real app, customize auth options as needed
        do {
            self.client = SupabaseClient(
                supabaseURL: url,
                supabaseKey: SupabaseConfig.anonKey,
                options: .init(
                    auth: .init(
                        storage: InMemoryLocalStorage()
                    )
                )
            )
        } catch {
            print("Failed to initialize Supabase client: \(error)")
        }
    }
    
    /// Check current authentication status
    func checkAuthStatus() async {
        guard let client = client else { return }
        
        do {
            let session = try await client.auth.session
            self.currentUser = session.user
            self.isAuthenticated = true
        } catch {
            self.currentUser = nil
            self.isAuthenticated = false
        }
    }
    
    /// Sign in with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Success status and optional error message
    func signIn(email: String, password: String) async -> (success: Bool, error: String?) {
        guard let client = client else {
            return (false, "Authentication service not initialized")
        }
        
        do {
            let session = try await client.auth.signIn(
                email: email,
                password: password
            )
            
            self.currentUser = session.user
            self.isAuthenticated = true
            return (true, nil)
            
        } catch let error as AuthError {
            return (false, error.localizedDescription)
        } catch {
            return (false, "An unexpected error occurred during sign in")
        }
    }
    
    /// Sign out current user
    func signOut() async -> (success: Bool, error: String?) {
        guard let client = client else {
            return (false, "Authentication service not initialized")
        }
        
        do {
            try await client.auth.signOut()
            self.currentUser = nil
            self.isAuthenticated = false
            return (true, nil)
        } catch {
            return (false, "Failed to sign out")
        }
    }
    
    /// Sign up new user with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Success status and optional error message
    func signUp(email: String, password: String) async -> (success: Bool, error: String?) {
        guard let client = client else {
            return (false, "Authentication service not initialized")
        }
        
        do {
            let response = try await client.auth.signUp(
                email: email,
                password: password
            )
            
            self.currentUser = response.user
            self.isAuthenticated = response.session != nil
            return (true, nil)
            
        } catch let error as AuthError {
            return (false, error.localizedDescription)
        } catch {
            return (false, "An unexpected error occurred during sign up")
        }
    }
}