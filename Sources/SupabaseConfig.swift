import Foundation

/// Configuration for Supabase connection
/// Replace these values with your actual Supabase project credentials
struct SupabaseConfig {
    /// Your Supabase project URL
    /// Example: "https://your-project-id.supabase.co"
    static let url = "https://your-project.supabase.co"
    
    /// Your Supabase anonymous API key
    /// This can be found in your Supabase project settings under API
    static let anonKey = "your-anon-key-here"
    
    /// Optional: Service role key (for admin operations)
    /// Keep this secure and never expose it in client-side code
    static let serviceKey = "your-service-key-here"
}