# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Canalside Radio is a Flutter mobile app (Android + iOS) for streaming [The Canalside Radio](https://www.thecanalsideradio.com/). It is a simplified fork of [radiosai by immadisairaj](https://github.com/immadisairaj/radiosai), adapted to a single radio stream with multistreaming and offline features disabled.

## Common Commands

```bash
# Run the app on a connected device
flutter run

# Build release APK (Android)
flutter build apk

# Build release for iOS
flutter build ios

# Analyze code (linting)
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Get dependencies
flutter pub get

# OTA patch release (Shorebird - for code-only changes)
shorebird patch android
shorebird patch ios

# Full release via Shorebird
shorebird release android
shorebird release ios
```

## Architecture

The app uses **BLoC pattern with Provider + RxDart streams** for reactive state management, and **GetIt** for dependency injection (service locator).

### Dependency Injection (`lib/audio_service/service_locator.dart`)

`setupServiceLocator()` registers all singletons at app startup via `getIt`:

- `AudioHandler` – the `audio_service` background handler
- `AudioManager` – high-level facade over `AudioHandler` (notifiers, queue management)
- `InternetStatus` – connectivity stream
- `NavigationService` – global navigator key
- `ScaffoldHelper` – global scaffold key (for app-wide snackbars)

### State Management Flow

- **BLoC classes** (`lib/bloc/`) wrap `BehaviorSubject` streams and are provided via `Provider` in `main.dart`
- **Screens** use `Consumer<XBloc>` + `StreamBuilder` to reactively rebuild
- **Audio state** is exposed via `ValueNotifier`s on `AudioManager` and consumed with `ValueListenableBuilder`

### Audio Layer (`lib/audio_service/`)

- `AudioHandler` – implements `BaseAudioHandler` from `audio_service`; handles background playback, lock screen controls, notifications
- `AudioManager` – facade used by UI; exposes notifiers (`playButtonNotifier`, `progressNotifier`, `loadingNotifier`, etc.) and delegates all commands to `AudioHandler`
- Two media types: `MediaType.radio` (live stream) and `MediaType.media` (on-demand audio)

### Screen Structure (`lib/screens/`)

- `home.dart` – root scaffold; stacks `RadioHome`, `TopMenu`, `TopMediaPlayer`
- `radio/radio_home.dart` – main screen; handles app links and audio manager initialization
- `radio/radio_player.dart` – the play/pause UI and sliding panel
- `radio/radio_stream_select.dart` – stream selector (currently only one stream)
- `media_player/media_player.dart` – full-screen media player for on-demand audio
- `settings/` – app theme and starting stream preferences

### Configuration (`lib/constants/constants.dart`)

`MyConstants` is an `InheritedWidget` containing all hardcoded configuration:

- `radioStreamHttps` – map of stream names to CDN URLs (currently only "The Canalside Radio")
- `radioStreamImages` – art images for streams
- `scheduleStream`, `audioArchive`, `audioArchiveFids` – leftover from the upstream fork, mostly unused in the Canalside adaptation
- `appThemes` – list ordering must not change (index-based)

### Versioning

Format: `<major>.<feature>.<fixes>+<commits>` (e.g. `1.4.9+220` in `pubspec.yaml`).

### OTA Updates

The app uses [Shorebird](https://shorebird.dev) for over-the-air code patches (configured in `shorebird.yaml`). Use `shorebird patch` for Dart-only changes; use `shorebird release` for native changes or new store submissions.

## Lint Rules

- `prefer_single_quotes: true`
- `use_super_parameters: true`
- Based on `package:flutter_lints/flutter.yaml`
