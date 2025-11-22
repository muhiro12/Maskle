@testable import MaskleLibrary
import SwiftData

var testContext: ModelContext {
    .init(
        try! .init(
            for: MaskingSession.self,
            MappingRecord.self,
            configurations: .init(
                isStoredInMemoryOnly: true
            )
        )
    )
}
