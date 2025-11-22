//
//  HistoryDetailView.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import MaskleLibrary
import SwiftUI

struct HistoryDetailView: View {
    let session: MaskingSession

    var body: some View {
        List {
            Section("Masked text") {
                Text(session.maskedText)
                    .textSelection(.enabled)
                CopyButton(text: session.maskedText)
            }

            Section("Mappings") {
                if let mappings = session.mappings, mappings.isEmpty == false {
                    ForEach(mappings) { mapping in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Original: \(mapping.original)")
                            Text("Alias: \(mapping.alias)")
                            HStack {
                                Text("Kind: \(mapping.kind?.displayName ?? "Unknown")")
                                Spacer()
                                Text("Count: \(mapping.occurrenceCount)")
                            }
                            .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                } else {
                    Text("No mappings recorded.")
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                NavigationLink {
                    RestoreView(session: session)
                } label: {
                    Label("Restore with this session", systemImage: "arrow.uturn.backward")
                }
            }
        }
        .navigationTitle(session.createdAt.formatted(date: .abbreviated, time: .shortened))
    }
}
