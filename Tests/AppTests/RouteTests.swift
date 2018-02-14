import XCTest
import Foundation
import Testing
import HTTP
@testable import Vapor
@testable import App

/// This file shows an example of testing 
/// routes through the Droplet.
///
/// Jug tests : https://github.com/Jug-Montpellier/pre-lottery/blob/master/tests/tests.js
///

internal final class RouteTests: TestCase {
    
    // MARK: Attributes
    
    private let drop = try! Droplet.testable(forceNoEvent: false)
    private let dropNoEvent = try! Droplet.testable(forceNoEvent: true)
    
    // MARK: Init
    
    override public func setUp() {
        super.setUp()
        Testing.onFail = XCTFail
    }
    
    // MARK: Tests
    
    // should return 1 winner :: ${implementation.url}/winners?nb=1
    public func test1() throws {
        
        // Request
        let lRequest = Request(method: .get,
                               uri: "/winners?nb=1")
        let lResult = try self.drop.testResponse(to: lRequest)
        
        // Status
        lResult.assertStatus(is: .ok)
        
        // Extracting json
        guard let lJson = lResult.json else {
            XCTFail("Error getting json from request: \(lRequest)")
            return
        }
        
        // Check data
        XCTAssertEqual(1, lJson.array?.count)
        
    }
    
    // should return 1 winner well formatted :: ${implementation.url}/winners?nb=1
    public func test2() throws {
        
        // Request
        let lRequest = Request(method: .get,
                               uri: "/winners?nb=1")
        let lResult = try self.drop.testResponse(to: lRequest)
        
        // Status
        lResult.assertStatus(is: .ok)
        
        // Extracting json
        guard let lJson = lResult.json else {
            XCTFail("Error getting json from request: \(lRequest)")
            return
        }
        
        // Check data
        XCTAssertEqual(1, lJson.array?.count)
        XCTAssertNotNil(lJson.array?[0]["last_name"])
        XCTAssertNotNil(lJson.array?[0]["first_name"])
        XCTAssertNotNil(lJson.array?[0]["email"])
        
    }
    
    // should return n winners :: ${implementation.url}/winners?nb=N
    public func test3() throws {
        
        // Random number
        let lNb = Int.random(min: 1, max: 5)
        
        // Request
        let lRequest = Request(method: .get,
                               uri: "/winners?nb=\(lNb)")
        let lResult = try self.drop.testResponse(to: lRequest)
        
        // Status
        lResult.assertStatus(is: .ok)
        
        // Extracting json
        guard let lJson = lResult.json else {
            XCTFail("Error getting json from request: \(lRequest)")
            return
        }
        
        // Check data
        XCTAssertEqual(lNb, lJson.array?.count)
        
    }
    
    // should return an empty array when nb param is 0 :: ${implementation.url}/winners?nb=0
    public func test4() throws {
        
        // Request
        let lRequest = Request(method: .get,
                               uri: "/winners?nb=0")
        let lResult = try self.drop.testResponse(to: lRequest)
        
        // Status
        lResult.assertStatus(is: .ok)
        
        // Extracting json
        guard let lJson = lResult.json else {
            XCTFail("Error getting json from request: \(lRequest)")
            return
        }
        
        // Check data
        XCTAssertEqual(0, lJson.array?.count)
        
    }
    
    // should return all winners when nb param is big :: ${implementation.url}/winners?nb=10000
    public func test5() throws {
        
        // Request
        let lRequest = Request(method: .get,
                               uri: "/winners?nb=10000")
        let lResult = try self.drop.testResponse(to: lRequest)
        
        // Status
        lResult.assertStatus(is: .ok)
        
        // Extracting json
        guard let lJson = lResult.json else {
            XCTFail("Error getting json from request: \(lRequest)")
            return
        }
        
        // Check data
        XCTAssert(lJson.array?.count ?? 0 > 0)
        
    }
    
    // should return an http 400 error when no param nb :: ${implementation.url}/winners
    public func test6() throws {
        
        // Request
        let lRequest = Request(method: .get,
                               uri: "/winners")
        let lResult = try self.drop.testResponse(to: lRequest)
        
        // Status
        lResult.assertStatus(is: .badRequest)
        
    }
    
    // should return an http 400 error when param nb is not a number :: ${implementation.url}/winners?nb=nb
    public func test7() throws {
        
        // Request
        let lRequest = Request(method: .get,
                               uri: "/winners?nb=nb")
        let lResult = try self.drop.testResponse(to: lRequest)
        
        // Status
        lResult.assertStatus(is: .badRequest)
        
    }
    
    // should return an http 400 error when nb param is negative :: ${implementation.url}/winners?nb=-1
    public func test8() throws {
        
        // Request
        let lRequest = Request(method: .get,
                               uri: "/winners?nb=-1")
        let lResult = try self.drop.testResponse(to: lRequest)
        
        // Status
        lResult.assertStatus(is: .badRequest)
        
    }
    
    // without event, should return an http 502 error when no event found :: ${implementation.url}/winners?nb=1
    public func test9() throws {
        
        // Request
        let lRequest = Request(method: .get,
                               uri: "/winners?nb=1")
        let lResult = try self.dropNoEvent.testResponse(to: lRequest)
        
        // Status
        lResult.assertStatus(is: .badGateway)
        
    }
    
}

// MARK: Manifest

extension RouteTests {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("test1", test1),
        ("test2", test2),
        ("test3", test3),
        ("test4", test4),
        ("test5", test5),
        ("test6", test6),
        ("test7", test7),
        ("test8", test8),
        ("test9", test9),
    ]
}
