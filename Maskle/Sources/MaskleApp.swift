//
//  MaskleApp.swift
//  Maskle
//
//  Created by Hiromu Nakano on 2025/11/23.
//

import MaskleLibrary
import StoreKitWrapper
import SwiftData
import SwiftUI

@main
struct MaskleApp: App {
    @AppStorage(.isICloudOn)
    private var isICloudOn

    private var sharedModelContainer: ModelContainer!
    private var sharedSettingsStore: SettingsStore
    private var sharedMaskSessionStore: MaskSessionStore
    private var sharedStore: Store

    init() {
        sharedSettingsStore = .init()
        sharedMaskSessionStore = .init()
        sharedStore = .init()
        sharedModelContainer = {
            do {
                return try .init(
                    for: MaskingSession.self,
                    MappingRecord.self,
                    configurations: .init(
                        cloudKitDatabase: isICloudOn ? .automatic : .none
                    )
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
                .id(isICloudOn)
                .modelContainer(sharedModelContainer)
                .environment(sharedSettingsStore)
                .environment(sharedMaskSessionStore)
                .environment(sharedStore)
        }
    }
}
