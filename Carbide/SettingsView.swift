
import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var allFiles: [FileItem]
    @State private var notificationsEnabled = true
    @State private var cloudSyncEnabled = true

    private var syncedCount: Int {
        allFiles.filter(\.isSyncedToCarbide).count
    }

    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Theme.primary)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Carbide User")
                            .font(.headline)
                        Text("\(allFiles.count) files · \(syncedCount) synced")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding(.vertical, 8)
            }

            Section("Storage") {
                VStack(alignment: .leading, spacing: 12) {
                    StorageHeaderView()
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }

            Section("Preferences") {
                Toggle("Notifications", isOn: $notificationsEnabled)
                    .tint(Theme.primary)
                Toggle("Cloud Sync", isOn: $cloudSyncEnabled)
                    .tint(Theme.primary)
            }

            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(Theme.textSecondary)
                }

                Link(destination: URL(string: "https://carbidenetwork.xyz/privacy")!) {
                    Text("Privacy Policy")
                        .foregroundColor(Theme.textMain)
                }

                Link(destination: URL(string: "https://carbidenetwork.xyz/terms")!) {
                    Text("Terms of Service")
                        .foregroundColor(Theme.textMain)
                }
            }
        }
        .background(Theme.background)
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .modelContainer(for: FileItem.self, inMemory: true)
    }
}
