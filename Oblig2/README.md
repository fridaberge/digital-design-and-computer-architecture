# Assignment 2 — 32-Bit Carry-Lookahead Adder

Hierarchical digital-adder design using dataflow and structural VHDL, with testbenches and waveform analysis in Questa.

This assignment is part of **IN2060 — Digital Design and Computer Architecture** at the University of Oslo.

**Author:** Frida Berge (`fridatbe`)

## Overview

The assignment builds an adder in three stages:

1. A single-bit full-adder.
2. A four-bit carry-lookahead adder (CLA) block.
3. A 32-bit top-level adder assembled from eight CLA blocks.

Each design module has a corresponding testbench. The repository also includes waveform exports and saved simulator output.

## Files

| File | Description |
| --- | --- |
| [taskdescription.pdf](./taskdescription.pdf) | Original assignment instructions |
| [fulladder.vhd](./fulladder.vhd) | Single-bit full-adder |
| [tb_fulladder.vhd](./tb_fulladder.vhd) | Full-adder testbench |
| [fulladdertest.png](./fulladdertest.png) | Exported full-adder waveform image |
| [fulladdertest.vcd](./fulladdertest.vcd) | Full-adder waveform in Value Change Dump format |
| [CLA_block.vhd](./CLA_block.vhd) | Four-bit CLA block |
| [tb_CLA_block.vhd](./tb_CLA_block.vhd) | CLA-block testbench |
| [output.txt](./output.txt) | Saved simulator console output |
| [CLA_top.vhd](./CLA_top.vhd) | Top-level adder design |
| [tb_CLA_top.vhd](./tb_CLA_top.vhd) | Top-level adder testbench |
| [CLA_top.vcd](./CLA_top.vcd) | Top-level waveform export |

The folder also contains a file named `fulladdertestvcd`, without an extension. Its relationship to `fulladdertest.vcd` should be checked before removing or renaming it.

## Design Structure

```text
CLA_top — 32-bit adder
└── 8 × CLA_block — four-bit blocks
    └── 4 × fulladder — single-bit adders per block
```

The design combines two VHDL modelling styles:

- **Dataflow:** concurrent logic expressions describe how signals are calculated.
- **Structural:** component instantiations and port mappings connect smaller modules into larger designs.

## Task 1 — Full-Adder

### Interface

| Signal | Direction | Description |
| --- | --- | --- |
| `a`, `b` | Input | Operand bits |
| `cin` | Input | Carry-in |
| `s` | Output | Sum bit |
| `cout` | Output | Carry-out |

The expected logic is:

\[
s = a \oplus b \oplus c_{\mathrm{in}}
\]

\[
c_{\mathrm{out}} = (a \land b)
\lor (a \land c_{\mathrm{in}})
\lor (b \land c_{\mathrm{in}})
\]

### Testing

The assignment requires testing all eight combinations of `a`, `b` and `cin`, with 10 ns between input changes.

| `a` | `b` | `cin` | `s` | `cout` |
| --- | --- | --- | --- | --- |
| 0 | 0 | 0 | 0 | 0 |
| 1 | 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 0 | 1 |
| 0 | 0 | 1 | 1 | 0 |
| 1 | 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 0 | 1 |
| 1 | 1 | 1 | 1 | 1 |

### Waveform

![Full-adder simulation waveform](./fulladdertest.png)

The waveform can be compared against the truth table to check the sum and carry outputs.

**Source:** [fulladder.vhd](./fulladder.vhd)  
**Testbench:** [tb_fulladder.vhd](./tb_fulladder.vhd)

## Task 2 — Four-Bit CLA Block

The CLA block combines four full-adders with propagate and generate logic.

Following the assignment's convention, each bit uses:

\[
p_i = a_i \lor b_i
\]

\[
g_i = a_i \land b_i
\]

The block-level propagate and generate signals are:

\[
P_{3:0} = p_3 \land p_2 \land p_1 \land p_0
\]

\[
G_{3:0} =
g_3
\lor (p_3 \land g_2)
\lor (p_3 \land p_2 \land g_1)
\lor (p_3 \land p_2 \land p_1 \land g_0)
\]

The block carry-out is calculated as:

\[
c_{\mathrm{out}} =
G_{3:0} \lor (P_{3:0} \land c_{\mathrm{in}})
\]

The assignment uses OR-based propagate logic. XOR-based propagate is another valid convention, but it is not the convention specified here.

### Testing Requirements

The assignment allows either:

- At least six selected operand pairs, including cases with and without carry-out.
- Exhaustive testing of every four-bit operand pair and both carry-in values.

The testbench should use assertions to check results and report failures.

See the testbench for the implemented test coverage and `output.txt` for the saved simulator messages.

**Source:** [CLA_block.vhd](./CLA_block.vhd)  
**Testbench:** [tb_CLA_block.vhd](./tb_CLA_block.vhd)  
**Console output:** [output.txt](./output.txt)

## Task 3 — 32-Bit Top-Level Adder

The top-level module connects eight four-bit CLA blocks. Each block processes a slice of the operands and passes its carry-out to the next block.

The specified interface includes:

| Signal | Description |
| --- | --- |
| `a`, `b` | Input operand vectors |
| `cin` | Initial carry-in |
| `sum` | Result vector |
| `cout` | Final carry-out |

The assignment specifies a `width` generic with a default value of 32. Support for other widths should be checked in the implementation rather than assumed.

### Testing Requirements

The top-level testbench should exercise ten operand combinations, including values that use the most significant bits and values that do not.

The VCD export records the inputs and outputs for inspection in a waveform viewer.

**Source:** [CLA_top.vhd](./CLA_top.vhd)  
**Testbench:** [tb_CLA_top.vhd](./tb_CLA_top.vhd)  
**Waveform:** [CLA_top.vcd](./CLA_top.vcd)

## Running the Simulations

### Requirements

- Questa or a compatible VHDL simulator.
- VHDL-2008 support for features such as `std.env.stop` and reduction operators.

### Compile

From this folder, use the Questa command-line tools:

```bash
vlib work

vcom -2008 fulladder.vhd
vcom -2008 CLA_block.vhd
vcom -2008 CLA_top.vhd

vcom -2008 tb_fulladder.vhd
vcom -2008 tb_CLA_block.vhd
vcom -2008 tb_CLA_top.vhd
```

Compile the design modules before their testbenches.

### Simulate

Start Questa:

```bash
vsim
```

For each testbench:

1. Select **Simulate → Start Simulation**.
2. Choose the testbench from the `work` library.
3. Enable signal visibility if needed.
4. Add the relevant signals to the waveform window.
5. Enter `run -all` in the Transcript window.
6. Inspect assertion messages and compare the waveforms with the expected results.

Available testbenches:

- `tb_fulladder`
- `tb_CLA_block`
- `tb_CLA_top`

## Scope and Limitations

This folder documents a simulation-based digital-design exercise.

- File presence alone does not establish that every test passed; inspect the testbenches and simulator output.
- Functional simulations do not establish a physical propagation-delay improvement.
- No FPGA deployment or post-synthesis timing results are documented here.
- The top-level structure chains four-bit blocks; it is not a separate global lookahead network across all 32 bits.

## Learning Focus

- Expressing combinational logic in dataflow VHDL.
- Connecting modules using structural VHDL.
- Understanding carry propagation and block-level lookahead.
- Creating repeatable testbench stimulus.
- Checking results with assertions.
- Interpreting simulation waveforms and exporting VCD data.

## Attribution

The assignment brief, reference diagrams and starter testbench were provided by the course. The task description credits **Yngve Hafting (2020, 2023)**.
