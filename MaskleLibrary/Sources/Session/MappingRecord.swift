//
//  MappingRecord.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import Foundation
import SwiftData

/// A persisted mapping entry linking an original string to its alias.
@Model
public final class MappingRecord {
    public var original = String()
    public var alias = String()
    public var kindID = String()
    public var occurrenceCount = Int.zero

    @Relationship(inverse: \MaskingSession.mappings)
    public var session: MaskingSession?

    init() {}
}

public extension MappingRecord {
    var kind: MappingKind? {
        MappingKind(rawValue: kindID)
    }
}
