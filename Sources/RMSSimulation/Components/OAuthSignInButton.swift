import SwiftUI

/// Reusable OAuth sign-in button component
public struct OAuthSignInButton: View {
    let provider: OAuthProvider
    let action: () -> Void
    @State private var isPressed = false
    
    public init(provider: OAuthProvider, action: @escaping () -> Void) {
        self.provider = provider
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: provider.iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(provider.iconColor)
                
                Text("Continue with \(provider.displayName)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(provider.borderColor, lineWidth: 1.5)
                    )
            )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onPressGesture { pressed in
            isPressed = pressed
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// OAuth provider configuration
public enum OAuthProvider {
    case google
    case facebook
    case twitter
    
    var displayName: String {
        switch self {
        case .google: return "Google"
        case .facebook: return "Facebook"
        case .twitter: return "X"
        }
    }
    
    var iconName: String {
        switch self {
        case .google: return "globe"
        case .facebook: return "f.circle.fill"
        case .twitter: return "x.circle.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .google: return .red
        case .facebook: return .blue
        case .twitter: return .black
        }
    }
    
    var borderColor: Color {
        switch self {
        case .google: return Color(.systemGray4)
        case .facebook: return Color(.systemGray4)
        case .twitter: return Color(.systemGray4)
        }
    }
}

/// Custom gesture recognizer for press states
extension View {
    func onPressGesture(perform: @escaping (Bool) -> Void) -> some View {
        self.onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
            // On press end
        } onPressingChanged: { pressing in
            perform(pressing)
        }
    }
}