import XCTest
@testable import swift_guard

class swift_guardTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(swift_guard().text, "Hello, Worl2d!")
    }


    static var allTests : [(String, (swift_guardTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
