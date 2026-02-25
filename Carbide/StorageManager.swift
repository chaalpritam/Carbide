import Foundation
import SwiftData
import CarbideSDK

@Observable
final class StorageManager {
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

        let data = try await client.downloadFile(
            fileID: fileID,
            from: provider,
            progress: { _ in }
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
                        type: determineFileType(fromName: fileMetadata.fileName),
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
        determineFileType(fromName: url.lastPathComponent)
    }

    private func determineFileType(fromName name: String) -> FileType {
        let ext = (name as NSString).pathExtension.lowercased()
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
