import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(EventTests.allTests),
        testCase(LoginTests.allTests),
        testCase(QuestionTests.allTests),
        testCase(UserTests.allTests)
    ]
}
#endif
