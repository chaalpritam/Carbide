
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
        let root = FileItem(name: "My Drive", type: .folder)
        
        let photos = FileItem(name: "Photos", type: .folder)
        photos.children = [
            FileItem(name: "Vacation.jpg", type: .image, size: 2 * 1024 * 1024),
            FileItem(name: "Sunset.png", type: .image, size: 1 * 1024 * 1024),
            FileItem(name: "Party.mp4", type: .video, size: 45 * 1024 * 1024)
        ]
        
        let work = FileItem(name: "Work", type: .folder)
        work.children = [
            FileItem(name: "Project.pdf", type: .pdf, size: 5 * 1024 * 1024, isStarred: true),
            FileItem(name: "Budget.xlsx", type: .spreadsheet, size: 512 * 1024),
            FileItem(name: "Meeting_Notes.docx", type: .document, size: 128 * 1024)
        ]
        
        return [photos, work, FileItem(name: "Taxes_2024.pdf", type: .pdf, size: 2 * 1024 * 1024, isShared: true)]
    }
}
