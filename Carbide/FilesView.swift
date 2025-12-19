
import SwiftUI
import SwiftData

struct FilesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<FileItem> { $0.parent == nil }, sort: [SortDescriptor(\FileItem.name)]) var rootFiles: [FileItem]
    
    @State private var viewMode: ViewMode = .list
    @State private var showingAddOptions = false
    @State private var showingRenameSheet = false
    @State private var itemToRename: FileItem?
    @State private var newName = ""
    
    enum ViewMode {
        case list, grid
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter Bar
            HStack {
                Text("\(rootFiles.count) items")
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: { viewMode = .list }) {
                        Image(systemName: "list.bullet")
                            .foregroundColor(viewMode == .list ? Theme.primary : Theme.textSecondary)
                    }
                    
                    Button(action: { viewMode = .grid }) {
                        Image(systemName: "square.grid.2x2")
                            .foregroundColor(viewMode == .grid ? Theme.primary : Theme.textSecondary)
                    }
                }
            }
            .padding()
            .background(Theme.surface)
            
            Divider()
            
            if viewMode == .list {
                List {
                    ForEach(rootFiles) { item in
                        Group {
                            if item.type == .folder {
                                NavigationLink(destination: FolderDetailView(folder: item)) {
                                    FolderRowView(item: item)
                                }
                            } else {
                                NavigationLink(destination: FileDetailView(item: item)) {
                                    FolderRowView(item: item)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                modelContext.delete(item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                itemToRename = item
                                newName = item.name
                                showingRenameSheet = true
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(.plain)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(rootFiles) { item in
                            if item.type == .folder {
                                NavigationLink(destination: FolderDetailView(folder: item)) {
                                    FileCardView(item: item)
                                }
                            } else {
                                NavigationLink(destination: FileDetailView(item: item)) {
                                    FileCardView(item: item)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Theme.background)
        .navigationTitle("My Drive")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddOptions = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(Theme.primary)
                }
            }
        }
        .confirmationDialog("Add New", isPresented: $showingAddOptions) {
            Button("New Folder") { addItem(type: .folder) }
            Button("Upload Photo") { addItem(type: .image) }
            Button("New Document") { addItem(type: .document) }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showingRenameSheet) {
            NavigationStack {
                Form {
                    TextField("Name", text: $newName)
                }
                .navigationTitle("Rename")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showingRenameSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if let item = itemToRename {
                                item.name = newName
                                try? modelContext.save()
                            }
                            showingRenameSheet = false
                        }
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
    
    private func addItem(type: FileType) {
        let name: String
        switch type {
        case .folder: name = "New Folder"
        case .image: name = "New Photo.jpg"
        case .document: name = "New Document.docx"
        default: name = "New Item"
        }
        
        let newItem = FileItem(name: name, type: type)
        modelContext.insert(newItem)
    }
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(rootFiles[index])
        }
    }
}

struct FolderDetailView: View {
    let folder: FileItem
    
    var body: some View {
        List {
            if !folder.children.isEmpty {
                ForEach(folder.children) { child in
                    if child.type == .folder {
                        NavigationLink(destination: FolderDetailView(folder: child)) {
                            FolderRowView(item: child)
                        }
                    } else {
                        NavigationLink(destination: FileDetailView(item: child)) {
                            FolderRowView(item: child)
                        }
                    }
                }
            } else {
                ContentUnavailableView("Folder is Empty", systemImage: "folder.badge.minus", description: Text("Upload files to see them here"))
            }
        }
        .navigationTitle(folder.name)
    }
}

#Preview {
    NavigationStack {
        FilesView()
            .modelContainer(for: FileItem.self, inMemory: true)
    }
}
