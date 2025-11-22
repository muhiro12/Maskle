//
//  RestoreView.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import MaskleLibrary
import SwiftUI

struct RestoreView: View {
    let session: MaskingSession

    @State private var viewModel = RestoreViewModel()

    var body: some View {
        List {
            Section("AI response to restore") {
                TextEditor(text: $viewModel.sourceText)
                    .frame(minHeight: 200)
            }

            Section {
                Button {
                    viewModel.restore(with: session)
                } label: {
                    Label("Restore", systemImage: "arrow.uturn.backward")
                }
                .disabled(viewModel.sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            if viewModel.restoredText.isEmpty == false {
                Section("Restored text") {
                    TextEditor(text: .constant(viewModel.restoredText))
                        .frame(minHeight: 200)
                        .textSelection(.enabled)
                    CopyButton(text: viewModel.restoredText)
                }
            }
        }
        .navigationTitle("Restore")
    }
}
