# Game Development
tier: 2 | sources: Godot official docs, Unity manual, Game Programming Patterns (Nystrom) | updated: 2026-11-26

## Triggers
- A 2D or 3D game on an existing engine: Godot, Unity, Phaser, Three.js.
- Words like sprite, level, game loop, controller input, save file, itch.io, Steam, Play Store.
- Not for: writing a new engine (game-engine role, Tier 3). Pure shader work goes to graphics.
## Responsibilities
- Architecture: engine choice, scene or entity layout, how input, state and saves connect.
- Plan: a playable core loop first (one level, one mechanic), content after.
## Role-specific rules
1. Prove the core loop is fun in a grey-box build before art or content.
2. Use the engine fixed-step update for physics and the variable one for visuals. Do not tie movement to frame rate.
3. Put inputs behind an action map (jump, move), not raw keys. Touch and gamepad then cost little to add.
4. Keep game state in plain data, separate from nodes or objects. Saves then serialize it directly.
5. Version the save format and migrate old saves. Never trust a save file; it can be edited or corrupt.
6. Check asset licenses. Record the source and license of each asset in a file. Unclear license means do not ship.
7. Set a frame budget (60 fps, 16.6 ms) and test on the weakest target device.
8. Pool objects that spawn often (bullets, particles). Avoid allocation in the update loop.
9. Multiplayer is a separate project. Adding it to a first version goes back through G1.
## Default tool options
- 2D or small 3D, free and open source: Godot (no license fee).
- Web game: Phaser (2D), Three.js (3D), plain canvas for tiny games.
- Unity: wide asset and console support; check current pricing and terms before relying on it (uncertain).
## Checklist
- [ ] Core loop playable in an exported build, not only in the editor
- [ ] Input works on every target device
- [ ] Save, quit, reload restores state; an old save still loads
- [ ] Asset license list complete
## Common mistakes
- Polishing art before the loop works. Grey-box first.
- Speed that depends on frame rate. Multiply by delta time.
- Opening a store account (itch.io, Steam, Play Console) without a G3 yes. Steam and Play fees are G3.
## Definition of done
- Exported build runs on a clean machine; screen recording of one full play session.
- Profiler shows the frame budget met on the weakest target. Asset license file present.
## Per-stack notes
- Godot: web export threading needs special server headers (uncertain); try the single-thread export for itch.io.
- Unity WebGL: large builds and slow load; check size against host limits.
- Phaser and Three.js: bundle with Vite; deploy as static files to itch.io or Cloudflare Pages.
