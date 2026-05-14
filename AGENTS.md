# AGENTS.md

This file provides consolidated guidance for AI agents (Gemini CLI, Claude Code, etc.) working with the Canalside Radio codebase.

## Project Overview

Canalside Radio is a Flutter mobile app (Android + iOS) for streaming [The Canalside Radio](https://www.thecanalsideradio.com/). It is a specialized and simplified fork of [radiosai](https://github.com/immadisairaj/radiosai), adapted to a single radio stream with multistreaming and offline features disabled.

### Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** BLoC pattern using `Provider` + `RxDart` (BehaviorSubject)
- **Dependency Injection:** `GetIt` (Service Locator)
- **Audio Playback:** `just_audio` + `audio_service` (for background playback and lock screen controls)
- **OTA Updates:** [Shorebird](https://shorebird.dev)
- **Architecture:** BLoC architecture for business logic, with `AudioManager` as a facade for audio operations.

---

## Common Commands

```bash
# Get dependencies
flutter pub get

# Run the app on a connected device
flutter run

# Analyze code (linting)
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Build release APK (Android)
flutter build apk --release

# Build App Bundle (AAB)
flutter build appbundle --release

# Build release for iOS
flutter build ios

# OTA patch release (Shorebird - for code-only changes)
shorebird patch android
shorebird patch ios

# Full release via Shorebird
shorebird release android
shorebird release ios
```

---

## Architecture & State Management

### Dependency Injection (`lib/audio_service/service_locator.dart`)

`setupServiceLocator()` registers all singletons at app startup via `getIt`:
- `AudioHandler` – the `audio_service` background handler
- `AudioManager` – high-level facade over `AudioHandler` (notifiers, queue management)
- `InternetStatus` – connectivity stream
- `NavigationService` – global navigator key
- `ScaffoldHelper` – global scaffold key (for app-wide snackbars)

### State Management Flow
- **BLoC classes** (`lib/bloc/`) wrap `BehaviorSubject` streams and are provided via `Provider` in `main.dart`.
- **Screens** use `Consumer<XBloc>` + `StreamBuilder` to reactively rebuild.
- **Audio state** is exposed via `ValueNotifier`s on `AudioManager` and consumed with `ValueListenableBuilder`.

### Audio Layer (`lib/audio_service/`)
- `AudioHandler` – implements `BaseAudioHandler` from `audio_service`; handles background playback, lock screen controls, and notifications.
- `AudioManager` – facade used by UI; exposes notifiers (`playButtonNotifier`, `progressNotifier`, `loadingNotifier`, etc.) and delegates all commands to `AudioHandler`.
- Two media types: `MediaType.radio` (live stream) and `MediaType.media` (on-demand audio).

### BLoC Layer (`lib/bloc/`)

| BLoC Class              | Purpose                      | Persistence       | Active in Canalside                        |
| ----------------------- | ---------------------------- | ----------------- | ------------------------------------------ |
| `RadioIndexBloc`        | Current stream index         | SharedPreferences | ✅ `radio_home`, `radio_stream_select`     |
| `RadioLoadingBloc`      | Radio player loading state   | In-memory         | ✅ `radio_home`, `radio_player`            |
| `InitialRadioIndexBloc` | Startup stream preference    | SharedPreferences | ✅ `settings/starting_radio_stream`        |
| `AppThemeBloc`          | App theme                    | SharedPreferences | ✅ `main.dart`, `settings/app_theme`       |
| `MediaScreenBloc`       | Media screen refresh trigger | In-memory         | ⚠️ upstream only — `media.dart` (disabled) |
| `InternetStatus`        | Network connectivity         | ICCP stream       | ✅ app-wide                                |

### Notifier Layer (`lib/audio_service/notifiers/`)

| Notifier               | State type                                 | Active in Canalside                                                        |
| ---------------------- | ------------------------------------------ | -------------------------------------------------------------------------- |
| `PlayButtonNotifier`   | `PlayButtonState` (paused/playing)         | ✅ `radio_home`, `top_media_player`, `bottom_media_player`                 |
| `LoadingNotifier`      | `LoadingState` (loading/done)              | ✅ `radio_player`, `radio_home`                                            |
| `MediaTypeNotifier`    | `MediaType` (radio/media)                  | ✅ `radio_player`, `radio_home`, `top_media_player`, `bottom_media_player` |
| `RepeatButtonNotifier` | `RepeatState` (off/repeatQueue/repeatSong) | ⚠️ upstream only — `media_player.dart`                                     |
| `ProgressNotifier`     | `ProgressBarState`                         | ⚠️ upstream only — `media_player.dart`                                     |

---

## Development Conventions

### Coding Standards
- **Linter:** Follows `package:flutter_lints/flutter.yaml` with overrides:
  - `prefer_single_quotes: true`
  - `use_super_parameters: true`
- **File Naming:** Use `snake_case` for all dart files.
- **Strings:** Prefer single quotes for strings unless double quotes are necessary for interpolation or escaping.

### Radio Player State Model
```
Stop State → Play (user) → Play State
Stop State → Change Stream (user) → Changes Stream → Stop State
Play State → Change Stream (user) → Stop State → Changes Stream → Play State
Play State → Pause in app (user) → Stop State
Play State → Pause in notification (user) → Pause State
Play State → Stop in notification (user) → Stop State
```
**Stop** disconnects the stream entirely; **Pause** (notification only) suspends without disconnecting. Pressing Play always reconnects live.

### Signing & Security
- **Release Signing:** Requires `android/key.properties` (not committed) with `storePassword`, `keyPassword`, `keyAlias`, and `storeFile`.
- **HTTPS Only:** All audio streams and assets must use HTTPS. Cleartext traffic is disabled by default except for localhost.
- CI uses `CM_KEYSTORE_PATH` / `CM_KEYSTORE_PASSWORD` etc. from repository secrets.

---

## Key Files & Directories

- `lib/main.dart`: App entry point and Provider setup.
- `lib/audio_service/`: Core audio handling and service locator.
- `lib/bloc/`: Business logic components.
- `lib/constants/constants.dart`: Stream URLs and app-wide constants.
- `lib/screens/`: UI screens and navigation logic.
- `pubspec.yaml`: Dependency management and versioning (`<major>.<minor>.<patch>+<build>`).

---

## Known Limitations / Legacy

- **Single Stream:** Although the code supports multiple streams, the Canalside adaptation currently targets a single primary stream. Edit `radioStreamHttps` in `lib/constants/constants.dart` to update the URL.
- **Upstream Leftovers:** Screens like `audio_archive`, `media`, and `search` are present but largely disabled.
- **Pause vs Stop:** For radio streams, "Pause" in notifications acts as a pause, but the app UI generally implements a "Stop" (disconnect) behavior to ensure live playback on resume.
- **`audio_handler.dart`**: Contains a large commented-out block (~485 lines) of old `BackgroundAudioTask` code; do not modify it.
- **Dependency Overrides**: `pubspec.yaml` contains overrides for transitive dependency conflicts. Do not remove without verifying `flutter pub get`.
