# Game Engine Development
tier: 3 | sources: Vulkan Specification and Guide (Khronos); Game Programming Patterns (Nystrom, free online) | updated: 2026-11-26

## Triggers
- Writing a game engine itself: renderer, ECS, physics, asset pipeline, scene graph, custom shader work.
- Not for making a game inside Unity, Godot or Unreal (use frontend or the game tool directly).

## Scope check
- Can do here: all core parts on the PC with free tools: C++ or Rust, SDL, GLFW, OpenGL or Vulkan or wgpu, an ECS, simple physics, an asset loader, profiling. Unit test math and physics on the host.
- Needs hardware, certification or experts: testing on other GPUs, consoles or phones needs those devices. Console release needs vendor approval and kits. A production physics or renderer needs graphics experts and a large time budget.
- Safety and regulatory risks: flashing effects can trigger seizures in some players. Check asset and font licenses. Online features raise child-privacy and data rules (uncertain).

## Role-specific rules
- Scope tiny first: a window, a triangle, then a sprite and input before any engine features.
- Keep the simulation loop on a fixed time step and separate from rendering.
- Enable validation layers or debug output in development builds.
- Profile before optimizing, and record frame times.

## Definition of done
- Demo scene runs with frame time numbers and a screenshot shown.
- Math and physics tests pass; no validation-layer errors in the run log.
