//
//  MaskSessionStore.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import Foundation
import MaskleLibrary
import Observation

@Observable
final class MaskSessionStore {
    var manualRules: [MaskingRule]

    init(
        manualRules: [MaskingRule] = [
            .init(
                original: .init(),
                alias: .init(),
                kind: .custom
            )
        ]
    ) {
        self.manualRules = manualRules
    }
}

extension MaskSessionStore {
    func addRule() {
        manualRules.append(
            .init(
                original: .init(),
                alias: .init(),
                kind: .custom
            )
        )
    }

    func removeRule(id: UUID) {
        manualRules.removeAll {
            $0.id == id
        }
    }
}
