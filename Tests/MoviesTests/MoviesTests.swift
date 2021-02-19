import XCTest
@testable import Movies

final class MoviesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Movies().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
