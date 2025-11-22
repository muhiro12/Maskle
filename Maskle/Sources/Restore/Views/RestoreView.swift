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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("AI response to restore") {
                    TextEditor(text: $viewModel.sourceText)
                        .frame(minHeight: 200)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.quaternary)
                        }
                        .overlay(alignment: .topLeading) {
                            if viewModel.sourceText.isEmpty {
                                Text("Paste the AI response to convert aliases back to originals.")
                                    .foregroundStyle(.secondary)
                                    .padding(12)
                            }
                        }
                }

                HStack {
                    Spacer()
                    Button {
                        viewModel.restore(with: session)
                    } label: {
                        Label("Restore", systemImage: "arrow.uturn.backward")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    Spacer()
                }

                if viewModel.restoredText.isEmpty == false {
                    GroupBox("Restored text") {
                        VStack(alignment: .leading, spacing: 8) {
                            TextEditor(text: .constant(viewModel.restoredText))
                                .frame(minHeight: 200)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.quaternary)
                                }
                                .textSelection(.enabled)

                            HStack {
                                Spacer()
                                CopyButton(text: viewModel.restoredText)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Restore")
    }
}
