//
//  RestoreService.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import Foundation

public enum RestoreService {
    public static func restore(
        text: String,
        mappings: [Mapping]
    ) -> String {
        let orderedMappings = mappings.sorted {
            $0.alias.count > $1.alias.count
        }

        return orderedMappings.reduce(into: text) { restored, mapping in
            let (updated, _) = replaceOccurrences(
                in: restored,
                target: mapping.alias,
                replacement: mapping.original
            )
            restored = updated
        }
    }
}

private extension RestoreService {
    static func replaceOccurrences(
        in text: String,
        target: String,
        replacement: String
    ) -> (String, Int) {
        let components = text.components(separatedBy: target)
        guard components.count > 1 else {
            return (text, .zero)
        }
        let updatedText = components.joined(separator: replacement)
        return (updatedText, components.count - 1)
    }
}
