//
//  MaskingRule.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import Foundation

public struct MaskingRule: Identifiable, Equatable {
    public let id: UUID
    public var original: String
    public var alias: String
    public var kind: MappingKind

    public init(
        id: UUID = .init(),
        original: String,
        alias: String,
        kind: MappingKind
    ) {
        self.id = id
        self.original = original
        self.alias = alias
        self.kind = kind
    }
}
