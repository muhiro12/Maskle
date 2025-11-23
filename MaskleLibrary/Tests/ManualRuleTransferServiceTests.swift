@testable import MaskleLibrary
import SwiftData
import XCTest

final class ManualRuleTransferServiceTests: XCTestCase {
    func testExportAndReplaceImport() throws {
        let context = try makeContext()

        let rule = ManualRule()
        rule.uuid = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
        rule.original = "Secret"
        rule.alias = "Alias"
        rule.kindID = MappingKind.person.rawValue
        context.insert(rule)
        try context.save()

        let data = try ManualRuleTransferService.exportData(context: context)

        let importContext = try makeContext()
        let result = try ManualRuleTransferService.importData(
            data,
            context: importContext,
            policy: .replaceAll
        )

        XCTAssertEqual(result.insertedCount, 1)
        XCTAssertEqual(result.updatedCount, 0)

        let fetched = try importContext.fetch(FetchDescriptor<ManualRule>())
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.alias, "Alias")
        XCTAssertEqual(fetched.first?.kindID, MappingKind.person.rawValue)
    }

    func testMergeUpdatesExistingRule() throws {
        let context = try makeContext()
        let existingID = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!

        let existing = ManualRule()
        existing.uuid = existingID
        existing.original = "Old"
        existing.alias = "OldAlias"
        existing.kindID = MappingKind.project.rawValue
        context.insert(existing)
        try context.save()

        let payloadContext = try makeContext()
        let updated = ManualRule()
        updated.uuid = existingID
        updated.original = "Old"
        updated.alias = "NewAlias"
        updated.kindID = MappingKind.project.rawValue
        payloadContext.insert(updated)

        let data = try ManualRuleTransferService.exportData(context: payloadContext)

        let result = try ManualRuleTransferService.importData(
            data,
            context: context,
            policy: .mergeExisting
        )

        XCTAssertEqual(result.insertedCount, 0)
        XCTAssertEqual(result.updatedCount, 1)

        let fetched = try context.fetch(FetchDescriptor<ManualRule>())
        XCTAssertEqual(fetched.first?.alias, "NewAlias")
    }

    func testAppendCreatesNewIDsWhenDuplicated() throws {
        let context = try makeContext()
        let duplicateID = UUID(uuidString: "33333333-3333-3333-3333-333333333333")!

        let existing = ManualRule()
        existing.uuid = duplicateID
        existing.original = "Keep"
        existing.alias = "KeepAlias"
        existing.kindID = MappingKind.other.rawValue
        context.insert(existing)
        try context.save()

        let payloadContext = try makeContext()
        let newRule = ManualRule()
        newRule.uuid = duplicateID
        newRule.original = "New"
        newRule.alias = "NewAlias"
        newRule.kindID = MappingKind.other.rawValue
        payloadContext.insert(newRule)

        let data = try ManualRuleTransferService.exportData(context: payloadContext)

        let result = try ManualRuleTransferService.importData(
            data,
            context: context,
            policy: .appendNew
        )

        XCTAssertEqual(result.insertedCount, 1)
        XCTAssertEqual(result.updatedCount, 0)

        let fetched = try context.fetch(FetchDescriptor<ManualRule>())
        XCTAssertEqual(fetched.count, 2)
        XCTAssertTrue(fetched.contains { $0.original == "New" && $0.alias == "NewAlias" })
    }
}

private extension ManualRuleTransferServiceTests {
    func makeContext() throws -> ModelContext {
        let container = try ModelContainer(
            for: ManualRule.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }
}
