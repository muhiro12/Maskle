//
//  MappingView.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import MaskleLibrary
import SwiftUI

struct MappingView: View {
    @Environment(MaskSessionStore.self)
    private var maskSessionStore

    var body: some View {
        NavigationStack {
            @Bindable var maskSessionStore = maskSessionStore
            List {
                Section("Manual mappings") {
                    ForEach($maskSessionStore.manualRules) { $rule in
                        MappingRuleEditor(rule: $rule)
                            .padding(.vertical, 8)
                        HStack {
                            Spacer()
                            Button(role: .destructive) {
                                maskSessionStore.removeRule(id: rule.id)
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                            .disabled(maskSessionStore.manualRules.count <= 1)
                        }
                    }
                    Button {
                        maskSessionStore.addRule()
                    } label: {
                        Label("Add mapping", systemImage: "plus.circle")
                    }
                }
                Section {
                    Text("Mappings you set here are applied when you anonymize text on the Mask screen.")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Mappings")
        }
    }
}
