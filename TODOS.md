# iOS Build Setup TODOs

Goal: get `shorebird release ios` working in CI via GitHub Actions.

## 1. Pull latest and fix gradlew

```bash
cd /Users/user947169/git/CanalsideRadio
git pull
chmod +x android/gradlew
```

## 2. Register app with Shorebird

```bash
shorebird init --force
```

This will create a new app under your Shorebird account and update `shorebird.yaml` with a new `app_id`. Commit and push the updated `shorebird.yaml`:

```bash
git add shorebird.yaml
git commit -m "Update shorebird app_id"
git push
```

## 3. Get the SHOREBIRD_TOKEN for CI

```bash
shorebird login:ci
```

Copy the printed `sb_api_...` token — this becomes the `SHOREBIRD_TOKEN` GitHub secret.

## 4. Export the P12 certificate

The private key is in `~/Library/Keychains/mykeys.keychain`. Export it as a P12:

```bash
security unlock-keychain -p <keychain-password> ~/Library/Keychains/mykeys.keychain

security export \
  -k ~/Library/Keychains/mykeys.keychain \
  -t identities \
  -f pkcs12 \
  -P MyP12Password \
  -o ~/CanalsideRadio_distribution.p12
```

Choose any password for `-P` — you'll need it for the `IOS_P12_PASSWORD` secret.

## 5. Base64-encode the secrets

```bash
# P12 certificate
base64 -i ~/CanalsideRadio_distribution.p12 | pbcopy
# → paste as IOS_P12_CERTIFICATE_BASE64

# Provisioning profile (copy from the MacInCloud folder or use the one on the Mac)
base64 -i ~/CanalsideRadio_AppStore.mobileprovision | pbcopy
# → paste as IOS_PROVISIONING_PROFILE_BASE64
```

## 6. Set GitHub secrets

Go to: <https://github.com/jimmckeeth/CanalsideRadio/settings/secrets/actions>

Add these secrets:

| Secret                            | Value                          |
| --------------------------------- | ------------------------------ |
| `SHOREBIRD_TOKEN`                 | output of `shorebird login:ci` |
| `IOS_P12_CERTIFICATE_BASE64`      | base64 of the .p12 file        |
| `IOS_P12_PASSWORD`                | password chosen in step 4      |
| `IOS_PROVISIONING_PROFILE_BASE64` | base64 of the .mobileprovision |

Android secrets (if not already set):

| Secret                 | Value                       |
| ---------------------- | --------------------------- |
| `KEYSTORE_BASE64`      | base64 of the .jks keystore |
| `CM_KEYSTORE_PASSWORD` | keystore password           |
| `CM_KEY_ALIAS`         | key alias                   |
| `CM_KEY_PASSWORD`      | key password                |

## 7. Trigger a release

Create a GitHub Release at <https://github.com/jimmckeeth/CanalsideRadio/releases/new> — this triggers the publish workflow which runs `shorebird release android` and `shorebird release ios`.

Or trigger manually via Actions → Publish → Run workflow.

# Spring Cleaning & Quality Debt

Goal: Remove technical debt, purge dead code, and optimize assets.

## 1. Purge Dead Code
- [ ] Remove ~485 lines of commented-out legacy `BackgroundAudioTask` code from `lib/audio_service/audio_handler.dart`.
- [ ] Remove unused `AudioArchive`, `Media`, and `Search` screens and their associated logic if they won't be reused.
- [ ] Clean up `lib/screens/radio/radio_home.dart` to remove commented-out `FlutterDownloader` code.

## 2. Optimize Assets
- [ ] Relocate source files (`assets/*.xcf`) to a non-tracked folder or external storage.
- [ ] Optimize or relocate high-resolution store assets (e.g., `assets/canalside1024.png`) if not needed at runtime.

## 3. Clean up State Management
- [ ] Remove unused `MediaScreenBloc` and its provider/consumer references.
- [ ] Audit and remove unused notifiers (e.g., `RepeatButtonNotifier`, `ProgressNotifier`) if on-demand media features remain disabled.

## 4. Refactor Configuration
- [ ] Clean up `lib/constants/constants.dart` to remove legacy upstream stream IDs (Prasanthi, etc.) and unused `audioArchiveFids`.
- [ ] Resolve `dependency_overrides` in `pubspec.yaml` by upgrading packages to compatible versions.
