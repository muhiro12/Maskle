@testable import MaskleLibrary
import SwiftData
import XCTest

final class SessionServiceTests: XCTestCase {
    func testSavingSessionsRespectsHistoryLimit() throws {
        let context = testContext
        let mapping = Mapping(
            original: "secret",
            alias: "Alias(1)",
            kind: .other,
            occurrenceCount: 2
        )

        let first = try SessionService.saveSession(
            context: context,
            maskedText: "masked-1",
            note: "first",
            mappings: [mapping],
            historyLimit: 2
        )
        XCTAssertEqual(first.mappings?.count, 1)

        _ = try SessionService.saveSession(
            context: context,
            maskedText: "masked-2",
            note: "second",
            mappings: [mapping],
            historyLimit: 2
        )

        _ = try SessionService.saveSession(
            context: context,
            maskedText: "masked-3",
            note: "third",
            mappings: [mapping],
            historyLimit: 2
        )

        let descriptor = FetchDescriptor<MaskingSession>(
            sortBy: [
                .init(\.createdAt, order: .reverse)
            ]
        )
        let sessions = try context.fetch(descriptor)

        XCTAssertEqual(sessions.count, 2)
        XCTAssertTrue(sessions.contains {
            $0.maskedText == "masked-3"
        })
        XCTAssertTrue(sessions.contains {
            $0.maskedText == "masked-2"
        })
        XCTAssertFalse(sessions.contains {
            $0.maskedText == "masked-1"
        })
    }
}
