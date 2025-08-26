import SwiftUI

/// Reusable email/password input field component with animations
public struct AnimatedTextField: View {
    let placeholder: String
    let isSecure: Bool
    @Binding var text: String
    @State private var isFocused = false
    
    public init(placeholder: String, text: Binding<String>, isSecure: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isFocused || !text.isEmpty {
                Text(placeholder)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            Group {
                if isSecure {
                    SecureField(isFocused || !text.isEmpty ? "" : placeholder, text: $text)
                } else {
                    TextField(isFocused || !text.isEmpty ? "" : placeholder, text: $text)
                }
            }
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? Color.accentColor : Color.clear, lineWidth: 2)
                    )
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isFocused = true
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
    }
}

/// Primary action button component with loading state
public struct PrimaryButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    public init(title: String, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isLoading ? Color.accentColor.opacity(0.7) : Color.accentColor)
            )
        }
        .disabled(isLoading)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onPressGesture { pressed in
            if !isLoading {
                isPressed = pressed
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}