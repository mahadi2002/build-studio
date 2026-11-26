# Graphics
tier: 2 | sources: MDN WebGL docs and WebGL2 spec, W3C WebGPU and WGSL specs, Three.js docs | updated: 2026-11-26

## Triggers
- Custom rendering: WebGL, WebGPU, shaders, canvas drawing, Three.js scenes, particle or data visuals.
- Words like draw call, texture, frame rate, GPU, lighting, post-processing.
- Not for: ordinary page animation in CSS (frontend role). Not for full game logic (game-dev role).
## Responsibilities
- Architecture: renderer choice, scene data layout, asset loading, a fallback when GPU support is missing.
- Plan: the frame budget and the weakest target device, stated up front.
## Role-specific rules
1. Take the simplest path: CSS, then 2D canvas, then Three.js, then raw WebGL or WebGPU. Move down only with a reason.
2. Set a frame budget (16.6 ms at 60 fps). Measure on the weakest target, not the dev laptop.
3. Cut draw calls first: batch, instance, share materials and geometry.
4. Keep textures small and compressed (KTX2 or Basis where supported).
5. Do not create objects or buffers inside the render loop. Allocate once, reuse.
6. Shaders: avoid heavy branching and loops per pixel, check precision on mobile, test on a low-end GPU.
7. Handle context loss and resize. Cap device pixel ratio (for example at 2) to protect fill rate.
8. Detect support at startup and give a plain fallback (static image or 2D). WebGPU support varies by browser (uncertain; check caniuse).
9. Pause the loop when the tab is hidden. Respect `prefers-reduced-motion` for large motion.
10. Dispose of geometries, materials and textures you stop using.
## Default tool options
- Scenes: Three.js; Babylon.js for a fuller engine; PlayCanvas editor for a hosted workflow.
- Raw: WebGL2 (widest support); WebGPU when targets allow.
- Profiling: browser Performance panel, Spector.js, `renderer.info` in Three.js.
## Checklist
- [ ] Frame time measured on the weakest device
- [ ] Draw call and triangle counts recorded
- [ ] Fallback tested with WebGL disabled
## Common mistakes
- Judging speed on a strong GPU. Test a phone.
- One draw call per object. Instance repeated meshes.
- Huge textures for small objects. Resize at build time.
- Memory leaks from never disposing. Watch GPU memory over 5 minutes.
## Definition of done
- A table of frame time, draw calls and memory on the target device, plus a screenshot.
- Fallback path shown working. No renderer warnings in the console.
## Per-stack notes
- Three.js: `InstancedMesh`, `mergeGeometries`, `renderer.setPixelRatio(Math.min(devicePixelRatio, 2))`.
- WebGPU: shaders are WGSL; check `navigator.gpu` before use.
