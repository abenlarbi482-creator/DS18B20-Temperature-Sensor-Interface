# DS18B20 Temperature Sensor Interface (FPGA / VHDL)

A synchronous VHDL implementation of a **1-Wire master** for interfacing an FPGA with a **Maxim/Dallas DS18B20** digital temperature sensor.

## Overview

The design is entirely clocked from a single 100 MHz clock (`clk100`). It handles the full 1-Wire transaction needed to read a temperature from the sensor:

1. **Reset & presence detection** — send the 1-Wire reset pulse and check the sensor responds.
2. **Command write** — write an 8-bit command byte (e.g. Convert T / Read Scratchpad) to the sensor.
3. **Data read** — read back the 9-bit temperature conversion result.

The bus is shared and open-drain, so all three phases arbitrate for a single tri-stated `onewire_out` pin.

## Top-level ports

| Port | Direction | Width | Description |
|---|---|---|---|
| `clk100` | in | 1 | 100 MHz system clock |
| `reset` | in | 1 | Asynchronous system reset |
| `start` | in | 1 | Starts a full INIT → WRITE → READ transaction |
| `onewire_in` | in | 1 | 1-Wire bus, input side |
| `onewire_out` | out | 1 | 1-Wire bus, tri-stated output/drive side |
| `debug_in` | in | 8 | Debug input bus (resynchronized internally) |
| `value` | out | 9 | Temperature value read back from the sensor |

## Architecture

```
                         ┌───────────────┐
                clk100 ─►│   Reset_gen   │─► Reset_sync_clk100
                reset  ─►│               │
                         └───────────────┘
                                 │
                                 ▼
                         ┌───────────────┐
                clk100 ─►│   Time_gen    │─► clken_1us / clken_10us / clken_1ms
                         └───────────────┘
                                 │
                                 ▼
                         ┌───────────────┐
     onewire_in / debug ►│   Resynchro   │─► onewire_in_clk100 / debug_in_clk100
                         └───────────────┘
                                 │
                                 ▼
   ┌─────────────────────────────────────────────────────────┐
   │                     Master_protocol (FSM)                │
   │   start ──► start_INIT ──► start_Write ──► start_Read     │
   └─────────────────────────────────────────────────────────┘
        │                  │                  │
        ▼                  ▼                  ▼
   ┌─────────┐        ┌──────────┐        ┌────────┐
   │  INIT   │        │ Write8b  │        │  Read  │
   └─────────┘        └──────────┘        └────────┘
        │                  │                  │
        └────────► wire_out (arbitration) ◄───┘
                         │
                         ▼
                 Tristate_buffer ─► onewire_out
```

## Module summary

- **Reset_gen** — synchronizes the external asynchronous reset onto `clk100`.
- **Time_gen** — generates 1 µs / 10 µs / 1 ms clock enables from `clk100`, used to time the 1-Wire slot widths, reset pulse, and presence-detect window mandated by the DS18B20 datasheet.
- **Resynchro** — double-flops `onewire_in` and `debug_in` into the `clk100` domain to avoid metastability.
- **Master_protocol** — top-level FSM. On `start`, sequences INIT → Write → Read, handshaking with each sub-block and forwarding the command byte (`Byte_to_Write`).
- **INIT** — issues the 1-Wire reset pulse and samples the sensor's presence pulse.
- **Write8b** — serializes an 8-bit byte onto the bus using 1-Wire write time slots.
- **Read** — reads back a 9-bit value from the bus using 1-Wire read time slots.
- **wire_out** — muxes the three sub-blocks' drive requests (INIT / Write / Read) onto one internal signal, since only one phase drives the bus at a time.
- **Tristate_buffer** — drives the physical `onewire_out` pin (open-drain behavior).

## Status / Notes

- Single 100 MHz clock domain, synchronous reset generated internally from the async system reset.
- 1-Wire bus is unidirectional in this RTL (`onewire_in` / `onewire_out` separate pins) rather than a true bidirectional `inout` — expects external tri-state/pull-up handling on the board or top-level pin constraint.
- `value` is 9 bits wide — corresponds to a raw scratchpad temperature read (not yet converted to °C in this block).
