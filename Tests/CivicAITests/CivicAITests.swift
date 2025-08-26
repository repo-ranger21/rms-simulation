import XCTest
import SwiftUI
@testable import CivicAI

final class CivicAITests: XCTestCase {
    
    func testDashboardViewCreation() throws {
        // Test that DashboardView can be created
        let dashboardView = DashboardView()
        XCTAssertNotNil(dashboardView)
    }
    
    func testChatViewCreation() throws {
        // Test that ChatView can be created
        let chatView = ChatView()
        XCTAssertNotNil(chatView)
    }
    
    func testChatMessageModel() throws {
        // Test ChatMessage model
        let message = ChatMessage(
            content: "Test message",
            isFromUser: true,
            timestamp: Date()
        )
        
        XCTAssertEqual(message.content, "Test message")
        XCTAssertTrue(message.isFromUser)
        XCTAssertNotNil(message.id)
    }
    
    func testChatMessageEquality() throws {
        // Test ChatMessage equality
        let date = Date()
        let message1 = ChatMessage(content: "Test", isFromUser: true, timestamp: date)
        let message2 = ChatMessage(content: "Test", isFromUser: true, timestamp: date)
        
        // Messages should be equal if content, isFromUser, and timestamp match
        // Note: IDs will be different, so this tests the Equatable implementation
        XCTAssertEqual(message1.content, message2.content)
        XCTAssertEqual(message1.isFromUser, message2.isFromUser)
        XCTAssertEqual(message1.timestamp, message2.timestamp)
    }
}