
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

extension FileItem {
    static var mockData: [FileItem] {
        // Folders
        let photos = FileItem(name: "Summer Vacation 2024", type: .folder)
        let work = FileItem(name: "Project Carbide", type: .folder, isStarred: true)
        let documents = FileItem(name: "Personal Documents", type: .folder)
        let finance = FileItem(name: "Finance & Taxes", type: .folder)
        let videos = FileItem(name: "Raw Footage", type: .folder)
        
        // Photo folder contents
        photos.children = [
            FileItem(name: "Beach_Sunset.jpg", type: .image, size: 4 * 1024 * 1024),
            FileItem(name: "Family_Dinner.png", type: .image, size: 3 * 1024 * 1024),
            FileItem(name: "Mountain_View.heic", type: .image, size: 5 * 1024 * 1024),
            FileItem(name: "Surfing_Video.mov", type: .video, size: 120 * 1024 * 1024, isStarred: true)
        ]
        
        // Work folder contents
        work.children = [
            FileItem(name: "Architecture_Draft.pdf", type: .pdf, size: 12 * 1024 * 1024),
            FileItem(name: "Roadmap_2025.docx", type: .document, size: 2 * 1024 * 1024, isShared: true),
            FileItem(name: "Q4_Performance.xlsx", type: .spreadsheet, size: 800 * 1024),
            FileItem(name: "Brand_Assets.zip", type: .other, size: 45 * 1024 * 1024, isShared: true)
        ]
        
        // Finance folder contents
        finance.children = [
            FileItem(name: "Tax_Return_2023.pdf", type: .pdf, size: 1 * 1024 * 1024),
            FileItem(name: "Investment_Portfolio.xlsx", type: .spreadsheet, size: 400 * 1024, isStarred: true)
        ]
        
        // Floating Top Level Files
        let introVideo = FileItem(name: "App_Introduction.mp4", type: .video, size: 250 * 1024 * 1024, isStarred: true)
        let resume = FileItem(name: "Chaal_Pritam_Resume.pdf", type: .pdf, size: 500 * 1024, isShared: true)
        let notes = FileItem(name: "Meeting_Notes.txt", type: .document, size: 15 * 1024)
        
        return [photos, work, documents, finance, videos, introVideo, resume, notes]
    }
}
