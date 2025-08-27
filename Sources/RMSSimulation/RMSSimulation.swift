// The Swift Programming Language
// https://docs.swift.org/swift-book

/// RMSSimulation provides backend services for CivicAI applications
/// including authentication, database operations, and real-time updates
/// through Supabase integration.

// Re-export all public interfaces
@_exported import Supabase

// Main service interface
public typealias RMSSupabaseService = SupabaseService