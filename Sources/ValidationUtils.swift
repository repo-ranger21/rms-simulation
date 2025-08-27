import Foundation

/// Utility functions for form validation
public struct ValidationUtils {
    
    /// Validate email format using simple string checks
    /// - Parameter email: Email string to validate
    /// - Returns: True if email format is valid
    public static func isValidEmail(_ email: String) -> Bool {
        // Simple email validation without regex for cross-platform compatibility
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        
        let parts = trimmed.components(separatedBy: "@")
        guard parts.count == 2 else { return false }
        
        let localPart = parts[0]
        let domainPart = parts[1]
        
        guard !localPart.isEmpty && !domainPart.isEmpty else { return false }
        guard domainPart.contains(".") else { return false }
        
        let domainComponents = domainPart.components(separatedBy: ".")
        guard domainComponents.count >= 2 else { return false }
        guard domainComponents.allSatisfy({ !$0.isEmpty }) else { return false }
        
        return true
    }
    
    /// Validate password meets minimum requirements
    /// - Parameter password: Password to validate
    /// - Returns: True if password meets requirements (at least 6 characters)
    public static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    /// Check if login form is complete and valid
    /// - Parameters:
    ///   - email: Email address
    ///   - password: Password
    /// - Returns: True if both fields are valid
    public static func isValidLoginForm(email: String, password: String) -> Bool {
        return isValidEmail(email) && isValidPassword(password) && !email.isEmpty && !password.isEmpty
    }
}