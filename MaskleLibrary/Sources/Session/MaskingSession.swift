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
    public var createdAt = Date()
    public var maskedText = String()
    public var note: String?

    @Relationship(deleteRule: .cascade)
    public var mappings: [MappingRecord]?

    init() {}
}

public extension MaskingSession {
    var mappingCount: Int {
        mappings?.count ?? .zero
    }

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
