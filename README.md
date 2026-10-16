# DE10-Lite FPGA Lab 4 — Clock Generation, Counters & 7-Segment Display

FPGA design for Intel MAX 10 (DE10-Lite) implementing clock generation, division, counter circuits, and a 7-segment display decoder. Built with Quartus Prime 19.1.

## Overview

This project demonstrates core FPGA design concepts using VHDL on Intel's MAX 10 architecture. It implements a hierarchical design with multiple interacting modules including clock manipulation, counter logic, and display output.

## Project Structure

| File | Description |
|------|-------------|
| `clk_gen.vhd` | 50MHz clock generator |
| `clk_div.vhd` | Clock divider circuit |
| `gray1.vhd` / `gray2.vhd` | Gray code encoders/decoders |
| `counter.vhd` | Counter circuit with various modes |
| `decoder7seg.vhd` | 7-segment display decoder |
| `Quiz.vhd` | Quiz/exercise module |
| `top_level.vhd` | Top-level module connecting all components |

## Hardware

- **Device:** Intel MAX 10 10M50DAF484C7G
- **Board:** Terasic DE10-Lite
- **Tool:** Quartus Prime 19.1
- **Language:** VHDL-2008

## Key Concepts

- Hierarchical design with module instantiation
- Clock domain management (generation and division)
- Counter design with enable and reset control
- Gray code encoding for reduced switching noise
- 7-segment display multiplexing and decoding

## Building

1. Open `top_level.qpf` in Quartus Prime
2. Run Analysis & Synthesis
3. Run Place & Route
4. Program the DE10-Lite board via USB-Blaster
