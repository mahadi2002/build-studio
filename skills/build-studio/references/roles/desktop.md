# Desktop
tier: 1 | sources: Electron security checklist, Tauri 2 security docs, yetone native-feel-skill (listing) | updated: 2026-11-26
Sources were thin for this role (see research/notes-discovery.md); rules below 0.8 confidence are marked.

## Triggers
- A Windows, macOS or Linux app; a tray tool; an app that needs the file system, local hardware, or works fully offline.
- Not for: a website that could be a PWA (frontend role). At G2, compare against a PWA first.

## Responsibilities
- Stack choice input at G2: PWA vs Tauri vs Electron vs native, with signing costs.
- Build: windows, menus, file access, local data, IPC between UI and the native side.
- Release: code signing, installers, auto-update, crash reporting.
- Verify on every OS shipped, from the installer, not from the dev command.

## Role-specific rules
1. **The UI is untrusted.** Treat the web layer like a browser tab that may run injected script. Every call from the UI to the native side validates its arguments and checks it is allowed.
2. **Smallest native surface:** expose a few named commands (`saveNote(id, text)`), never a generic "run this" or "read any path" bridge.
3. **No remote content with native access.** Load only local, bundled UI. If a window must show remote pages, it gets no IPC access and a strict CSP.
4. **CSP on every window,** no inline scripts, no `eval`.
5. **File access is scoped:** only the app data folder and files the user picked in a dialog; normalize paths and reject `..` traversal.
6. **App data goes in the OS app-data folder,** not next to the executable (Program Files is read-only for users).
7. **Signed updates only:** auto-update must verify a signature before installing; the signing key stays offline and backed up.
8. **Code signing costs money (G3):** a Windows code signing certificate and the Apple Developer program for notarization. Unsigned builds trigger SmartScreen and Gatekeeper warnings; state this at G2.
9. **Keep the runtime current:** Electron bundles Chromium; plan a monthly update to pick up security fixes.
10. **Local database migrations** run at startup with a backup of the old file first.
11. **Crash reporting** with symbols uploaded per release; no personal data in reports.
12. **Native feel:** OS-standard shortcuts (Ctrl/Cmd), menus, window controls, light/dark from the OS, keyboard navigation (uncertain: details per OS in the native-feel source, not yet read).

## Default tool options
- Tauri 2: small binaries, Rust backend, permission model per window. Pick when the app is light and I accept some Rust.
- Electron: biggest ecosystem, Node in the main process, large binaries. Pick when a Node library is essential.
- Native: WinUI/.NET for Windows-only, SwiftUI for macOS-only.
- PWA: when the browser's file and offline APIs are enough.
- Builds: GitHub Actions matrix (windows, macos, ubuntu runners); electron-builder or Electron Forge; `tauri-action` for Tauri.
- Crash reporting: Sentry free tier.

## Checklist
- [ ] PWA option considered at G2; signing costs listed
- [ ] IPC commands listed with their argument validation
- [ ] CSP set on every window; no remote content in windows with IPC
- [ ] File access limited to app data and user-picked files
- [ ] Installer tested on each target OS (clean VM or second machine)
- [ ] Auto-update verified end to end with a signed test release
- [ ] Crash report received from a release build

## Common mistakes
- Exposing `fs` or a shell command to the UI "for convenience" → one XSS becomes full machine access.
- Loading the production website inside the app with native access → any compromise of the site owns the desktop.
- Storing data in the install folder → permission errors and data loss on update.
- Testing only `npm run dev` → the packaged app differs (paths, signing, permissions).
- Shipping unsigned updates → anyone on the network path could push code.

## Definition of done
Signed (or explicitly unsigned with my approval) installers for each target OS install and run the main flow on a clean machine; an update from the previous version works; IPC validation tests pass; crash reporting works from a release build.

## Per-stack notes
**Electron:** keep `contextIsolation: true`, `nodeIntegration: false` and `sandbox: true` (current defaults); expose a minimal API through `contextBridge` in the preload; check `event.senderFrame` in IPC handlers; deny new windows with `setWindowOpenHandler` and block unexpected `will-navigate`; turn off risky fuses such as RunAsNode (uncertain: check current fuse names).
**Tauri 2:** define capabilities per window and grant only the plugins and commands that window needs; validate inputs in Rust commands; scope the fs plugin to app directories; the updater requires a signing key pair (keep the private key out of the repo).
**WinUI/.NET:** MSIX packaging for clean installs and updates; store settings in `ApplicationData`.
**SwiftUI (macOS):** App Sandbox entitlements as narrow as possible; notarize every release.
