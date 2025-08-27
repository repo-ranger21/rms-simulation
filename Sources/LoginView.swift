import SwiftUI

/// LoginView provides a user-friendly interface for authentication
/// Features email/password fields, login button, and comprehensive error handling
struct LoginView: View {
    @StateObject private var supabaseService = SupabaseService.shared
    
    // Form fields
    @State private var email: String = ""
    @State private var password: String = ""
    
    // UI state
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isSecureTextEntry: Bool = true
    
    // Form validation
    private var isFormValid: Bool {
        !email.isEmpty && 
        !password.isEmpty && 
        email.contains("@") && 
        email.contains(".") &&
        password.count >= 6
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Logo/Title Section
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                        
                        Text("CivicAI")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Welcome back")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 50)
                    
                    // Login Form
                    VStack(spacing: 20) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.white.opacity(0.7))
                                    .frame(width: 20)
                                
                                TextField("Enter your email", text: $email)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.white)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                    .disabled(isLoading)
                            }
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.white.opacity(0.7))
                                    .frame(width: 20)
                                
                                Group {
                                    if isSecureTextEntry {
                                        SecureField("Enter your password", text: $password)
                                    } else {
                                        TextField("Enter your password", text: $password)
                                    }
                                }
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.white)
                                .disabled(isLoading)
                                
                                Button(action: {
                                    isSecureTextEntry.toggle()
                                }) {
                                    Image(systemName: isSecureTextEntry ? "eye.slash" : "eye")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .disabled(isLoading)
                            }
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        // Login Button
                        Button(action: {
                            Task {
                                await performLogin()
                            }
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.title2)
                                }
                                
                                Text(isLoading ? "Signing In..." : "Sign In")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Group {
                                    if isFormValid && !isLoading {
                                        Color.white.opacity(0.2)
                                    } else {
                                        Color.white.opacity(0.1)
                                    }
                                }
                            )
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                            )
                        }
                        .disabled(!isFormValid || isLoading)
                        .animation(.easeInOut(duration: 0.2), value: isFormValid)
                        
                        // Forgot Password Link
                        Button("Forgot Password?") {
                            // TODO: Implement forgot password functionality
                        }
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // Sign Up Link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.white.opacity(0.8))
                        
                        Button("Sign Up") {
                            // TODO: Navigate to sign up view
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    }
                    .font(.subheadline)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Login Failed", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        } message: {
            Text(errorMessage)
        }
        .onSubmit {
            // Handle return key press
            if isFormValid {
                Task {
                    await performLogin()
                }
            }
        }
    }
    
    /// Perform login authentication with error handling
    @MainActor
    private func performLogin() async {
        // Validate form
        guard isFormValid else {
            showErrorMessage("Please fill in all fields with valid information")
            return
        }
        
        // Additional email validation
        guard isValidEmail(email) else {
            showErrorMessage("Please enter a valid email address")
            return
        }
        
        // Additional password validation
        guard password.count >= 6 else {
            showErrorMessage("Password must be at least 6 characters long")
            return
        }
        
        isLoading = true
        
        let result = await supabaseService.signIn(email: email, password: password)
        
        isLoading = false
        
        if result.success {
            // Login successful - the SupabaseService will handle state updates
            // Clear form fields for security
            email = ""
            password = ""
        } else {
            // Show error message
            showErrorMessage(result.error ?? "Login failed. Please try again.")
        }
    }
    
    /// Show error message to user
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    /// Validate email format
    func isValidEmail(_ email: String) -> Bool {
        return ValidationUtils.isValidEmail(email)
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        
        LoginView()
            .preferredColorScheme(.light)
            .previewDisplayName("Light Mode")
    }
}