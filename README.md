# Carbide

Carbide is a decentralized file storage app for iOS, powered by the [Carbide Network](https://carbidenetwork.xyz). Upload, manage, and sync files across Carbide's provider network with end-to-end encryption.

## Features

- **Decentralized Storage**: Files stored across Carbide network providers, not centralized servers.
- **End-to-End Encryption**: Files are encrypted before upload via CarbideSDK.
- **Full File Management**: Create folders, upload photos, rename, delete, star, and share files.
- **Real-Time Storage Dashboard**: See actual storage usage computed from your files.
- **Smart Categorization**: Quick-access filters for Images, Videos, Documents, and Audio.
- **SwiftData Persistence**: All metadata saved locally with SwiftData.

## Tech Stack

- **SwiftUI** - Declarative UI framework
- **SwiftData** - Local data persistence
- **CarbideSDK** - Decentralized storage network client

## Requirements

- Xcode 16.0+
- iOS 18.1+
- Swift 5.9+
- CarbideSDK package (local dependency)

## Getting Started

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd Carbide
   ```

2. Add the CarbideSDK local package:
   - In Xcode: File > Add Package Dependencies > Add Local
   - Select the `carbide-ios-sdk` directory

3. Build and run (Cmd+R).

## Project Structure

- `Carbide/` - Main application source
  - `CarbideApp.swift` - App entry point
  - `StorageManager.swift` - Carbide network operations
  - `FileItem.swift` - SwiftData model
  - Views: `HomeView`, `FilesView`, `SharedView`, `SettingsView`, `FileDetailView`
  - Components: `FileComponents`, `StorageHeaderView`, `Theme`
- `CarbideTests/` - Unit tests
- `CarbideUITests/` - UI tests
