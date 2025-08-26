import SwiftUI
import Supabase
#if canImport(UIKit)
import UIKit
#endif

/// Main login view with Supabase authentication integration
public struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isSignUp = false
    
    private let supabaseService = SupabaseService.shared
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                emailLoginSection
                
                Divider()
                    .overlay(
                        Text("or")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                            .background(Color(.systemBackground))
                    )
                
                oauthSection
                
                toggleSignUpSection
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
        .background(Color(.systemBackground))
        .alert("Authentication Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "building.2.crop.circle")
                .font(.system(size: 64))
                .foregroundColor(.accentColor)
                .scaleEffect(isLoading ? 0.8 : 1.0)
                .animation(.easeInOut(duration: 0.3).repeatCount(isLoading ? .max : 1, autoreverses: true), value: isLoading)
            
            Text("RMS Simulation")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(isSignUp ? "Create your account" : "Welcome back")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Email Login Section
    private var emailLoginSection: some View {
        VStack(spacing: 16) {
            AnimatedTextField(placeholder: "Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            AnimatedTextField(placeholder: "Password", text: $password, isSecure: true)
            
            PrimaryButton(
                title: isSignUp ? "Create Account" : "Sign In",
                isLoading: isLoading
            ) {
                Task {
                    await handleEmailAuthentication()
                }
            }
            .disabled(email.isEmpty || password.isEmpty)
        }
    }
    
    // MARK: - OAuth Section
    private var oauthSection: some View {
        VStack(spacing: 12) {
            OAuthSignInButton(provider: .google) {
                Task {
                    await handleOAuthSignIn(provider: .google)
                }
            }
            .disabled(isLoading)
            
            OAuthSignInButton(provider: .facebook) {
                Task {
                    await handleOAuthSignIn(provider: .facebook)
                }
            }
            .disabled(isLoading)
            
            OAuthSignInButton(provider: .twitter) {
                Task {
                    await handleOAuthSignIn(provider: .twitter)
                }
            }
            .disabled(isLoading)
        }
        .opacity(isLoading ? 0.6 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
    
    // MARK: - Toggle Sign Up Section
    private var toggleSignUpSection: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                isSignUp.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                    .foregroundColor(.secondary)
                
                Text(isSignUp ? "Sign In" : "Sign Up")
                    .foregroundColor(.accentColor)
                    .fontWeight(.medium)
            }
            .font(.system(size: 14))
        }
        .disabled(isLoading)
    }
    
    // MARK: - Authentication Methods
    private func handleEmailAuthentication() async {
        isLoading = true
        
        do {
            if isSignUp {
                _ = try await supabaseService.signUpWithEmail(email: email, password: password)
            } else {
                _ = try await supabaseService.signInWithEmail(email: email, password: password)
            }
            
            // Handle successful authentication
            await MainActor.run {
                // Navigate to main app or handle success
                print("Authentication successful!")
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    private func handleOAuthSignIn(provider: OAuthProvider) async {
        isLoading = true
        
        do {
            let supabaseProvider: Provider
            switch provider {
            case .google:
                supabaseProvider = .google
            case .facebook:
                supabaseProvider = .facebook
            case .twitter:
                supabaseProvider = .twitter
            }
            
            let url = try await supabaseService.signInWithOAuth(provider: supabaseProvider)
            
            await MainActor.run {
                // Open OAuth URL in browser or web view
                #if canImport(UIKit)
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                #else
                // For macOS or other platforms
                print("OAuth URL: \(url)")
                #endif
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif