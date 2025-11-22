//
//  SessionService.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import Foundation
import SwiftData

public enum SessionService {
    @discardableResult
    public static func saveSession(
        context: ModelContext,
        maskedText: String,
        note: String?,
        mappings: [Mapping],
        historyLimit: Int
    ) throws -> MaskingSession {
        let session = MaskingSession()
        context.insert(session)

        session.createdAt = Date()
        session.maskedText = maskedText
        session.note = note
        session.mappings = mappings.map {
            MappingRecord.create(
                context: context,
                session: session,
                mapping: $0
            )
        }

        try trimHistoryIfNeeded(
            context: context,
            limit: historyLimit
        )

        try context.save()

        return session
    }

    public static func deleteAll(
        context: ModelContext
    ) throws {
        let descriptor = FetchDescriptor<MaskingSession>()
        try context.fetch(descriptor).forEach(context.delete)
        try context.save()
    }

    public static func delete(
        context: ModelContext,
        session: MaskingSession
    ) throws {
        context.delete(session)
        try context.save()
    }

    @discardableResult
    public static func trimHistoryIfNeeded(
        context: ModelContext,
        limit: Int
    ) throws -> [MaskingSession] {
        let limit = max(limit, 1)
        let descriptor = FetchDescriptor<MaskingSession>(
            sortBy: [
                .init(\.createdAt, order: .reverse)
            ]
        )
        let sessions = try context.fetch(descriptor)
        guard sessions.count > limit else {
            return sessions
        }

        sessions.dropFirst(limit).forEach(context.delete)
        try context.save()

        return Array(sessions.prefix(limit))
    }
}

private extension MappingRecord {
    static func create(
        context: ModelContext,
        session: MaskingSession,
        mapping: Mapping
    ) -> MappingRecord {
        let record = MappingRecord()
        context.insert(record)

        record.original = mapping.original
        record.alias = mapping.alias
        record.kindID = mapping.kind.rawValue
        record.occurrenceCount = mapping.occurrenceCount
        record.session = session

        return record
    }
}
