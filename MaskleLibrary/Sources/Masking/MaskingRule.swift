//
//  MaskingRule.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import Foundation
import SwiftData

public struct MaskingRule: Identifiable, Equatable {
    public let id: String
    public var original: String
    public var alias: String
    public var kind: MappingKind
    public var date: Date
    public var isEnabled: Bool

    public init(
        id: String = UUID().uuidString,
        original: String,
        alias: String,
        kind: MappingKind,
        date: Date = Date(),
        isEnabled: Bool = true
    ) {
        self.id = id
        self.original = original
        self.alias = alias
        self.kind = kind
        self.date = date
        self.isEnabled = isEnabled
    }
}
