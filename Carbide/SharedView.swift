
import SwiftUI
import SwiftData

struct SharedView: View {
    @Query(filter: #Predicate<FileItem> { $0.isShared }, sort: [SortDescriptor(\FileItem.modifiedAt, order: .reverse)]) 
    var sharedFiles: [FileItem]
    
    var body: some View {
        VStack(spacing: 0) {
            if sharedFiles.isEmpty {
                ContentUnavailableView(
                    "No Shared Files",
                    systemImage: "person.2.badge.gearshape",
                    description: Text("Files shared with you by others will appear here.")
                )
            } else {
                List {
                    ForEach(sharedFiles) { file in
                        FolderRowView(item: file)
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(Theme.background)
        .navigationTitle("Shared")
    }
}

#Preview {
    NavigationStack {
        SharedView()
            .modelContainer(for: FileItem.self, inMemory: true)
    }
}
