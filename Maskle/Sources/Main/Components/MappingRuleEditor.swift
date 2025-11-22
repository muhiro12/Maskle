//
//  MappingRuleEditor.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import MaskleLibrary
import SwiftUI

struct MappingRuleEditor: View {
    @Binding var rule: MaskingRule

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(
                "Original text",
                text: $rule.original,
                axis: .vertical
            )
            .textFieldStyle(.roundedBorder)

            TextField(
                "Alias",
                text: $rule.alias,
                axis: .vertical
            )
            .textFieldStyle(.roundedBorder)

            Picker("Kind", selection: $rule.kind) {
                ForEach(MappingKind.allCases) { kind in
                    Text(kind.displayName).tag(kind)
                }
            }
            .pickerStyle(.menu)
        }
    }
}
