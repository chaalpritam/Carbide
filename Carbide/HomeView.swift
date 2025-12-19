
import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\FileItem.modifiedAt, order: .reverse)]) var recentFiles: [FileItem]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Storage Header
                StorageHeaderView()
                    .padding(.horizontal)
                
                // Categories
                VStack(alignment: .leading, spacing: 16) {
                    Text("Categories")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            categoryPill(name: "Images", icon: "photo", color: .purple)
                            categoryPill(name: "Videos", icon: "video", color: .red)
                            categoryPill(name: "Docs", icon: "doc.text", color: .blue)
                            categoryPill(name: "Audio", icon: "music.note", color: .orange)
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Recent Files
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Recent Files")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Button("View All") { }
                            .font(.subheadline)
                            .foregroundColor(Theme.primary)
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(recentFiles.prefix(4))) { file in
                            NavigationLink(destination: FileDetailView(item: file)) {
                                FileCardView(item: file)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if recentFiles.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "doc.badge.plus")
                                .font(.system(size: 48))
                                .foregroundColor(Theme.surfaceSecondary)
                            Text("No files yet")
                                .foregroundColor(Theme.textSecondary)
                            Button("Add Sample Data") {
                                seedData()
                            }
                            .buttonStyle(.bordered)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Theme.background)
        .navigationTitle("Carbide")
    }
    
    private func categoryPill(name: String, icon: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Theme.surface)
        .cornerRadius(20)
        .shadow(color: Theme.cardShadow, radius: 4, x: 0, y: 2)
    }
    
    private func seedData() {
        let items = FileItem.mockData
        for item in items {
            modelContext.insert(item)
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .modelContainer(for: FileItem.self, inMemory: true)
    }
}
