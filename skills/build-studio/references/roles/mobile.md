# Mobile
tier: 1 | sources: vercel-labs react-native-skills, expo/skills (listing), OWASP MASVS, store policies | updated: 2026-11-26

## Triggers
- An iOS or Android app, a "make it an app", push notifications, offline use, camera or location on a phone.
- Not for: a responsive website (frontend role). At G2, always compare against a PWA first.

## Responsibilities
- Stack choice input at G2: PWA vs cross-platform (Flutter, React Native/Expo) vs native, with store costs and review time.
- Build: screens, navigation, local storage, offline sync, push, permissions.
- Verify: on at least one real Android device and one emulator/simulator per platform shipped.
- Release: signing, store listing, privacy forms, staged rollout.

## Role-specific rules
1. **PWA first question.** If the app needs no background work, no store presence and no device APIs a browser lacks, propose a PWA at G2: no store fees, one codebase, instant updates.
2. **Store accounts cost money (G3):** Google Play has a one-time fee and Apple a yearly fee. Name both at G2 with current prices (check online). iOS builds need a Mac or a cloud build service.
3. **Play testing rule:** personal Play developer accounts created after 13 Nov 2023 must keep at least 12 testers opted in to a closed test for the 14 days before applying for production (Google Play Console help, checked 2026-11). Plan the launch date around it.
4. **No secrets in the app.** Anything in the binary can be extracted. API keys for paid services stay on a backend; the app gets short-lived tokens.
5. **Secure storage:** tokens in Keychain/Keystore (via the stack's secure storage library), never in plain preferences or AsyncStorage.
6. **Network:** HTTPS only, normal certificate validation (no "trust all" in release builds); pinning only with a rotation plan.
7. **Deep links and intents are input:** validate every parameter; never open arbitrary URLs in a WebView with a JS bridge.
8. **Permissions:** ask at the moment of use with a reason screen; the app still works (degraded) when denied.
9. **Offline by design:** decide at G2 what works offline. Local database, a sync queue with retry, and a conflict rule (last write wins, server wins, or merge) written in the ADR.
10. **Account deletion in the app** if users can create accounts (both stores require it); plus the store privacy forms (Play Data safety, Apple privacy details) filled from the real data flows.
11. **Updates:** support at least one older app version against the API (mobile users update late); add a minimum-version check that can force an update.
12. **Performance:** virtualized lists, memoized list items, images sized for the screen, animations on transform and opacity only, cold start measured on a mid-range Android phone.
13. **Signing keys are irreplaceable:** back up the upload keystore and passwords outside the repo; use Play App Signing.
14. **Staged rollout** (for example 10% → 50% → 100%) with crash-free rate checked at each step.

## Default tool options
- Cross-platform: Flutter (one UI toolkit, strong performance); React Native with Expo (reuses React skills; EAS Build/Update, free tier limited, uncertain on current quota).
- Native: Kotlin + Jetpack Compose; Swift + SwiftUI. Choose only when a platform API or performance need demands it.
- Backend for mobile: Supabase, Firebase (Auth, FCM push), or my own API.
- Push: Firebase Cloud Messaging (Android and iOS via APNs).
- Crash reporting: Firebase Crashlytics or Sentry free tier.

## Checklist
- [ ] PWA option considered and recorded at G2
- [ ] Store fees and testing rules in the G2 cost section
- [ ] No API keys for paid services in the app bundle (grep the build output)
- [ ] Tokens in secure storage
- [ ] App works with permissions denied and with no network
- [ ] Tested on a real Android device; release build, not debug
- [ ] Account deletion flow and privacy forms done
- [ ] Keystore backed up; release signed with Play App Signing

## Common mistakes
- Shipping a debug build or with dev endpoints → check the build config and the API base URL before upload.
- Putting a provider API key in the app "temporarily" → it gets extracted; proxy through a backend.
- Asking all permissions at launch → users deny; ask when needed.
- Forgetting old app versions → an API change breaks users who haven't updated.
- Losing the upload key → recovery is slow and manual.
- Testing only on an emulator → real-device performance and permissions differ.

## Definition of done
A signed release build installed on a real device passes the main flow online and offline; crash reporting receives a test event; store listing, privacy forms and account deletion are complete; the release plan states rollout stages and the rollback (halt rollout, server-side flag).

## Per-stack notes
**Flutter:** Riverpod or Bloc for state, chosen once; `flutter_secure_storage` for tokens; `drift` or `sqflite` for local data; `integration_test` for device tests and golden tests for key screens; release with `--obfuscate --split-debug-info` and keep the symbols for crash reports (uncertain: check current flags).
**React Native / Expo:** FlashList for long lists, memoized items, stable callbacks, no inline style objects; Reanimated for animation; native stack and tabs; `expo-image`; `expo-secure-store` for tokens; EAS Update only for JS/asset changes, never to bypass store review of native changes.
**Kotlin/Android:** Jetpack Compose, ViewModel + Flow, Room for local data, EncryptedSharedPreferences or Keystore-backed storage (check current Jetpack security guidance), WorkManager for background sync.
**Swift/iOS:** SwiftUI, Keychain for tokens, SwiftData or Core Data, BackgroundTasks for sync; privacy manifest required for some APIs.
**PWA:** service worker for offline, Web App Manifest, push via the Push API (iOS supports it only for installed PWAs).
