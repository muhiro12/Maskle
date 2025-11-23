@testable import MaskleLibrary
import SwiftData
import XCTest

final class MaskRuleTransferServiceTests: XCTestCase {
    func testExportAndReplaceImport() throws {
        let context = try makeContext()

        MaskRule.create(
            context: context,
            original: "Secret",
            alias: "Alias"
        )
        try context.save()

        let data = try MaskRuleTransferService.exportData(context: context)

        let importContext = try makeContext()
        let result = try MaskRuleTransferService.importData(
            data,
            context: importContext,
            policy: .replaceAll
        )

        XCTAssertEqual(result.insertedCount, 1)
        XCTAssertEqual(result.updatedCount, 0)

        let fetched = try importContext.fetch(FetchDescriptor<MaskRule>())
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.alias, "Alias")
    }

    func testMergeUpdatesExistingRule() throws {
        let context = try makeContext()

        MaskRule.create(
            context: context,
            original: "Old",
            alias: "OldAlias"
        )
        try context.save()

        let payloadContext = try makeContext()
        MaskRule.create(
            context: payloadContext,
            original: "Old",
            alias: "NewAlias"
        )

        let data = try MaskRuleTransferService.exportData(context: payloadContext)

        let result = try MaskRuleTransferService.importData(
            data,
            context: context,
            policy: .mergeExisting
        )

        XCTAssertEqual(result.insertedCount, 0)
        XCTAssertEqual(result.updatedCount, 1)

        let fetched = try context.fetch(FetchDescriptor<MaskRule>())
        XCTAssertEqual(fetched.first?.alias, "NewAlias")
    }

    func testAppendCreatesNewIDsWhenDuplicated() throws {
        let context = try makeContext()

        MaskRule.create(
            context: context,
            original: "Keep",
            alias: "KeepAlias"
        )
        try context.save()

        let payloadContext = try makeContext()
        MaskRule.create(
            context: payloadContext,
            original: "New",
            alias: "NewAlias"
        )

        let data = try MaskRuleTransferService.exportData(context: payloadContext)

        let result = try MaskRuleTransferService.importData(
            data,
            context: context,
            policy: .appendNew
        )

        XCTAssertEqual(result.insertedCount, 1)
        XCTAssertEqual(result.updatedCount, 0)

        let fetched = try context.fetch(FetchDescriptor<MaskRule>())
        XCTAssertEqual(fetched.count, 2)
        XCTAssertTrue(fetched.contains { $0.original == "New" && $0.alias == "NewAlias" })
    }
}

private extension MaskRuleTransferServiceTests {
    func makeContext() throws -> ModelContext {
        let container = try ModelContainer(
            for: MaskRule.self,
            Tag.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }
}
