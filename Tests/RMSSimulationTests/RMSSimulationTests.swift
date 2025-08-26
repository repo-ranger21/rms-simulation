import XCTest
@testable import RMSSimulation

final class RMSSimulationTests: XCTestCase {
    
    func testSupabaseServiceInitialization() {
        let service = SupabaseService.shared
        XCTAssertNotNil(service.client)
    }
    
    func testOAuthProviderDisplayNames() {
        XCTAssertEqual(OAuthProvider.google.displayName, "Google")
        XCTAssertEqual(OAuthProvider.facebook.displayName, "Facebook")
        XCTAssertEqual(OAuthProvider.twitter.displayName, "X")
    }
    
    func testOAuthProviderIcons() {
        XCTAssertEqual(OAuthProvider.google.iconName, "globe")
        XCTAssertEqual(OAuthProvider.facebook.iconName, "f.circle.fill")
        XCTAssertEqual(OAuthProvider.twitter.iconName, "x.circle.fill")
    }
}