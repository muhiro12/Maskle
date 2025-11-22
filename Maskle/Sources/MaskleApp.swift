//
//  MaskleApp.swift
//  Maskle
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import MaskleLibrary
import SwiftData
import SwiftUI

@main
struct MaskleApp: App {
    private var sharedModelContainer: ModelContainer
    private var sharedSettingsStore: SettingsStore

    init() {
        sharedSettingsStore = .init()
        sharedModelContainer = {
            do {
                return try .init(
                    for: MaskingSession.self,
                    MappingRecord.self
                )
            } catch {
                assertionFailure(error.localizedDescription)
                return try! .init(
                    for: MaskingSession.self,
                    MappingRecord.self,
                    configurations: .init(
                        isStoredInMemoryOnly: true
                    )
                )
            }
        }()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
                .environment(sharedSettingsStore)
        }
    }
}
