
import SwiftUI

struct StorageHeaderView: View {
    var usedStorage: Int64 = 12 * 1024 * 1024 * 1024 // 12GB
    var totalStorage: Int64 = 15 * 1024 * 1024 * 1024 // 15GB
    
    var progress: Double {
        Double(usedStorage) / Double(totalStorage)
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
            
            // Progress Bar
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
                storageBreakdown(label: "Drive", color: Theme.primary, percentage: 0.6)
                storageBreakdown(label: "Gmail", color: Theme.secondary, percentage: 0.2)
                storageBreakdown(label: "Photos", color: Theme.tertiary, percentage: 0.1)
            }
        }
        .padding(20)
        .background(Theme.surface)
        .cornerRadius(Theme.cardRadius)
        .shadow(color: Theme.cardShadow, radius: 10, x: 0, y: 5)
    }
    
    private func storageBreakdown(label: String, color: Color, percentage: Double) -> some View {
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
}
