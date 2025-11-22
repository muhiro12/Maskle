//
//  AppStorageKey.swift
//
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import SwiftUI

public enum BoolAppStorageKey: String {
    case isSubscribeOn = "m5k3I8s9"
    case isICloudOn = "c1o9U2d4"
}

public extension AppStorage {
    init(_ key: BoolAppStorageKey) where Value == Bool {
        self.init(wrappedValue: false, key.rawValue)
    }
}
