# Carbide

Carbide is a decentralized file storage app for iOS, powered by the [Carbide Network](https://carbidenetwork.xyz). Upload, manage, and sync files across Carbide's provider network with end-to-end encryption.

## Features

- **Decentralized Storage**: Files stored across Carbide network providers, not centralized servers.
- **End-to-End Encryption**: Files are encrypted before upload via CarbideSDK.
- **Full File Management**: Create folders, upload photos, rename, delete, star, and share files.
- **Real-Time Storage Dashboard**: See actual storage usage computed from your files.
- **Smart Categorization**: Quick-access filters for Images, Videos, Documents, and Audio.
- **SwiftData Persistence**: All metadata saved locally with SwiftData.

## Tech stack

- **SwiftUI** — declarative UI
- **SwiftData** — local persistence
- **CarbideSDK** — decentralized storage network client (`carbide-ios-sdk`)

## Requirements

- Xcode 16.0+
- iOS 18.1+
- Swift 5.9+
- CarbideSDK (local Swift package dependency)

## Running locally

For day-to-day development you typically run against either the production discovery service (default) or a local one.

1. **Clone and open**:
   ```sh
   git clone <repository-url>
   cd Carbide
   open Carbide.xcodeproj
   ```
2. **Add the CarbideSDK local package** (only needed once):
   - In Xcode: *File → Add Package Dependencies → Add Local…*
   - Pick the sibling `carbide-ios-sdk` directory.
3. **Pick a destination** (Simulator or attached device) and *Cmd+R*.

### Local development against your own stack

To run against a local discovery + provider:

1. Start `carbide-discovery-service` on your dev machine (defaults to `:9090`).
2. Run a `carbide-provider` and point its `discovery_endpoint` at the local discovery service.
3. In the Carbide app, override the discovery URL — by default the app constructs `CarbideClient()` (production endpoint). For local work, swap that to `CarbideClient(discoveryServiceURL: URL(string: "http://<your-laptop-ip>:9090")!)`. iOS Simulator can use `http://localhost:9090`; a physical device needs the LAN IP.

   Note iOS App Transport Security: hitting plain `http://` from a device requires an `NSAppTransportSecurity` exception in `Info.plist` (allow arbitrary loads for local development only).

### Tests

```sh
xcodebuild test \
  -project Carbide.xcodeproj \
  -scheme Carbide \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Running in production

The app ships through the Apple App Store / TestFlight. There is no separate "deploy" step — every build is an Xcode archive signed with the production team certificate.

1. **Bump the version** in the Xcode target (`MARKETING_VERSION` and `CURRENT_PROJECT_VERSION`).
2. **Archive** (Xcode → *Product → Archive*) with the *Generic iOS Device* destination.
3. **Validate & upload** to App Store Connect from the Organizer window.
4. **Distribute via TestFlight** for internal/external testing, or submit for App Store review when ready.

Production builds use the SDK's default discovery endpoint (`https://discovery.carbidenetwork.xyz`); double-check `CarbideClient()` is constructed without a custom URL before archiving.

### Configuration to verify before shipping

- **Signing & capabilities**: production team selected, push/keychain entitlements present.
- **Discovery endpoint**: production (no localhost overrides).
- **App Transport Security**: no permissive exceptions in `Info.plist` (no `NSAllowsArbitraryLoads`).
- **Build configuration**: archive uses `Release` (not `Debug`).

## Project structure

- `Carbide/` — main application source
  - `CarbideApp.swift` — app entry point
  - `StorageManager.swift` — Carbide network operations
  - `FileItem.swift` — SwiftData model
  - Views: `HomeView`, `FilesView`, `SharedView`, `SettingsView`, `FileDetailView`
  - Components: `FileComponents`, `StorageHeaderView`, `Theme`
- `CarbideTests/` — unit tests
- `CarbideUITests/` — UI tests
