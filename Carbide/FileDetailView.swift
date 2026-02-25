
import SwiftUI

struct FileDetailView: View {
    @Bindable var item: FileItem
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(item.type.color.opacity(0.1))
                        .frame(width: 120, height: 120)

                    Image(systemName: item.type.icon)
                        .font(.system(size: 60))
                        .foregroundColor(item.type.color)
                }
                .padding(.top, 40)

                VStack(spacing: 8) {
                    Text(item.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Text("\(item.type.rawValue.capitalized) • \(item.formattedSize)")
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                }

                HStack(spacing: 20) {
                    ShareLink(item: item.name) {
                        VStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title3)
                            Text("Share")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(Theme.textMain)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.surface)
                        .cornerRadius(12)
                        .shadow(color: Theme.cardShadow, radius: 4, x: 0, y: 2)
                    }

                    actionButton(icon: item.isStarred ? "star.fill" : "star", label: "Star", color: item.isStarred ? Theme.tertiary : Theme.textMain) {
                        item.isStarred.toggle()
                        item.modifiedAt = Date()
                    }
                    actionButton(icon: "trash", label: "Delete", color: Theme.secondary) {
                        modelContext.delete(item)
                        dismiss()
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Details")
                        .font(.headline)
                        .padding(.horizontal)

                    VStack(spacing: 0) {
                        detailRow(label: "Type", value: item.type.rawValue.capitalized)
                        Divider().padding(.leading)
                        detailRow(label: "Size", value: item.formattedSize)
                        Divider().padding(.leading)
                        detailRow(label: "Created", value: item.createdAt.formatted(date: .abbreviated, time: .shortened))
                        Divider().padding(.leading)
                        detailRow(label: "Modified", value: item.modifiedAt.formatted(date: .abbreviated, time: .shortened))
                        Divider().padding(.leading)
                        detailRow(label: "Location", value: item.parent?.name ?? "My Drive")
                        if item.isSyncedToCarbide {
                            Divider().padding(.leading)
                            detailRow(label: "Network", value: item.isEncrypted ? "Encrypted" : "Synced")
                        }
                    }
                    .background(Theme.surface)
                    .cornerRadius(Theme.cardRadius)
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 40)
        }
        .background(Theme.background)
        .navigationTitle("File Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func actionButton(icon: String, label: String, color: Color = Theme.textMain, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Theme.surface)
            .cornerRadius(12)
            .shadow(color: Theme.cardShadow, radius: 4, x: 0, y: 2)
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(Theme.textSecondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding()
    }
}
