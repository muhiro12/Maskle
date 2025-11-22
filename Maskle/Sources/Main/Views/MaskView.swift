//
//  MaskView.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import MaskleLibrary
import SwiftData
import SwiftUI

struct MaskView: View {
    @Environment(\.modelContext)
    private var context
    @Environment(SettingsStore.self)
    private var settingsStore
    @Environment(MaskSessionStore.self)
    private var maskSessionStore

    @State private var viewModel = MaskViewModel()
    @State private var isHistorySavedMessagePresented = false

    var body: some View {
        ScrollView {
            @Bindable var maskSessionStore = maskSessionStore
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Original text") {
                    TextEditor(text: $viewModel.sourceText)
                        .frame(minHeight: 180)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.quaternary)
                        }
                        .overlay(alignment: .topLeading) {
                            if viewModel.sourceText.isEmpty {
                                Text("Paste text that includes sensitive content.")
                                    .foregroundStyle(.secondary)
                                    .padding(12)
                            }
                        }
                }

                let mappingCount = maskSessionStore.manualRules.count
                if mappingCount > .zero {
                    GroupBox("Manual mappings in use") {
                        HStack {
                            Text("Mappings")
                            Spacer()
                            Text("\(mappingCount)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                GroupBox("Note") {
                    TextField(
                        "Optional memo for this session",
                        text: $viewModel.note
                    )
                    .textFieldStyle(.roundedBorder)
                }

                HStack {
                    Spacer()
                    Button {
                        viewModel.anonymize(
                            context: context,
                            settingsStore: settingsStore,
                            manualRules: maskSessionStore.manualRules
                        )
                        isHistorySavedMessagePresented = settingsStore.isHistoryAutoSaveEnabled
                    } label: {
                        Label("Anonymize", systemImage: "wand.and.stars")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    Spacer()
                }

                if let result = viewModel.result {
                    summaryView(
                        result: result,
                        session: viewModel.lastSavedSession
                    )
                    maskedOutputView(result: result)
                }
            }
            .padding()
        }
        .navigationTitle("Mask")
        .alert("Saved to history", isPresented: $isHistorySavedMessagePresented) {
            Button("OK") {
            }
        } message: {
            Text("You can review this session anytime from History.")
        }
    }
}

private extension MaskView {
    @ViewBuilder
    func summaryView(
        result: MaskingResult,
        session: MaskingSession?
    ) -> some View {
        GroupBox("Latest result") {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Processed at")
                    Spacer()
                    Text((session?.createdAt ?? Date()).formatted(date: .abbreviated, time: .shortened))
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Mappings")
                    Spacer()
                    Text("\(result.mappings.count)")
                        .foregroundStyle(.secondary)
                }
                if let note = session?.note?.trimmingCharacters(in: .whitespacesAndNewlines), note.isEmpty == false {
                    HStack {
                        Text("Memo")
                        Spacer()
                        Text(note)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func maskedOutputView(
        result: MaskingResult
    ) -> some View {
        GroupBox("Masked text") {
            VStack(alignment: .leading, spacing: 8) {
                TextEditor(text: .constant(result.maskedText))
                    .frame(minHeight: 180)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.quaternary)
                    }
                    .textSelection(.enabled)

                HStack {
                    Spacer()
                    CopyButton(text: result.maskedText)
                }
            }
        }
    }
}
