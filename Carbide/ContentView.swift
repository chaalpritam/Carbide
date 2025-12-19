//
//  ContentView.swift
//  Carbide
//
//  Created by Chaal Pritam on 19/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            NavigationStack {
                FilesView()
            }
            .tabItem {
                Label("Files", systemImage: "folder.fill")
            }
            .tag(1)
            
            NavigationStack {
                Text("Shared View")
                    .navigationTitle("Shared")
            }
            .tabItem {
                Label("Shared", systemImage: "person.2.fill")
            }
            .tag(2)
            
            NavigationStack {
                Text("Settings View")
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(3)
        }
        .accentColor(Theme.primary)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FileItem.self, inMemory: true)
}
