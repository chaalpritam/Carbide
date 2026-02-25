//
//  CarbideApp.swift
//  Carbide
//
//  Created by Chaal Pritam on 19/12/25.
//

import SwiftUI
import SwiftData

@main
struct CarbideApp: App {
    private let sharedModelContainer: ModelContainer?

    init() {
        let schema = Schema([FileItem.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        self.sharedModelContainer = try? ModelContainer(for: schema, configurations: [config])
    }

    var body: some Scene {
        WindowGroup {
            if let container = sharedModelContainer {
                ContentView()
                    .modelContainer(container)
            } else {
                ContentUnavailableView(
                    "Unable to Load Data",
                    systemImage: "exclamationmark.triangle",
                    description: Text("Carbide could not initialize its database. Please restart the app or reinstall.")
                )
            }
        }
    }
}
