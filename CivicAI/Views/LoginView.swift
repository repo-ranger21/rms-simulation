//
//  LoginView.swift
//  CivicAI
//
//  Created by CivicAI Development Team
//  Copyright © 2025 CivicAI. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecureTextEntry = true
    @State private var isLoading = false
    @FocusState private var focusedField: Field?
    
    enum Field: CaseIterable {
        case email, password
    }
    
    // CivicAI brand colors
    private let civicAIBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    private let civicAIDarkBlue = Color(red: 0.1, green: 0.3, blue: 0.7)
    private let civicAIGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header section with logo and branding
                    headerSection(geometry: geometry)
                    
                    // Main content
                    VStack(spacing: 32) {
                        // Welcome text
                        welcomeSection
                        
                        // OAuth buttons
                        oauthButtonsSection
                        
                        // Divider
                        dividerSection
                        
                        // Email/Password form
                        emailPasswordSection
                        
                        // Login button
                        loginButtonSection
                        
                        // Footer links
                        footerSection
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)
                }
            }
        }
        .background(civicAIGray.ignoresSafeArea())
        .accessibilityElement(children: .contain)
        .accessibilityLabel("CivicAI Login Screen")
    }
    
    // MARK: - Header Section
    private func headerSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 16) {
            // Logo placeholder - would typically load from assets
            Image(systemName: "building.2.crop.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(civicAIBlue)
                .accessibilityLabel("CivicAI Logo")
            
            Text("CivicAI")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(civicAIDarkBlue)
                .accessibilityAddTraits(.isHeader)
            
            Text("Empowering Civic Engagement")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, max(geometry.safeAreaInsets.top + 20, 60))
        .padding(.bottom, 20)
    }
    
    // MARK: - Welcome Section
    private var welcomeSection: some View {
        VStack(spacing: 8) {
            Text("Welcome Back")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .accessibilityAddTraits(.isHeader)
            
            Text("Sign in to continue your civic journey")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - OAuth Buttons Section
    private var oauthButtonsSection: some View {
        VStack(spacing: 12) {
            // Google OAuth Button
            OAuthButton(
                provider: "Google",
                iconName: "globe",
                backgroundColor: .white,
                textColor: .black,
                borderColor: Color(red: 0.9, green: 0.9, blue: 0.9),
                action: { authenticateWithGoogle() }
            )
            
            // Facebook OAuth Button
            OAuthButton(
                provider: "Facebook",
                iconName: "person.2.fill",
                backgroundColor: Color(red: 0.25, green: 0.4, blue: 0.75),
                textColor: .white,
                borderColor: Color(red: 0.25, green: 0.4, blue: 0.75),
                action: { authenticateWithFacebook() }
            )
            
            // X (Twitter) OAuth Button
            OAuthButton(
                provider: "X",
                iconName: "bird.fill",
                backgroundColor: .black,
                textColor: .white,
                borderColor: .black,
                action: { authenticateWithX() }
            )
        }
    }
    
    // MARK: - Divider Section
    private var dividerSection: some View {
        HStack {
            Rectangle()
                .fill(Color.secondary.opacity(0.3))
                .frame(height: 1)
            
            Text("or")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            Rectangle()
                .fill(Color.secondary.opacity(0.3))
                .frame(height: 1)
        }
        .accessibilityHidden(true)
    }
    
    // MARK: - Email/Password Section
    private var emailPasswordSection: some View {
        VStack(spacing: 16) {
            // Email field
            CustomTextField(
                title: "Email",
                text: $email,
                isSecure: false,
                keyboardType: .emailAddress,
                textContentType: .emailAddress
            )
            .focused($focusedField, equals: .email)
            .accessibilityLabel("Email address")
            .accessibilityHint("Enter your email address")
            
            // Password field
            CustomTextField(
                title: "Password",
                text: $password,
                isSecure: true,
                keyboardType: .default,
                textContentType: .password,
                showPasswordToggle: true,
                isSecureTextEntry: $isSecureTextEntry
            )
            .focused($focusedField, equals: .password)
            .accessibilityLabel("Password")
            .accessibilityHint("Enter your password")
        }
    }
    
    // MARK: - Login Button Section
    private var loginButtonSection: some View {
        VStack(spacing: 12) {
            Button(action: performEmailLogin) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Sign In")
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(civicAIBlue)
                .cornerRadius(12)
            }
            .disabled(email.isEmpty || password.isEmpty || isLoading)
            .opacity((email.isEmpty || password.isEmpty || isLoading) ? 0.6 : 1.0)
            .accessibilityLabel("Sign in with email and password")
            .accessibilityHint("Double tap to sign in")
            
            Button("Forgot Password?") {
                handleForgotPassword()
            }
            .font(.footnote)
            .foregroundColor(civicAIBlue)
            .accessibilityLabel("Forgot password")
            .accessibilityHint("Double tap to reset your password")
        }
    }
    
    // MARK: - Footer Section
    private var footerSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Don't have an account?")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Button("Sign Up") {
                    handleSignUp()
                }
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(civicAIBlue)
                .accessibilityLabel("Sign up for new account")
                .accessibilityHint("Double tap to create a new account")
            }
            
            Text("By signing in, you agree to our Terms of Service and Privacy Policy")
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
                .accessibilityLabel("Terms and privacy notice")
        }
    }
    
    // MARK: - Actions
    private func authenticateWithGoogle() {
        // Implement Google OAuth authentication
        print("Authenticating with Google...")
    }
    
    private func authenticateWithFacebook() {
        // Implement Facebook OAuth authentication
        print("Authenticating with Facebook...")
    }
    
    private func authenticateWithX() {
        // Implement X (Twitter) OAuth authentication
        print("Authenticating with X...")
    }
    
    private func performEmailLogin() {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        isLoading = true
        
        // Simulate login process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            // Implement actual email/password authentication
            print("Logging in with email: \(email)")
        }
    }
    
    private func handleForgotPassword() {
        // Implement forgot password functionality
        print("Forgot password tapped")
    }
    
    private func handleSignUp() {
        // Implement sign up navigation
        print("Sign up tapped")
    }
}

// MARK: - Supporting Views

struct OAuthButton: View {
    let provider: String
    let iconName: String
    let backgroundColor: Color
    let textColor: Color
    let borderColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.system(size: 18, weight: .medium))
                
                Text("Continue with \(provider)")
                    .fontWeight(.medium)
                
                Spacer()
            }
            .foregroundColor(textColor)
            .padding(.horizontal, 20)
            .frame(height: 50)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 1)
            )
            .cornerRadius(12)
        }
        .accessibilityLabel("Sign in with \(provider)")
        .accessibilityHint("Double tap to authenticate using your \(provider) account")
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let textContentType: UITextContentType?
    let showPasswordToggle: Bool
    @Binding var isSecureTextEntry: Bool
    
    init(
        title: String,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        showPasswordToggle: Bool = false,
        isSecureTextEntry: Binding<Bool> = .constant(true)
    ) {
        self.title = title
        self._text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.showPasswordToggle = showPasswordToggle
        self._isSecureTextEntry = isSecureTextEntry
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            HStack {
                Group {
                    if isSecure && isSecureTextEntry {
                        SecureField("", text: $text)
                    } else {
                        TextField("", text: $text)
                    }
                }
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                if showPasswordToggle {
                    Button(action: {
                        isSecureTextEntry.toggle()
                    }) {
                        Image(systemName: isSecureTextEntry ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.secondary)
                    }
                    .accessibilityLabel(isSecureTextEntry ? "Show password" : "Hide password")
                    .accessibilityHint("Double tap to toggle password visibility")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 1)
            )
        }
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.light)
            .previewDisplayName("Light Mode")
        
        LoginView()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}