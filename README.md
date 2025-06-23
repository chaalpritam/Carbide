# Carbide - Google Photos iOS App Clone

A React Native iOS app that replicates the Google Photos interface with the exact same screens, text, colors, and layout as the original iOS app, including detailed views and photo permissions.

## Features

### 📱 Screens & Navigation

1. **Photos Tab**
   - Grid layout with photos organized by date
   - Large header with "Photos" title
   - Search button in header
   - Photos grouped by "Today", "Yesterday", "Last week"
   - 3-column grid layout with rounded corners
   - **Photo Detail Screen**: Full-screen photo view with edit, crop, filter actions

2. **For You Tab**
   - Memories section with large cards
   - Overlay text showing date and photo count
   - Beautiful gradient overlays on memory cards
   - "For you" header title
   - **Memory Detail Screen**: Expanded memory view with related photos

3. **Albums Tab**
   - List of albums with thumbnails
   - Album names and photo counts
   - "Albums" header title
   - Default albums: Recents, Favorites, Screenshots, Camera
   - **Album Detail Screen**: Grid view of album photos with slideshow and select options

4. **Search Tab**
   - Category cards for different search types
   - Colorful icons for each category
   - Categories: People, Places, Things, Videos
   - "Search" header title
   - **Search Results Screen**: Detailed results for each category with photo counts

5. **Library Tab**
   - List of library items with icons
   - Items: Recently Deleted, Hidden, Imports
   - "Library" header title
   - Chevron indicators for navigation
   - **Library Detail Screen**: Content-specific views with empty states

### 🔐 Photo Permissions

- **iOS Photo Library Access**: Proper permission requests with user-friendly dialogs
- **Permission Request Screen**: Beautiful onboarding screen explaining photo access needs
- **Automatic Permission Checking**: App checks permissions on startup
- **Graceful Fallback**: Shows permission request if access not granted
- **Settings Integration**: Directs users to iOS Settings if permission denied

### 🎨 Design System

- **Colors**: Exact Google Photos iOS color scheme
  - Primary Blue: `#007AFF`
  - Background: `#FFFFFF`
  - Text: `#000000`
  - Secondary Text: `#8E8E93`
  - Borders: `#C7C7CC`
  - Category Background: `#F2F2F7`

- **Typography**:
  - Header titles: 34pt, Bold (700)
  - Section titles: 22pt, Semi-bold (600)
  - Date text: 22pt, Semi-bold (600)
  - Album titles: 17pt, Medium (500)
  - Photo counts: 15pt, Regular

- **Layout**:
  - Safe area aware
  - Proper iOS spacing and padding
  - Rounded corners on photos and cards
  - Bottom tab navigation with iOS styling
  - Stack navigation for detail screens

### 🔧 Technical Implementation

- **Navigation**: React Navigation with bottom tabs and stack navigators
- **Icons**: React Native Vector Icons (MaterialIcons)
- **Permissions**: React Native Permissions with iOS/Android support
- **Layout**: Flexbox with proper iOS spacing
- **Images**: Placeholder images from Picsum for demo
- **Styling**: StyleSheet with exact color codes
- **State Management**: React hooks for permission state

### 📱 Detail Screen Features

#### Photo Detail Screen
- Full-screen photo display
- Action buttons: Favorite, Share, More options
- Photo information: Date, location
- Edit actions: Edit, Crop, Filter buttons

#### Memory Detail Screen
- Large memory card display
- Memory title and photo count
- Related photos grid
- Share functionality

#### Album Detail Screen
- Album header with photo count
- Action buttons: Slideshow, Select
- Photo grid with album photos
- Album-specific actions

#### Search Results Screen
- Category-specific results
- People: Name, photo count, profile images
- Places: Location, photo count, location images
- Things: Category, photo count, category images
- Videos: Title, duration, video thumbnails

#### Library Detail Screen
- Content-specific layouts
- Recently Deleted: Empty state with delete icon
- Hidden: Empty state with visibility icon
- Imports: Photo grid with import dates

## Installation

1. Install dependencies:
```bash
npm install
```

2. Install iOS dependencies:
```bash
cd ios && bundle exec pod install
```

3. Run the iOS app:
```bash
npx react-native run-ios
```

## Project Structure

```
App.tsx                 # Main app with navigation and permissions
├── PermissionRequest   # Photo permission request screen
├── PhotosStack         # Photos tab with detail navigation
│   ├── PhotosScreen    # Photos grid view
│   └── PhotoDetail     # Photo detail screen
├── ForYouStack         # For You tab with detail navigation
│   ├── ForYouScreen    # Memories view
│   └── MemoryDetail    # Memory detail screen
├── AlbumsStack         # Albums tab with detail navigation
│   ├── AlbumsScreen    # Album list
│   └── AlbumDetail     # Album detail screen
├── SearchStack         # Search tab with detail navigation
│   ├── SearchScreen    # Search categories
│   └── SearchResults   # Search results screen
└── LibraryStack        # Library tab with detail navigation
    ├── LibraryScreen   # Library items
    └── LibraryDetail   # Library detail screen
```

## Dependencies

- `@react-navigation/native`
- `@react-navigation/bottom-tabs`
- `@react-navigation/stack`
- `react-native-vector-icons`
- `react-native-screens`
- `react-native-safe-area-context`
- `react-native-gesture-handler`
- `react-native-permissions`

## iOS Configuration

The app includes proper iOS configuration:
- Vector icons font files
- Info.plist font declarations
- Photo library permissions
- Xcode project font references
- Proper bundle configuration

## Permissions

### iOS Permissions
- `NSPhotoLibraryUsageDescription`: Access to read photos
- `NSPhotoLibraryAddUsageDescription`: Access to save photos

### Permission Flow
1. App checks photo permissions on startup
2. Shows permission request screen if not granted
3. Requests permission with user-friendly dialog
4. Handles permission denial gracefully
5. Provides settings access for manual permission enabling

## Screenshots

The app replicates the following Google Photos iOS screens:
- Photos grid with date grouping and detail views
- For You memories with expanded memory views
- Albums list with detailed album views
- Search categories with result screens
- Library items with content-specific detail views
- Permission request screen with iOS styling

All screens maintain the exact visual design, typography, and color scheme of the original Google Photos iOS app, with additional detail screens providing a complete user experience.

# Getting Started

> **Note**: Make sure you have completed the [Set Up Your Environment](https://reactnative.dev/docs/set-up-your-environment) guide before proceeding.

## Step 1: Start Metro

First, you will need to run **Metro**, the JavaScript build tool for React Native.

To start the Metro dev server, run the following command from the root of your React Native project:

```sh
# Using npm
npm start

# OR using Yarn
yarn start
```

## Step 2: Build and run your app

With Metro running, open a new terminal window/pane from the root of your React Native project, and use one of the following commands to build and run your Android or iOS app:

### Android

```sh
# Using npm
npm run android

# OR using Yarn
yarn android
```

### iOS

For iOS, remember to install CocoaPods dependencies (this only needs to be run on first clone or after updating native deps).

The first time you create a new project, run the Ruby bundler to install CocoaPods itself:

```sh
bundle install
```

Then, and every time you update your native dependencies, run:

```sh
bundle exec pod install
```

For more information, please visit [CocoaPods Getting Started guide](https://guides.cocoapods.org/using/getting-started.html).

```sh
# Using npm
npm run ios

# OR using Yarn
yarn ios
```

If everything is set up correctly, you should see your new app running in the Android Emulator, iOS Simulator, or your connected device.

This is one way to run your app — you can also build it directly from Android Studio or Xcode.

## Step 3: Modify your app

Now that you have successfully run the app, let's make changes!

Open `App.tsx` in your text editor of choice and make some changes. When you save, your app will automatically update and reflect these changes — this is powered by [Fast Refresh](https://reactnative.dev/docs/fast-refresh).

When you want to forcefully reload, for example to reset the state of your app, you can perform a full reload:

- **Android**: Press the <kbd>R</kbd> key twice or select **"Reload"** from the **Dev Menu**, accessed via <kbd>Ctrl</kbd> + <kbd>M</kbd> (Windows/Linux) or <kbd>Cmd ⌘</kbd> + <kbd>M</kbd> (macOS).
- **iOS**: Press <kbd>R</kbd> in iOS Simulator.

## Congratulations! :tada:

You've successfully run and modified your React Native App. :partying_face:

### Now what?

- If you want to add this new React Native code to an existing application, check out the [Integration guide](https://reactnative.dev/docs/integration-with-existing-apps).
- If you're curious to learn more about React Native, check out the [docs](https://reactnative.dev/docs/getting-started).

# Troubleshooting

If you're having issues getting the above steps to work, see the [Troubleshooting](https://reactnative.dev/docs/troubleshooting) page.

# Learn More

To learn more about React Native, take a look at the following resources:

- [React Native Website](https://reactnative.dev) - learn more about React Native.
- [Getting Started](https://reactnative.dev/docs/environment-setup) - an **overview** of React Native and how setup your environment.
- [Learn the Basics](https://reactnative.dev/docs/getting-started) - a **guided tour** of the React Native **basics**.
- [Blog](https://reactnative.dev/blog) - read the latest official React Native **Blog** posts.
- [`@facebook/react-native`](https://github.com/facebook/react-native) - the Open Source; GitHub **repository** for React Native.
