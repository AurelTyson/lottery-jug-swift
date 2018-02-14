import Foundation
@testable import App
@testable import Vapor
import XCTest
import Testing

extension Droplet {
    
    static func testable(forceNoEvent: Bool) throws -> Droplet {
        let config = try Config(arguments: ["vapor", "--env=test"])
        try config.setup()
        let drop = try Droplet(config)
        try drop.setup(forceNoEvent: forceNoEvent)
        return drop
    }
    
    func serveInBackground() throws {
        background {
            try! self.run()
        }
        console.wait(seconds: 0.5)
    }
    
}

class TestCase: XCTestCase {
    
    override func setUp() {
        Node.fuzzy = [JSON.self, Node.self]
        Testing.onFail = XCTFail
    }
    
}
