# Automotive Software
tier: 3 | sources: ISO 26262 (road vehicle functional safety); ISO 15765 and SAE J1979 (OBD-II diagnostics) | updated: 2026-11-26

## Triggers
- Vehicle software, CAN or CAN FD bus, OBD-II readers, ECU diagnostics, telematics, AUTOSAR, EV charging software.
- Not for a fleet web dashboard that only reads stored data.

## Scope check
- Can do here: parse CAN logs, simulate a bus with virtual CAN (SocketCAN in Linux or WSL2, python-can), decode with DBC files, build a telematics backend and dashboard, unit test diagnostic logic.
- Needs hardware, certification or experts: a CAN adapter or ELM327 reader and a real car (buying is gate G3). Safety-relevant functions need ISO 26262 process, safety engineers and type approval.
- Safety and regulatory risks: writing to the bus can disable brakes, airbags or steering. Tampering with emissions or odometer data is illegal. Remote vehicle access is a serious security risk.

## Role-specific rules
- Read-only OBD-II and CAN access by default; never send write, actuator or reflash commands to a real vehicle.
- Never test on a moving vehicle or a public road. Use a parked car with the engine off, or a bench ECU.
- Never claim ISO 26262 compliance; say the work is a learning prototype only.

## Definition of done
- Logs decode correctly on virtual CAN, with tests passing and output shown.
- Report states "no safety claim" and what was never tested on a real vehicle.
