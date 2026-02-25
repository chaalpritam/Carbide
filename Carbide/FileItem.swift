
import Foundation
import SwiftData
import SwiftUI

enum FileType: String, Codable, CaseIterable {
    case folder
    case image
    case video
    case document
    case pdf
    case spreadsheet
    case other
    
    var icon: String {
        switch self {
        case .folder: return "folder.fill"
        case .image: return "photo.fill"
        case .video: return "video.fill"
        case .document: return "doc.text.fill"
        case .pdf: return "doc.richtext.fill"
        case .spreadsheet: return "tablecells.fill"
        case .other: return "doc.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .folder: return .blue
        case .image: return .purple
        case .video: return .red
        case .document: return .blue
        case .pdf: return .orange
        case .spreadsheet: return .green
        case .other: return .gray
        }
    }
}

@Model
final class FileItem: Identifiable {
    var id: UUID
    var name: String
    var type: FileType
    var size: Int64 // in bytes
    var createdAt: Date
    var modifiedAt: Date
    var isStarred: Bool
    var isShared: Bool

    // Carbide network metadata
    var carbideFileID: String? // File hash from Carbide network
    var carbideProviderID: String? // Provider UUID
    var carbideProviderEndpoint: String? // Provider endpoint URL
    var isEncrypted: Bool = false
    var isSyncedToCarbide: Bool = false

    @Relationship(deleteRule: .cascade, inverse: \FileItem.parent)
    var children: [FileItem] = []

    var parent: FileItem?

    init(name: String, type: FileType, size: Int64 = 0, isStarred: Bool = false, isShared: Bool = false) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.size = size
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.isStarred = isStarred
        self.isShared = isShared
        self.children = []
    }
    
    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
}
