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
- `radio/radio_stream_select.dart` – stream selector (single stream only)
- `media_player/media_player.dart` – full-screen media player for on-demand audio
- `settings/` – app theme and starting stream preferences
- `audio_archive/`, `media/`, `radio_schedule/`, `search/` – upstream fork screens, largely disabled for Canalside

### Widget Layer (`lib/widgets/`)

- `TopMediaPlayer` – floating overlay showing current media when media (not radio) is active
- `TopMenu` – menu bar with Settings button
- `BottomMediaPlayer` – bottom player bar shown on archive/media screens
- `InternetAlert` – animated connectivity status bar
- `no_data.dart` – empty-state placeholder
- `radio/slider_handle.dart` – visual handle for the sliding stream selector panel
- `settings/settings_section.dart` – reusable settings section container

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

### Configuration (`lib/constants/constants.dart`)

`MyConstants` is an `InheritedWidget` containing all hardcoded configuration:

- `radioStreamHttps` – map of stream names to CDN URLs (single entry: "The Canalside Radio")
- `radioStreamImages` – art images for streams
- `scheduleStream`, `audioArchive`, `audioArchiveFids` – leftover from the upstream fork, unused in the Canalside adaptation
- `appThemes` – list ordering must not change (index-based)

### Helpers (`lib/helper/`)

- `MediaHelper` – file/URI conversions, media directory paths, media item generation
- `NavigationService` – global navigator key; `navigateTo()`, `popUntil()`, `popToBase()`
- `ScaffoldHelper` – global scaffold key for app-wide snackbars
- `DownloadHelper` – download task management (disabled)

## Radio Player State Model

```
Stop State → Play (user) → Play State
Stop State → Change Stream (user) → Changes Stream → Stop State
Play State → Change Stream (user) → Stop State → Changes Stream → Play State
Play State → Pause in app (user) → Stop State
Play State → Pause in notification (user) → Pause State
Play State → Stop in notification (user) → Stop State
```

Pause and Stop are distinct states: **Stop** disconnects the stream entirely; **Pause** (notification only) suspends without disconnecting. Pressing Play always reconnects live — there is no resume-from-pause for the radio stream.

## Updating the Stream URL

Edit `radioStreamHttps` in `lib/constants/constants.dart`. The key is the display name; the value must be an HTTPS URL. Only one entry is active — do not add test streams.

## Android Release Signing (Local)

Create `android/key.properties` (not committed):

```properties
storePassword=<password>
keyPassword=<password>
keyAlias=<alias>
storeFile=<absolute path to .jks>
```

CI uses `CM_KEYSTORE_PATH` / `CM_KEYSTORE_PASSWORD` / `CM_KEY_ALIAS` / `CM_KEY_PASSWORD` environment variables set from repository secrets. If none are present, debug signing is used as a fallback.

## CI/CD

- **Build workflow** (`.github/workflows/build.yml`): runs `flutter analyze` + `flutter test` + Android APK build on every push/PR to `main`.
- **Publish workflow** (`.github/workflows/publish.yml`): triggered by a GitHub Release publication (or manually via `workflow_dispatch`). Runs `shorebird release android` and `shorebird release ios`. iOS publish requires macOS runner and Apple certificate/provisioning profile secrets.
- iOS builds can only be compiled on macOS — there is no local iOS build path on other platforms.

## Versioning

Format: `<major>.<feature>.<fixes>+<commits>` (e.g. `1.4.9+220` in `pubspec.yaml`).

## OTA Updates

The app uses [Shorebird](https://shorebird.dev) for over-the-air code patches (configured in `shorebird.yaml`). Use `shorebird patch` for Dart-only changes; use `shorebird release` for native changes or new store submissions.

## Lint Rules

- `prefer_single_quotes: true`
- `use_super_parameters: true`
- Based on `package:flutter_lints/flutter.yaml`

## Key Patterns

### BLoC stream pattern

```dart
class XBloc {
  final _stream = BehaviorSubject<T>.seeded(initial);
  Stream<T> get xxxStream => _stream.stream;
  StreamSink<T> get changeXxx => _stream.sink;
  void dispose() { _stream.close(); }
}
// Consumed: Consumer<XBloc> + StreamBuilder<T>
```

### Notifier pattern

```dart
class XNotifier extends ValueNotifier<XState> {
  XNotifier() : super(XState.initial);
}
// Consumed: ValueListenableBuilder<XState>
```

### Service locator

```dart
// Register (service_locator.dart)
getIt.registerSingleton<AudioHandler>(await initAudioService());
// Use anywhere
final audioManager = getIt<AudioManager>();
```

## Dependency Overrides

`pubspec.yaml` contains a `dependency_overrides` block that pins several transitive dependencies (`http`, `characters`, `material_color_utilities`, `meta`, `matcher`, `test_api`, `objective_c`) to resolve version conflicts between packages. Do not remove these without verifying that all transitive version constraints still resolve cleanly (`flutter pub get`).

## Disabled / Leftover Features

- **Flutter Downloader** – imported but fully commented out; do not re-enable without implementing the full feature
- **Multi-stream** – code supports a map of streams but only one stream is active; do not add test streams to `radioStreamHttps`
- **Audio archive / schedule / search** – screens exist from the upstream fork but are not wired to Canalside content; `scheduleStream` and `audioArchiveFids` entries in `constants.dart` are legacy
- **`audio_handler.dart`** – contains a large `/* START OF COMMENT … END OF COMMENT */` block (~485 lines) of old `BackgroundAudioTask` code; do not modify it
- **`audio_service` package** – when upgrading this package, check for breaking changes in `.MainActivity` (noted in `pubspec.yaml`); the Android entry point class may need updating

## Security Notes

All stream and media URIs must be HTTPS. The network security config (`android/app/src/main/res/xml/network_security_config.xml`) only permits cleartext to `127.0.0.1` (localhost). The audio handler enforces HTTPS for schemeless URIs and ICY art URLs. Do not add `android:usesCleartextTraffic` or `android:requestLegacyExternalStorage` back to `AndroidManifest.xml`.
