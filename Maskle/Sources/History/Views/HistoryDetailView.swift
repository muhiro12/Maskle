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
                Text("Mappings are not retained in history.")
                    .foregroundStyle(.secondary)
            }

            Section {
                NavigationLink {
                    RestoreView(session: session)
                } label: {
                    Label("Restore with this session", systemImage: "arrow.uturn.backward")
                }
            }
        }
        .navigationTitle(session.date.formatted(date: .abbreviated, time: .shortened))
    }
}
