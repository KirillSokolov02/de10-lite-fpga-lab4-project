# Please — DE10-Lite FPGA Lab 4

A comprehensive VHDL-based FPGA design for the Intel DE10-Lite development board, integrating a clock generator, Gray code counter, up/down counter, 7-segment display decoder, and a quiz state machine — all orchestrated from a single top-level entity targeting the Intel MAX 10 FPGA.

## Overview

This project is **Lab 4** from the **University of Florida EEL 4516** (Computer Organization and Architecture) course. It demonstrates key digital design concepts including **clock generation and division**, **state machine design** (both Mealy and Moore types), **counters**, and **7-segment display decoding** — all implemented in **VHDL** and synthesized for Intel's **MAX 10** FPGA family using **Quartus Prime Lite 19.1**.

The design targets the **DE10-Lite** board (based on the **10M50DAF484C7G** MAX 10 device) and exercises six 7-segment LED displays, ten slide switches, and two push buttons as user I/O.

The architecture follows a **hierarchical, top-down design** approach: a single top-level entity (`top_level`) instantiates and interconnects five reusable sub-modules, each implementing a distinct digital circuit.

## Features

### Clock Generation (`clk_gen`, `clk_div`)

- **50 MHz to 1 kHz clock division** — The on-board 50 MHz oscillator is divided down to 1 kHz using a parameterizable frequency divider (`clk_div`)
- **Button-controlled clock enable** — A debounced clock pulse generator that produces a single clock tick when a button is pressed for a configurable duration (`ms_period` generic)
- **Generic parameterization** — Input/output frequencies are configured via VHDL generics for easy reuse

### Gray Code Counter (`gray2`)

- **16-state Gray code sequence** — Cycles through all 16 4-bit Gray code values (0–15), where only one bit changes between consecutive states
- **Two-process FSM implementation** — Separates the state register (clocked process) from the output mapping (combinational process), a VHDL best practice
- **Resettable state machine** — Synchronous reset initialized to state_0 (output "0000")
- **Sequential state traversal**: 0→1→3→2→6→7→5→4→12→13→15→14→10→11→9→8→0

### Up/Down Counter (`counter`)

- **Direction-controlled counting** — 4-bit up/down counter with:
  - `up_n` (active-low) — Selects increment (0) or decrement (1)
  - `load_n` (active-low) — Async load from switch inputs when asserted
- **Synchronous reset** — Initializes to "0000"
- **Arithmetic via numeric_std** — Uses `unsigned()` conversion for reliable addition/subtraction
- **Modulo-16 wraparound** — Natural 4-bit overflow behavior

### 7-Segment Decoder (`decoder7seg`)

- **BCD to 7-segment mapping** — Converts 4-bit binary inputs to 7-segment cathode patterns
- **Common-cathode segment activation** — Outputs "1000000" (digit 0) with the decimal point disabled
- **Standard segment mapping**: a=bit[6], b=bit[5], c=bit[4], d=bit[3], e=bit[2], f=bit[1], g=bit[0]
- **Full 16-value lookup table** — Covers all hex digits 0–F

### Quiz State Machine (`Quiz`)

- **7-state interactive quiz** — Cycles through quiz responses displayed as BCD on 7-segment LED3
- **State sequence**: state_0→state_1→state_3→state_2→state_6→state_7→state_5→state_0 (note: state_4 is intentionally unused)
- **Output pattern**: 3→7→2→4→9→1→6 (displayed as BCD values)
- **Single-process FSM** — Combines state register and output mapping in one clocked process

### Top-Level Integration (`top_level`)

- **Five sub-module instantiations** — Connects clk_gen, gray2, counter, Quiz, and decoder7seg
- **Switch-controlled counter** — Switches 9-6 load into counter; switch 5 selects up (0) or down (1); switch 4 loads new value
- **Multi-display output**:
  - **LED5** — Gray code counter output (0–F)
  - **LED4** — Up/down counter value (0–F)
  - **LED3** — Quiz state machine output (3, 7, 2, 4, 9, 1, 6)
  - **LED2, LED1, LED0** — Blank (constant "0000" input)
- **All decimal points disabled** — Set to active-high '1' to turn off common-cathode decimal points

## Project Structure

```
please/
├── top_level.vhd        # Top-level entity — integrates all sub-modules
├── clk_gen.vhd          # Button-controlled clock enable generator
├── clk_div.vhd          # 50 MHz → configurable frequency clock divider
├── gray2.vhd            # 4-bit Gray code counter (two-process FSM)
├── gray1.vhd            # Alternative Gray code counter (single-process FSM)
├── counter.vhd          # 4-bit up/down counter with load
├── decoder7seg.vhd      # BCD-to-7-segment decoder (common cathode)
├── Quiz.vhd             # 7-state quiz state machine
├── top_level.qpf        # Quartus Prime project file
├── top_level.qsf        # Quartus settings (pin assignments, device)
└── .gitignore           # Excludes Quartus build artifacts
```

## Building

### Prerequisites

- **Intel Quartus Prime Lite Edition 19.1** (or later)
- **Intel DE10-Lite development board** (10M50DAF484C7G FPGA)
- **VHDL-2008** language standard supported

### Compilation Steps

1. Open Quartus Prime and select **File → Open Project**
2. Navigate to `D:\intelFPGA_lite\19.1\projects\please\` and open `top_level.qpf`
3. Select **Project → Start Compilation** (or press F7)
4. Wait for compilation to complete (~1–3 minutes on modern hardware)
5. Check the **Compilation Report** for timing and resource utilization

### Device Configuration

| Parameter              | Value                                    |
|------------------------|------------------------------------------|
| Family                 | MAX 10                                   |
| Device                 | 10M50DAF484C7G                             |
| Quartus Version        | 19.1.0 Lite Edition                      |
| Top-level Entity       | top_level                                |
| Output Directory       | output_files/                            |
| Simulation Tool        | ModelSim-Altera (VHDL)                   |
| Junction Temp Range    | 0°C to 85°C                              |

### Synthesis Notes

- **Harmless synthesis warnings expected**: Unused button(0) input and constant '0'/'1' outputs for LED2, LED1, LED0 decimal points
- **All unused pins**: Configured as weak pull-up, tri-stated inputs
- **Configuration device**: Enabled for external configuration EEPROM
- **OCT (On-Chip Termination)**: Enabled for DONE pin

## Usage

### Hardware Setup

1. Connect the DE10-Lite board to power via USB or the barrel jack
2. Program the FPGA using Quartus **Tools → Program** (or the hardware controller)
3. Select **USB-Blaster** as the programmer

### Interactive Controls

| Component     | Pin(s)           | Function                                  |
|--------------|------------------|-------------------------------------------|
| Switches 0–9 | SW[9:0]          | Switch 9–6: Counter load input            |
|              |                  | Switch 5: Up(0)/Down(1) direction         |
|              |                  | Switch 4: Load counter value (active low) |
| Buttons 0–1  | KEY[1:0]        | KEY[1]: Clock enable (press for delay)    |
|              |                  | KEY[0]: System reset (active low)         |
| LED0–5       | HEX[5:0][6:0]   | 7-segment display outputs (left=HEX5)     |

### Expected Behavior

1. **Press KEY[1]** and hold — the debounced clock generator produces a single pulse after the configured `ms_period` (1000 ms default), causing all state machines to advance one step
2. **Release KEY[1]** — no additional clock pulses until pressed again
3. **HEX5** displays the Gray code counter: 0, 1, 3, 2, 6, 7, 5, 4, 12(C), 13(D), 15(F), 14(E), 10(A), 11(B), 9, 8, 0...
4. **HEX4** displays the up/down counter value, controllable via switches
5. **HEX3** displays the quiz state machine output: 3, 7, 2, 4, 9, 1, 6, 3...
6. **HEX2, HEX1, HEX0** remain blank (constant "0000" input)

### Modifying the Design

- **Change clock period**: Edit the `ms_period` generic in the `clk_gen` instantiation in `top_level.vhd`
- **Change clock frequency**: Modify the `clk_out_freq` generic in `clk_div` instantiation in `clk_gen.vhd`
- **Modify Gray code sequence**: Edit the state transition logic in `gray2.vhd` (or use `gray1.vhd` as alternative)
- **Add quiz states**: Extend the state type and case statements in `Quiz.vhd`

## Data Flow

```
clk50MHz ──→ clk_gen ──→ clk_gen_out (debounced clock)
                                    │
                    ┌───────────────┼───────────────┬──────────┐
                    │               │               │          │
              gray2 (clk)    counter (clk)    Quiz (clk)    clk_div
                    │               │               │          │
                    ▼               ▼               ▼
              gray_out        counter_out      quiz_out
                    │               │               │
                    ▼               ▼               ▼
          decoder7seg     decoder7seg      decoder7seg
                    │               │               │
                    ▼               ▼               ▼
                 HEX5[6:0]      HEX4[6:0]       HEX3[6:0]
```

## Technical Details

### FSM Design Methodologies

- **Two-process FSM** (`gray2`): Separated state register (sequential) and output mapping (combinational) — recommended for clean timing and synthesis
- **Single-process FSM** (`gray1`, `Quiz`): Combined state register and output in one process — more compact but can produce latches if not careful

### VHDL Conventions Used

- **`ieee.std_logic_1164`** for multi-valued logic types
- **`ieee.numeric_std`** for arithmetic operations (`unsigned`, `signed`)
- **`ieee.math_real`** for mathematical functions (in clock divider)
- **Entity-architecture separation** — Clear interface specification independent of implementation
- **Generic parameters** for configurability (clock frequencies, timing)
- **Signal naming**: `temp` for intermediate values, `state_r` for state registers

### Resource Utilization (Expected)

- **Logic elements**: ~200–400 out of ~50,000 available (MAX 10 10M50)
- **Registered bits**: ~50–100
- **I/O pins used**: ~40 out of 280 available

## References

- Intel MAX 10 Device Datasheet
- DE10-Lite User Manual
- VHDL Standards: IEEE 1076-2008
- Quartus Prime Getting Started Tutorial
