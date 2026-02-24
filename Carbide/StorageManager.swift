import Foundation
import SwiftData

// NOTE: To use this file, you need to:
// 1. Add the CarbideSDK package to the Xcode project
// 2. Uncomment the import line below
// 3. Build and run

import CarbideSDK

/// Manager for Carbide network storage operations
///
/// This class bridges the Carbide iOS app with the CarbideSDK to enable
/// file upload, download, and synchronization with the Carbide decentralized storage network.
///
/// ## Setup
/// Before using StorageManager:
/// 1. Add CarbideSDK to the Xcode project:
///    - File → Add Package Dependencies
///    - Enter local path: `../carbide-ios-sdk`
/// 2. Uncomment the `import CarbideSDK` line above
/// 3. Ensure discovery service is running on localhost:9090
/// 4. Build and run the app
///
/// ## Usage
/// ```swift
/// let storageManager = StorageManager(modelContext: modelContext)
///
/// // Upload a file
/// let fileItem = try await storageManager.uploadFile(
///     from: fileURL,
///     encrypt: true,
///     progress: { progress in
///         print("Upload: \(Int(progress * 100))%")
///     }
/// )
///
/// // Download a file
/// let data = try await storageManager.downloadFile(item: fileItem)
/// ```
@Observable
final class StorageManager {
    // Uncomment when SDK is added to project
    private let client: CarbideClient
    private let modelContext: ModelContext

    /// Initialize storage manager
    /// - Parameter modelContext: SwiftData model context
    init(modelContext: ModelContext) {
        self.modelContext = modelContext

        let discoveryURL = URL(string: "https://discovery.carbidenetwork.xyz")!
        self.client = CarbideClient(discoveryServiceURL: discoveryURL)
    }

    // MARK: - File Upload

    /// Upload a file to the Carbide network
    /// - Parameters:
    ///   - fileURL: Local file URL
    ///   - encrypt: Whether to encrypt before upload
    ///   - progress: Upload progress callback (0.0 to 1.0)
    /// - Returns: FileItem with Carbide metadata
    func uploadFile(
        from fileURL: URL,
        encrypt: Bool = true,
        progress: @escaping (Double) -> Void
    ) async throws -> FileItem {
        // 1. Get available providers
        let providers = try await client.searchProviders(
            region: .northAmerica,
            tier: .home,
            limit: 5
        )

        guard let provider = providers.first else {
            throw NSError(domain: "StorageManager", code: 404, userInfo: [
                NSLocalizedDescriptionKey: "No providers available"
            ])
        }

        // 2. Upload file with progress tracking
        let result = try await client.uploadFile(
            from: fileURL,
            to: provider,
            encrypt: encrypt,
            progress: progress
        )

        // 3. Create FileItem for SwiftData
        let fileName = fileURL.lastPathComponent
        let fileItem = FileItem(
            name: fileName,
            type: determineFileType(from: fileURL),
            size: Int64(result.fileSize)
        )

        // 4. Store Carbide metadata
        fileItem.carbideFileID = result.fileID
        fileItem.carbideProviderID = result.providerID
        fileItem.carbideProviderEndpoint = result.providerEndpoint
        fileItem.isEncrypted = encrypt
        fileItem.isSyncedToCarbide = true

        // 5. Save to SwiftData
        modelContext.insert(fileItem)
        try modelContext.save()

        return fileItem
    }

    // MARK: - File Download

    /// Download a file from the Carbide network
    /// - Parameter item: FileItem with Carbide metadata
    /// - Returns: Downloaded file data
    func downloadFile(item: FileItem) async throws -> Data {
        guard let fileID = item.carbideFileID,
              let providerID = item.carbideProviderID else {
            throw NSError(domain: "StorageManager", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "File is not synced to Carbide network"
            ])
        }

        // Get provider details
        let provider = try await client.getProvider(id: providerID)

        // Download file (key retrieved from keychain automatically)
        let data = try await client.downloadFile(
            fileID: fileID,
            from: provider,
            progress: { progress in
                print("Download progress: \(Int(progress * 100))%")
            }
        )

        return data
    }

    // MARK: - Synchronization

    /// Sync all files from Carbide network to local SwiftData
    func syncFiles() async throws {
        let providers = try await client.listProviders()

        for provider in providers {
            let files = try await client.listFiles(on: provider)

            for fileMetadata in files {
                // Check if file already exists locally
                let fetchDescriptor = FetchDescriptor<FileItem>(
                    predicate: #Predicate { $0.carbideFileID == fileMetadata.id }
                )

                let existing = try modelContext.fetch(fetchDescriptor)

                if existing.isEmpty {
                    // Create new FileItem
                    let newItem = FileItem(
                        name: fileMetadata.fileName,
                        type: .other, // TODO: Determine from content type
                        size: Int64(fileMetadata.fileSize)
                    )
                    newItem.carbideFileID = fileMetadata.id
                    newItem.carbideProviderID = fileMetadata.providerID
                    newItem.isEncrypted = fileMetadata.isEncrypted
                    newItem.isSyncedToCarbide = true

                    modelContext.insert(newItem)
                }
            }
        }

        try modelContext.save()
    }

    /// Delete file from Carbide network
    /// - Parameter item: FileItem to delete
    func deleteFromCarbide(item: FileItem) async throws {
        guard let fileID = item.carbideFileID,
              let providerID = item.carbideProviderID else {
            return
        }

        let provider = try await client.getProvider(id: providerID)

        try await client.deleteFile(
            fileID: fileID,
            from: provider,
            deleteKey: true
        )

        item.carbideFileID = nil
        item.carbideProviderID = nil
        item.carbideProviderEndpoint = nil
        item.isSyncedToCarbide = false

        try modelContext.save()
    }

    // MARK: - Helper Methods

    private func determineFileType(from url: URL) -> FileType {
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "jpg", "jpeg", "png", "heic", "gif", "webp":
            return .image
        case "mp4", "mov", "avi", "mkv", "m4v":
            return .video
        case "pdf":
            return .pdf
        case "doc", "docx", "txt", "rtf", "pages":
            return .document
        case "xls", "xlsx", "numbers", "csv":
            return .spreadsheet
        default:
            return .other
        }
    }
}

// MARK: - Integration Instructions

/*
 ## How to Integrate CarbideSDK with the iOS App

 ### Step 1: Add SDK Package to Xcode Project

 1. Open Carbide.xcodeproj in Xcode
 2. File → Add Package Dependencies
 3. Click "Add Local..."
 4. Navigate to and select: /Users/chaalpritam/Blockbase/carbide-ios-sdk
 5. Click "Add Package"
 6. Select the Carbide target and click "Add Package"

 ### Step 2: Enable StorageManager

 1. In this file (StorageManager.swift), uncomment:
    - `import CarbideSDK` at the top
    - `private let client: CarbideClient` property
    - SDK initialization in `init()`
    - All TODO sections in the methods

 ### Step 3: Update FilesView for Upload

 Add upload functionality to FilesView.swift:

 ```swift
 import PhotosUI

 @State private var storageManager: StorageManager?
 @State private var selectedPhoto: PhotosPickerItem?
 @State private var uploadProgress: Double = 0.0
 @State private var isUploading = false

 // In body:
 PhotosPicker(selection: $selectedPhoto, matching: .images) {
     Label("Upload Photo", systemImage: "plus.circle.fill")
 }
 .onChange(of: selectedPhoto) { _, newValue in
     Task { await uploadPhoto(newValue) }
 }

 if isUploading {
     ProgressView(value: uploadProgress, total: 1.0)
         .padding()
 }

 // Add method:
 private func uploadPhoto(_ item: PhotosPickerItem?) async {
     guard let item = item,
           let data = try? await item.loadTransferable(type: Data.self) else {
         return
     }

     isUploading = true
     uploadProgress = 0.0

     let tempURL = FileManager.default.temporaryDirectory
         .appendingPathComponent(UUID().uuidString)
         .appendingPathExtension("jpg")

     do {
         try data.write(to: tempURL)

         let fileItem = try await storageManager?.uploadFile(
             from: tempURL,
             encrypt: true,
             progress: { progress in
                 Task { @MainActor in
                     uploadProgress = progress
                 }
             }
         )

         try? FileManager.default.removeItem(at: tempURL)
     } catch {
         print("Upload failed: \(error)")
     }

     isUploading = false
 }

 // Initialize manager:
 .onAppear {
     storageManager = StorageManager(modelContext: modelContext)
 }
 ```

 ### Step 4: Start Discovery Service

 Before running the app, ensure the discovery service is running:

 ```bash
 cd /Users/chaalpritam/Blockbase/carbide-discovery-service
 npm install
 npm start
 ```

 The discovery service should be running on http://localhost:9090

 ### Step 5: Start Provider Node (Optional)

 To test uploads, you need at least one provider running:

 ```bash
 cd /Users/chaalpritam/Blockbase/carbide-node
 cargo run --bin provider
 ```

 ### Step 6: Build and Run

 1. Build the project (Cmd+B)
 2. Run on simulator or device (Cmd+R)
 3. Test uploading a photo
 4. Check that it appears in the files list

 ### Troubleshooting

 - **"No providers available"**: Ensure discovery service and at least one provider are running
 - **Build errors**: Make sure CarbideSDK package is properly added and imports are uncommented
 - **Connection errors**: Check that localhost:9090 is accessible from the simulator
 */
