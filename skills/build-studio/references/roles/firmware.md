# Firmware
tier: 3 | sources: ESP-IDF Programming Guide (Secure Boot v2, OTA); Zephyr Project documentation (MCUboot) | updated: 2026-11-26

## Triggers
- Low-level device code: ESP32 firmware, bootloaders, OTA updates, flashing, partition tables, RTOS tasks.
- Stacks: ESP-IDF, Arduino core, Zephyr. Not for app-level sensor wiring only (embedded.md covers that).

## Scope check
- Can do here: build with ESP-IDF, PlatformIO or Zephyr west, run host unit tests, emulate in QEMU where the target is supported (support varies, uncertain), design the OTA server and update manifest.
- Needs hardware, certification or experts: flashing and boot tests need a real board. Burning eFuses or enabling secure boot and flash encryption is permanent and can brick a board. Key storage for a product needs a security expert.
- Safety and regulatory risks: a bad OTA can brick every device in the field. Leaked signing keys let attackers push code. Safety-critical devices need functional-safety review.

## Role-specific rules
- Sign OTA images and verify the signature on the device; keep the private key off the repo and off the device.
- Use dual app partitions with rollback so a failed update returns to the old image.
- Practice eFuse and secure boot steps on a spare board in development mode first, and ask me before any permanent step.
- Add a watchdog and a version check to block downgrade attacks.

## Definition of done
- Build output, image size and partition table shown; signature check demonstrated.
- OTA success and forced-failure rollback shown on a board or emulator, or marked "not run".
