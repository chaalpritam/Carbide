
import SwiftUI
import SwiftData

struct StorageHeaderView: View {
    @Query var allFiles: [FileItem]

    private let totalStorage: Int64 = 15 * 1024 * 1024 * 1024 // 15GB plan

    private var usedStorage: Int64 {
        allFiles.reduce(0) { $0 + $1.size }
    }

    private var progress: Double {
        guard totalStorage > 0 else { return 0 }
        return min(Double(usedStorage) / Double(totalStorage), 1.0)
    }

    private var documentsSize: Int64 {
        allFiles.filter { [.document, .pdf, .spreadsheet, .other].contains($0.type) }.reduce(0) { $0 + $1.size }
    }

    private var mediaSize: Int64 {
        allFiles.filter { [.image, .video].contains($0.type) }.reduce(0) { $0 + $1.size }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Storage")
                        .font(.headline)
                        .foregroundColor(Theme.textMain)

                    Text("\(format(usedStorage)) of \(format(totalStorage)) used")
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                }

                Spacer()

                Image(systemName: "cloud.fill")
                    .font(.title2)
                    .foregroundColor(Theme.primary)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Theme.surfaceSecondary)
                        .frame(height: 8)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Theme.primary, Theme.primary.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)

            HStack(spacing: 20) {
                storageBreakdown(label: "Documents", color: Theme.primary)
                storageBreakdown(label: "Media", color: Theme.quaternary)
            }
        }
        .padding(20)
        .background(Theme.surface)
        .cornerRadius(Theme.cardRadius)
        .shadow(color: Theme.cardShadow, radius: 10, x: 0, y: 5)
    }

    private func storageBreakdown(label: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
    }

    private func format(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

#Preview {
    StorageHeaderView()
        .padding()
        .background(Theme.background)
        .modelContainer(for: FileItem.self, inMemory: true)
}
