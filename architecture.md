# MelodyMarket - Music Marketplace App Architecture

## App Overview
MelodyMarket is a beautiful mobile app that allows artists to upload and sell their music while enabling users to purchase, stream, and save albums for offline listening.

## Core Features (MVP)
1. **Artist Features**
   - Upload music tracks/albums with cover art
   - Set pricing for individual songs or full albums
   - Manage artist profile

2. **User Features**
   - Browse and discover music from artists
   - Purchase albums/songs
   - Stream purchased music
   - Save music for offline listening
   - Personal music library

3. **Shared Features**
   - User authentication (simple local profile system)
   - Music player with controls
   - Beautiful modern UI with dark/light theme support

## Technical Architecture

### Data Models
- **User**: id, name, email, isArtist, profileImage, purchasedAlbums[]
- **Artist**: extends User with additional fields like bio, socialLinks
- **Album**: id, title, artistId, price, coverImageUrl, tracks[], createdAt
- **Track**: id, title, duration, fileUrl (placeholder), albumId
- **Purchase**: id, userId, albumId, purchaseDate, price

### File Structure
```
lib/
├── main.dart
├── theme.dart
├── models/
│   ├── user.dart
│   ├── album.dart
│   ├── track.dart
│   └── purchase.dart
├── services/
│   ├── storage_service.dart
│   ├── audio_service.dart
│   └── user_service.dart
├── screens/
│   ├── home_screen.dart
│   ├── artist_upload_screen.dart
│   ├── album_detail_screen.dart
│   ├── library_screen.dart
│   ├── player_screen.dart
│   └── profile_screen.dart
└── widgets/
    ├── album_card.dart
    ├── music_player.dart
    ├── bottom_nav_bar.dart
    └── user_avatar.dart
```

## Implementation Steps

### Phase 1: Core Foundation
1. Update pubspec.yaml with required dependencies
2. Update theme.dart with music-appropriate colors
3. Create data models (User, Album, Track, Purchase)
4. Set up local storage service using SharedPreferences
5. Create sample data for testing

### Phase 2: Main Navigation & Screens
1. Create bottom navigation bar
2. Implement home screen with album discovery
3. Build album detail screen with purchase functionality
4. Create library screen for purchased music
5. Implement basic profile screen

### Phase 3: Artist Features
1. Create artist upload screen for adding albums
2. Implement image picker for album covers
3. Add file picker for music files (placeholder functionality)
4. Create artist profile management

### Phase 4: Music Player
1. Build music player widget with controls
2. Implement audio service using audioplayers
3. Add player screen with full controls
4. Integrate player throughout the app

### Phase 5: Polish & Testing
1. Add animations and transitions
2. Implement offline music storage
3. Add purchase flow with confirmation
4. Test and debug using compile_project tool

## Key Components

### Audio Service
- Manage audio playback using audioplayers package
- Handle play, pause, skip, seek operations
- Track current playing song and progress

### Storage Service
- Use SharedPreferences for user data and preferences
- Use path_provider for local file storage
- Manage purchased music files locally

### Sample Data
- Pre-populate with diverse music albums
- Include various genres and artists
- Use realistic pricing and metadata

## UI/UX Considerations
- Modern, gradient-based design with music theme
- Card-based layouts for albums and tracks
- Smooth animations for player controls
- Intuitive navigation between artist and user modes
- Beautiful album artwork display
- Responsive design for different screen sizes