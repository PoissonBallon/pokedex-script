import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(pokedex_scriptTests.allTests),
    ]
}
#endif