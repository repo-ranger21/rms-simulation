import Foundation
import Supabase

/// Service class for handling authentication with Supabase backend
@MainActor
class SupabaseService: ObservableObject {
    static let shared = SupabaseService()
    
    private let client: SupabaseClient
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private init() {
        // Initialize Supabase client using configuration
        let url = URL(string: SupabaseConfig.url)!
        let key = SupabaseConfig.anonKey
        
        self.client = SupabaseClient(supabaseURL: url, supabaseKey: key)
        
        // Check for existing session
        Task {
            await checkAuthStatus()
        }
    }
    
    /// Check current authentication status
    private func checkAuthStatus() async {
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
        do {
            let response = try await client.auth.signUp(
                email: email,
                password: password
            )
            
            if let user = response.user {
                self.currentUser = user
                self.isAuthenticated = response.session != nil
                return (true, nil)
            } else {
                return (false, "Sign up successful, please check your email for verification")
            }
            
        } catch let error as AuthError {
            return (false, error.localizedDescription)
        } catch {
            return (false, "An unexpected error occurred during sign up")
        }
    }
}