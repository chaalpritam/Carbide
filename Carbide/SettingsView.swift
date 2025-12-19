
import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var cloudSyncEnabled = true
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Theme.primary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Chaal Pritam")
                            .font(.headline)
                        Text("chaal.pritam@example.com")
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
                    
                    Button(action: {}) {
                        Text("Get More Storage")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.primary)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
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
                    Text("1.0.0 (Beta)")
                        .foregroundColor(Theme.textSecondary)
                }
                
                Link(destination: URL(string: "https://example.com")!) {
                    Text("Privacy Policy")
                        .foregroundColor(Theme.textMain)
                }
                
                Link(destination: URL(string: "https://example.com")!) {
                    Text("Terms of Service")
                        .foregroundColor(Theme.textMain)
                }
            }
            
            Section {
                Button(action: {}) {
                    Text("Sign Out")
                        .foregroundColor(Theme.secondary)
                        .frame(maxWidth: .infinity)
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
    }
}
