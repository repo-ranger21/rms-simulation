import Foundation
import Supabase
#if canImport(Combine)
import Combine
#endif

/// Simple in-memory storage for auth sessions (for testing/demo purposes)
/// In production, you should use a persistent storage solution
private class MemoryAuthStorage: AuthLocalStorage {
    private var storage: [String: Data] = [:]
    
    func store(key: String, value: Data) throws {
        storage[key] = value
    }
    
    func retrieve(key: String) throws -> Data? {
        return storage[key]
    }
    
    func remove(key: String) throws {
        storage.removeValue(forKey: key)
    }
}

/// SupabaseService handles all backend interactions for CivicAI including
/// authentication, session management, and real-time updates
@MainActor
public class SupabaseService {
    
    // MARK: - Properties
    
    public static let shared = SupabaseService()
    
    private let supabaseClient: SupabaseClient
    
    #if canImport(Combine)
    @Published public private(set) var currentUser: User?
    @Published public private(set) var isAuthenticated: Bool = false
    @Published public private(set) var sessionState: SessionState = .notAuthenticated
    private var cancellables = Set<AnyCancellable>()
    #else
    public private(set) var currentUser: User?
    public private(set) var isAuthenticated: Bool = false
    public private(set) var sessionState: SessionState = .notAuthenticated
    #endif
    
    private var realtimeSubscriptions: [RealtimeChannelV2] = []
    
    // MARK: - Initialization
    
    private init() {
        // Initialize with environment variables or default values
        // In a real app, these should be configured from environment or config
        let supabaseURL = URL(string: ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? "https://your-project.supabase.co")!
        let supabaseKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] ?? "your-anon-key"
        
        self.supabaseClient = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey,
            options: .init(
                db: .init(),
                auth: .init(storage: MemoryAuthStorage()),
                global: .init(),
                functions: .init(),
                realtime: .init(),
                storage: .init()
            )
        )
        
        setupAuthListener()
    }
    
    /// Initialize with custom Supabase configuration
    public init(supabaseURL: URL, supabaseKey: String) {
        self.supabaseClient = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey,
            options: .init(
                db: .init(),
                auth: .init(storage: MemoryAuthStorage()),
                global: .init(),
                functions: .init(),
                realtime: .init(),
                storage: .init()
            )
        )
        setupAuthListener()
    }
    
    // MARK: - Authentication
    
    /// Sign in with email and password
    public func signIn(email: String, password: String) async throws {
        let session = try await supabaseClient.auth.signIn(
            email: email,
            password: password
        )
        await handleAuthStateChange(session: session)
    }
    
    /// Sign up with email and password
    public func signUp(email: String, password: String, metadata: [String: AnyJSON]? = nil) async throws {
        let response = try await supabaseClient.auth.signUp(
            email: email,
            password: password,
            data: metadata
        )
        // AuthResponse has a session property, but Session doesn't have a session property
        await handleAuthStateChange(session: response.session)
    }
    
    /// Sign in with OAuth provider
    public func signInWithOAuth(provider: Provider, redirectTo: URL? = nil) async throws {
        try await supabaseClient.auth.signInWithOAuth(
            provider: provider,
            redirectTo: redirectTo,
            launchFlow: { url in
                // This would typically open a web browser or handle the OAuth flow
                // For now, return the URL for the calling code to handle
                return url
            }
        )
    }
    
    /// Sign out current user
    public func signOut() async throws {
        try await supabaseClient.auth.signOut()
        await clearUserSession()
    }
    
    /// Send password reset email
    public func resetPassword(email: String) async throws {
        try await supabaseClient.auth.resetPasswordForEmail(email)
    }
    
    /// Update user password
    public func updatePassword(newPassword: String) async throws {
        let user = try await supabaseClient.auth.update(
            user: UserAttributes(password: newPassword)
        )
        currentUser = user
    }
    
    /// Update user metadata
    public func updateUserMetadata(_ metadata: [String: AnyJSON]) async throws {
        let user = try await supabaseClient.auth.update(
            user: UserAttributes(data: metadata)
        )
        currentUser = user
    }
    
    // MARK: - Session Management
    
    /// Get current session
    public func getCurrentSession() async throws -> Session? {
        return try await supabaseClient.auth.session
    }
    
    /// Refresh current session
    public func refreshSession() async throws {
        let session = try await supabaseClient.auth.refreshSession()
        await handleAuthStateChange(session: session)
    }
    
    /// Check if user is authenticated
    public var isUserAuthenticated: Bool {
        return currentUser != nil && isAuthenticated
    }
    
    // MARK: - Database Operations
    
    /// Perform a database query
    public func query<T: Decodable>(_ table: String, as type: T.Type) -> PostgrestQueryBuilder {
        return supabaseClient.from(table)
    }
    
    /// Insert data into a table
    public func insert<T: Encodable>(_ values: T, into table: String) async throws {
        try await supabaseClient
            .from(table)
            .insert(values)
            .execute()
    }
    
    /// Update data in a table
    public func update<T: Encodable>(_ values: T, in table: String, matching condition: String) async throws {
        let parts = condition.components(separatedBy: "=")
        guard parts.count == 2 else {
            throw SupabaseServiceError.databaseError("Invalid condition format. Use 'column=value'")
        }
        try await supabaseClient
            .from(table)
            .update(values)
            .eq(parts[0].trimmingCharacters(in: .whitespaces), value: parts[1].trimmingCharacters(in: .whitespaces))
            .execute()
    }
    
    /// Delete data from a table
    public func delete(from table: String, matching condition: String) async throws {
        let parts = condition.components(separatedBy: "=")
        guard parts.count == 2 else {
            throw SupabaseServiceError.databaseError("Invalid condition format. Use 'column=value'")
        }
        try await supabaseClient
            .from(table)
            .delete()
            .eq(parts[0].trimmingCharacters(in: .whitespaces), value: parts[1].trimmingCharacters(in: .whitespaces))
            .execute()
    }
    
    // MARK: - Real-time Updates
    
    /// Subscribe to table changes
    #if canImport(Combine)
    public func subscribeToTable(_ table: String, event: RealtimeListenTypes = .all) -> AnyPublisher<RealtimeMessage, Never> {
        let channel = supabaseClient.realtimeV2.channel("public:\(table)")
        
        let subject = PassthroughSubject<RealtimeMessage, Never>()
        
        channel
            .on(event) { message in
                subject.send(message)
            }
            .subscribe()
        
        realtimeSubscriptions.append(channel)
        
        return subject.eraseToAnyPublisher()
    }
    #endif
    
    /// Subscribe to specific row changes
    #if canImport(Combine)
    public func subscribeToRow(in table: String, id: String, event: RealtimeListenTypes = .all) -> AnyPublisher<RealtimeMessage, Never> {
        let channel = supabaseClient.realtimeV2.channel("public:\(table):id=eq.\(id)")
        
        let subject = PassthroughSubject<RealtimeMessage, Never>()
        
        channel
            .on(event) { message in
                subject.send(message)
            }
            .subscribe()
        
        realtimeSubscriptions.append(channel)
        
        return subject.eraseToAnyPublisher()
    }
    #endif
    
    /// Unsubscribe from all real-time updates
    public func unsubscribeAll() async {
        for channel in realtimeSubscriptions {
            await channel.unsubscribe()
        }
        realtimeSubscriptions.removeAll()
    }
    
    // MARK: - Storage Operations
    
    /// Upload file to storage
    public func uploadFile(
        bucketName: String,
        fileName: String,
        data: Data,
        contentType: String = "application/octet-stream"
    ) async throws -> String {
        try await supabaseClient.storage
            .from(bucketName)
            .upload(fileName, data: data)
        
        return try supabaseClient.storage
            .from(bucketName)
            .getPublicURL(path: fileName)
            .absoluteString
    }
    
    /// Download file from storage
    public func downloadFile(bucketName: String, fileName: String) async throws -> Data {
        return try await supabaseClient.storage
            .from(bucketName)
            .download(path: fileName)
    }
    
    /// Delete file from storage
    public func deleteFile(bucketName: String, fileName: String) async throws {
        try await supabaseClient.storage
            .from(bucketName)
            .remove(paths: [fileName])
    }
    
    /// Get public URL for file
    public func getPublicURL(bucketName: String, fileName: String) throws -> String {
        return try supabaseClient.storage
            .from(bucketName)
            .getPublicURL(path: fileName)
            .absoluteString
    }
    
    // MARK: - ViewModel Integration Helpers
    
    /// Create a publisher for authentication state changes
    #if canImport(Combine)
    public var authStatePublisher: AnyPublisher<SessionState, Never> {
        $sessionState.eraseToAnyPublisher()
    }
    #endif
    
    /// Create a publisher for user changes
    #if canImport(Combine)
    public var userPublisher: AnyPublisher<User?, Never> {
        $currentUser.eraseToAnyPublisher()
    }
    #endif
    
    /// Execute database operation and handle common errors
    public func executeOperation<T>(_ operation: @escaping () async throws -> T) async -> Result<T, SupabaseServiceError> {
        do {
            let result = try await operation()
            return .success(result)
        } catch {
            return .failure(SupabaseServiceError.from(error))
        }
    }
    
    /// Batch execute multiple operations
    public func executeBatch<T>(_ operations: [() async throws -> T]) async -> [Result<T, SupabaseServiceError>] {
        await withTaskGroup(of: Result<T, SupabaseServiceError>.self) { group in
            for operation in operations {
                group.addTask {
                    await self.executeOperation(operation)
                }
            }
            
            var results: [Result<T, SupabaseServiceError>] = []
            for await result in group {
                results.append(result)
            }
            return results
        }
    }
    
    // MARK: - Private Methods
    
    private func setupAuthListener() {
        #if canImport(Combine)
        supabaseClient.auth.onAuthStateChange { [weak self] event, session in
            Task { @MainActor in
                await self?.handleAuthStateChange(event: event, session: session)
            }
        }
        .store(in: &cancellables)
        #else
        // For non-Combine environments, we'll handle auth state changes manually
        Task {
            await handleAuthStateChange(session: try? await supabaseClient.auth.session)
        }
        #endif
    }
    
    private func handleAuthStateChange(event: AuthChangeEvent? = nil, session: Session? = nil) async {
        if let session = session {
            currentUser = session.user
            isAuthenticated = true
            sessionState = .authenticated(session)
        } else {
            await clearUserSession()
        }
    }
    
    private func clearUserSession() async {
        currentUser = nil
        isAuthenticated = false
        sessionState = .notAuthenticated
        await unsubscribeAll()
    }
}

// MARK: - Supporting Types

public enum SessionState: Equatable {
    case notAuthenticated
    case authenticated(Session)
    case loading
}

public enum SupabaseServiceError: Error, LocalizedError {
    case authenticationFailed(String)
    case networkError(String)
    case databaseError(String)
    case storageError(String)
    case unknown(String)
    
    public var errorDescription: String? {
        switch self {
        case .authenticationFailed(let message):
            return "Authentication failed: \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .databaseError(let message):
            return "Database error: \(message)"
        case .storageError(let message):
            return "Storage error: \(message)"
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
    
    static func from(_ error: Error) -> SupabaseServiceError {
        // Map specific Supabase errors to custom error types
        let errorString = error.localizedDescription
        
        if errorString.contains("auth") || errorString.contains("login") {
            return .authenticationFailed(errorString)
        } else if errorString.contains("network") || errorString.contains("connection") {
            return .networkError(errorString)
        } else if errorString.contains("database") || errorString.contains("table") {
            return .databaseError(errorString)
        } else if errorString.contains("storage") || errorString.contains("bucket") {
            return .storageError(errorString)
        } else {
            return .unknown(errorString)
        }
    }
}

// MARK: - Extensions for ViewModel Integration

extension SupabaseService {
    
    /// Convenience method for SwiftUI ViewModels to handle async operations
    public func performAsync<T>(
        operation: @escaping () async throws -> T,
        onSuccess: @escaping (T) -> Void,
        onError: @escaping (SupabaseServiceError) -> Void
    ) {
        Task {
            let result = await executeOperation(operation)
            await MainActor.run {
                switch result {
                case .success(let value):
                    onSuccess(value)
                case .failure(let error):
                    onError(error)
                }
            }
        }
    }
    
    /// Create a binding for authentication state
    public func createAuthBinding() -> Bool {
        isAuthenticated
    }
}