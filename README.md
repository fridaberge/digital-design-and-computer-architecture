# Digital Design and Computer Architecture

Digital logic design and low-level programming using **VHDL, Questa, ARM assembly, QEMU and GDB**.

This repository collects three assignments covering combinational circuits, hierarchical adder design, processor instructions and floating-point representation.

## Overview

| Assignment | Focus | Main tools |
| --- | --- | --- |
| [Assignment 1](./Oblig1/) | Half-adder simulation, ARM compilation and register inspection | VHDL, Questa, C, ARM assembly, QEMU, GDB |
| [Assignment 2](./Oblig2/) | Full-adder and hierarchical 32-bit carry-lookahead adder | VHDL, Questa, testbenches |
| [Assignment 3](./Oblig3/) | Fibonacci, function calls, compiler comparison and floating-point addition | ARM assembly, C, GCC, QEMU, GDB |

## Repository Structure

```text
digital-design-and-computer-architecture/
├── README.md
├── Oblig1/
│   ├── README.md
│   ├── taskdescription.pdf
│   ├── helloworld_assembler.s
│   └── Simulation and debugging screenshots
├── Oblig2/
│   ├── README.md
│   ├── taskdescription.pdf
│   ├── VHDL design modules
│   ├── VHDL testbenches
│   └── Waveform exports and simulator output
└── Oblig3/
    ├── README.md
    ├── taskdescription.pdf
    ├── oblig3.pdf
    ├── ARM assembly and C source files
    └── Recorded addition results and supporting documents
```

Each assignment folder contains a dedicated README with file descriptions and instructions.

## Assignment 1 — Simulation and ARM Tool Setup

An introduction to the tools used throughout the repository.

### Digital Logic

- Compile a VHDL half-adder in Questa.
- Apply all four input combinations manually.
- Inspect the sum and carry outputs.
- Export the simulation waveform.

### ARM Programming

- Cross-compile and execute a C greeting program.
- Compile and run an ARM assembly program through QEMU.
- Inspect registers using GDB's terminal interface.
- Add values stored in registers and capture the result.

The folder includes the assembly source and screenshots documenting the exercises. The original C and VHDL source files are not included.

[View Assignment 1 →](./Oblig1/README.md)

## Assignment 2 — Hierarchical Adder Design

A digital-design exercise that builds a larger circuit from smaller components:

```text
32-bit adder
└── Eight four-bit CLA blocks
    └──
