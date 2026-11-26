# AR and VR
tier: 2 | sources: W3C WebXR Device API, Meta Quest developer design guidelines, Google ARCore and Apple ARKit docs | updated: 2026-11-26

## Triggers
- Headset or phone-based XR: WebXR, Unity XR, ARCore, ARKit, Quest apps.
- Words like immersive, hand tracking, passthrough, anchors, 6DoF, comfort.
- Not for: a flat 3D viewer in a page (graphics role). Simple model viewers need no XR.
## Responsibilities
- Architecture: platform (web, standalone headset, phone AR), input model, tracking needs.
- Plan: which real devices are available, and what an emulator cannot prove.
## Role-specific rules
1. Hold the target frame rate (often 72 or 90 fps on headsets; check the device spec). A dropped frame is a comfort bug.
2. Do not move the camera apart from head motion, except short user-started moves (teleport, fade, vignette).
3. Avoid artificial rotation and acceleration. Default to snap turn and teleport; offer smooth options in settings.
4. Place UI at a readable distance (about 1 to 2 m, uncertain) and never lock it hard to the head.
5. Use real units (meters) so object scale feels right.
6. Offer seated and standing modes and a way to recenter.
7. Provide a non-XR fallback (flat 3D view) so the work can be tested and shared.
8. Ask for camera, hand or room-scan permissions only when needed and say why. Do not store camera frames or room data; real user data is G3.
9. Test on a real device at each milestone. Emulators do not show comfort, tracking loss or heat limits.
## Default tool options
- Web: WebXR with Three.js or A-Frame, or Babylon.js XR. Free; runs in a Quest browser or Android Chrome.
- Engine: Godot XR (open source), Unity XR Interaction Toolkit.
- Phone AR: ARCore (Android); ARKit (iOS, needs a Mac and a developer account, paid program is G3).
## Checklist
- [ ] Frame rate measured on the device
- [ ] Locomotion has a comfort option and a no-motion fallback
- [ ] Tested seated and standing
- [ ] Non-XR fallback works
## Common mistakes
- Testing only in an emulator. Wear the headset for 10 minutes.
- Smooth stick locomotion as the only option.
- Tiny text far from the user. Size UI by visual angle.
## Definition of done
- A device test log: device, frame rate, session length, any discomfort noted.
- A short video capture from the headset. The fallback demo link works.
## Per-stack notes
- WebXR: needs HTTPS; sessions start from a user click; check `navigator.xr.isSessionSupported`.
- Unity: OpenXR plugin, Android build for Quest; sideloading needs developer mode.
