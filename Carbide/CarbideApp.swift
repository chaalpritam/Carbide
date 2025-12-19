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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FileItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    seedDataIfNeeded()
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    @MainActor
    private func seedDataIfNeeded() {
        let context = sharedModelContainer.mainContext
        let fetchDescriptor = FetchDescriptor<FileItem>()
        if let count = try? context.fetchCount(fetchDescriptor), count == 0 {
            let items = FileItem.mockData
            for item in items {
                context.insert(item)
            }
            try? context.save()
        }
    }
}
