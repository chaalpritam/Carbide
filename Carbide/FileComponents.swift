
import SwiftUI

struct FileCardView: View {
    let item: FileItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: item.type.icon)
                    .font(.title2)
                    .foregroundColor(item.type.color)

                Spacer()

                if item.isStarred {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(Theme.tertiary)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .foregroundColor(Theme.textMain)
                
                Text(item.type == .folder ? "Folder" : item.formattedSize)
                    .font(.caption2)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(16)
        .background(Theme.surface)
        .cornerRadius(Theme.cardRadius)
        .shadow(color: Theme.cardShadow, radius: 5, x: 0, y: 2)
    }
}

struct FolderRowView: View {
    let item: FileItem
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(item.type.color.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: item.type.icon)
                    .foregroundColor(item.type.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(item.type == .folder ? "Folder" : item.formattedSize)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            if item.isStarred {
                Image(systemName: "star.fill")
                    .foregroundColor(Theme.tertiary)
                    .font(.caption)
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .padding(.vertical, 8)
    }
}
