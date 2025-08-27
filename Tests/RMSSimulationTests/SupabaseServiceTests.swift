import XCTest
@testable import RMSSimulation

final class SupabaseServiceTests: XCTestCase {
    
    var supabaseService: SupabaseService!
    
    override func setUp() {
        super.setUp()
        // Use test configuration
        let testURL = URL(string: "https://test.supabase.co")!
        let testKey = "test-key"
        supabaseService = SupabaseService(supabaseURL: testURL, supabaseKey: testKey)
    }
    
    override func tearDown() {
        supabaseService = nil
        super.tearDown()
    }
    
    func testServiceInitialization() {
        XCTAssertNotNil(supabaseService)
        XCTAssertFalse(supabaseService.isAuthenticated)
        XCTAssertNil(supabaseService.currentUser)
        XCTAssertEqual(supabaseService.sessionState, .notAuthenticated)
    }
    
    func testAuthenticationStatePublisher() {
        let expectation = XCTestExpectation(description: "Auth state publisher")
        
        let cancellable = supabaseService.authStatePublisher
            .sink { state in
                XCTAssertEqual(state, .notAuthenticated)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
    }
    
    func testUserPublisher() {
        let expectation = XCTestExpectation(description: "User publisher")
        
        let cancellable = supabaseService.userPublisher
            .sink { user in
                XCTAssertNil(user)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
    }
    
    func testErrorMapping() {
        let authError = NSError(domain: "test", code: 401, userInfo: [NSLocalizedDescriptionKey: "auth failed"])
        let mappedError = SupabaseServiceError.from(authError)
        
        switch mappedError {
        case .authenticationFailed(let message):
            XCTAssertTrue(message.contains("auth"))
        default:
            XCTFail("Expected authentication error")
        }
    }
    
    func testIsUserAuthenticated() {
        XCTAssertFalse(supabaseService.isUserAuthenticated)
    }
}