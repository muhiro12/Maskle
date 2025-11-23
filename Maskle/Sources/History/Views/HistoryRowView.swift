//
//  HistoryRowView.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import MaskleLibrary
import SwiftUI

struct HistoryRowView: View {
    let session: MaskingSession

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(session.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.headline)
                Spacer()
                Label("\(session.mappingCount)", systemImage: "arrow.2.squarepath")
                    .labelStyle(.titleAndIcon)
                    .foregroundStyle(.secondary)
            }
            Text(session.previewText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }
}
