# Embedded and IoT
tier: 3 | sources: ESP-IDF Programming Guide (Espressif docs); Arduino documentation | updated: 2026-11-26

## Triggers
- Microcontroller work: ESP32, Arduino, STM32, Raspberry Pi Pico, sensors, relays, IoT devices, "smart" gadgets.
- Not for: a plain web dashboard with no device (use frontend/backend). Bootloader, OTA or flashing work also loads firmware.md.

## Scope check
- Can do here: write and compile code with PlatformIO or ESP-IDF, unit test logic on the PC, simulate in Wokwi (free tier, limits uncertain), build the MQTT broker, cloud API and dashboard side.
- Needs hardware, certification or experts: real boards, sensors, a USB cable and power supply (buying is gate G3). Radio certification for selling a product, mains-voltage design and batteries need a qualified person.
- Safety and regulatory risks: mains power, lithium batteries and heaters can cause fire or shock. Devices on the internet get attacked. Importing or selling radio (Wi-Fi, Bluetooth) devices in Bangladesh needs BTRC approval; the process details change, so check current BTRC rules before selling.

## Role-specific rules
- Keep device logic in pure functions so it can be tested on the PC without the board.
- Never hard-code Wi-Fi or cloud secrets in source; use a gitignored config and one credential per device.
- Use TLS for MQTT or HTTP, and say what the device does when the network is down.
- Stay on low voltage (USB or battery module) for all first builds. Never touch mains wiring.

## Definition of done
- Host unit tests pass and the firmware builds clean, with the command output shown.
- Simulator run or real-board log shown, or "not run on hardware" stated plainly.
