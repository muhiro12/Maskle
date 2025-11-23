//
//  MaskingSession.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import Foundation
import SwiftData

/// A persisted anonymization run with associated mapping records.
@Model
public final class MaskingSession {
    public private(set) var date = Date()
    public private(set) var maskedText = String()

    @Relationship(deleteRule: .nullify)
    public private(set) var tags: [Tag]?

    private init() {}

    @discardableResult
    public static func create(
        context: ModelContext,
        maskedText: String,
        ) -> MaskingSession {
        let session = MaskingSession()
        context.insert(session)

        session.date = Date()
        session.maskedText = maskedText

        return session
    }

    public func update(
        maskedText: String
    ) {
        date = Date()
        self.maskedText = maskedText
    }
}

public extension MaskingSession {
    var previewText: String {
        if maskedText.count > 80 {
            return "\(maskedText.prefix(80))…"
        }
        return maskedText
    }
}

extension MaskingSession: Hashable {
    public static func == (lhs: MaskingSession, rhs: MaskingSession) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
