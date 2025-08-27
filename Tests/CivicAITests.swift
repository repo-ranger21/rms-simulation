import XCTest
@testable import CivicAI

final class ValidationTests: XCTestCase {
    
    func testEmailValidation() {
        // Test valid emails
        XCTAssertTrue(ValidationUtils.isValidEmail("test@example.com"))
        XCTAssertTrue(ValidationUtils.isValidEmail("user.name@domain.co.uk"))
        XCTAssertTrue(ValidationUtils.isValidEmail("test+tag@example.org"))
        
        // Test invalid emails
        XCTAssertFalse(ValidationUtils.isValidEmail(""))
        XCTAssertFalse(ValidationUtils.isValidEmail("invalid"))
        XCTAssertFalse(ValidationUtils.isValidEmail("@example.com"))
        XCTAssertFalse(ValidationUtils.isValidEmail("test@"))
        XCTAssertFalse(ValidationUtils.isValidEmail("test.example.com"))
    }
    
    func testPasswordValidation() {
        // Test valid passwords
        XCTAssertTrue(ValidationUtils.isValidPassword("password123"))
        XCTAssertTrue(ValidationUtils.isValidPassword("123456"))
        XCTAssertTrue(ValidationUtils.isValidPassword("abcdef"))
        
        // Test invalid passwords
        XCTAssertFalse(ValidationUtils.isValidPassword(""))
        XCTAssertFalse(ValidationUtils.isValidPassword("12345"))
        XCTAssertFalse(ValidationUtils.isValidPassword("abc"))
    }
    
    func testLoginFormValidation() {
        // Test valid form
        XCTAssertTrue(ValidationUtils.isValidLoginForm(email: "test@example.com", password: "password123"))
        
        // Test invalid combinations
        XCTAssertFalse(ValidationUtils.isValidLoginForm(email: "", password: "password123"))
        XCTAssertFalse(ValidationUtils.isValidLoginForm(email: "test@example.com", password: ""))
        XCTAssertFalse(ValidationUtils.isValidLoginForm(email: "invalid-email", password: "password123"))
        XCTAssertFalse(ValidationUtils.isValidLoginForm(email: "test@example.com", password: "123"))
    }
}