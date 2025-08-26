# Supabase Configuration Guide

## Setup Instructions

1. **Create a Supabase Project**
   - Go to [supabase.com](https://supabase.com)
   - Create a new project
   - Note your project URL and anon key

2. **Configure OAuth Providers**
   - In your Supabase dashboard, go to Authentication > Providers
   - Enable and configure the following providers:
     - **Google**: Add OAuth client ID and secret
     - **Facebook**: Add App ID and App Secret
     - **X (Twitter)**: Add API Key and API Secret Key

3. **Update Configuration**
   - Replace the placeholder values in `SupabaseService.swift`:
     ```swift
     let supabaseURL = URL(string: "https://your-project-id.supabase.co")!
     let supabaseKey = "your-anon-key"
     ```

4. **OAuth Redirect URLs**
   Configure these redirect URLs in your OAuth provider settings:
   - Google: `https://your-project-id.supabase.co/auth/v1/callback`
   - Facebook: `https://your-project-id.supabase.co/auth/v1/callback`
   - X/Twitter: `https://your-project-id.supabase.co/auth/v1/callback`

## Security Notes

- Never commit your actual Supabase keys to version control
- Use environment variables or a secure configuration file
- Enable Row Level Security (RLS) in your Supabase tables
- Configure appropriate OAuth app settings for production

## Features Implemented

✅ **Authentication Methods**
- Email/password sign-in and sign-up
- OAuth with Google, Facebook, and X/Twitter
- Secure session management

✅ **UI Components**
- Animated text fields with floating labels
- Modular OAuth sign-in buttons
- Loading states and error handling
- Responsive design for different screen sizes

✅ **User Experience**
- Smooth animations and transitions
- Button hover/press states
- Loading spinner for async operations
- Error messages with user-friendly alerts

✅ **Architecture**
- Modular component design for reusability
- Separation of concerns (Views, Components, Services)
- Async/await pattern for modern Swift
- Cross-platform support (iOS/macOS)