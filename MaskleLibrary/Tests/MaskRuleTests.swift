@testable import MaskleLibrary
import XCTest

final class MaskRuleTests: XCTestCase {
    func testCreateRejectsDuplicateOriginal() throws {
        let context = testContext

        _ = try MaskRule.create(
            context: context,
            original: "Apple",
            alias: "A社"
        )

        XCTAssertThrowsError(
            try MaskRule.create(
                context: context,
                original: "Apple",
                alias: "B社"
            )
        ) { error in
            XCTAssertEqual(error as? MaskRuleError, .duplicateOriginal)
        }
    }

    func testUpdateRejectsDuplicateAlias() throws {
        let context = testContext

        _ = try MaskRule.create(
            context: context,
            original: "Apple",
            alias: "A社"
        )
        let ruleToUpdate = try MaskRule.create(
            context: context,
            original: "Orange",
            alias: "C社"
        )

        XCTAssertThrowsError(
            try ruleToUpdate.update(
                context: context,
                original: "Orange",
                alias: "A社",
                isEnabled: true
            )
        ) { error in
            XCTAssertEqual(error as? MaskRuleError, .duplicateAlias)
        }
    }
}
