@testable import MaskleLibrary
import SwiftData

var testContext: ModelContext {
    .init(
        try! .init(
            for: MaskingSession.self,
            configurations: .init(
                isStoredInMemoryOnly: true
            )
        )
    )
}
