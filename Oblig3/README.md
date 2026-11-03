# Assignment 3 — ARM Assembly Programming

Low-level programming exercises covering Fibonacci calculation, function calls, compiler-generated assembly and software floating-point addition.

This assignment was completed for **IN2060 — Digital Design and Computer Architecture** at the University of Oslo.

**Author:** Frida Berge (`fridatbe`)  
**Report date:** 22 October 2023

## Overview

The assignment connects higher-level algorithms with the instructions and registers used to execute them.

It consists of five parts:

1. Implement an iterative Fibonacci algorithm in ARM assembly.
2. Turn the algorithm into a callable function and print its result.
3. Compare handwritten assembly with compiler-generated assembly.
4. Calculate IEEE 754 single-precision representations by hand.
5. Implement floating-point addition using integer and bitwise instructions.

The folder contains source code, compiler-generated assembly, a submitted report and recorded addition results.

## Files

| File | Description |
| --- | --- |
| [taskdescription.pdf](./taskdescription.pdf) | Original assignment brief |
| [Taskdescription.md](./Taskdescription.md) | Additional task-description document |
| [oblig3.pdf](./oblig3.pdf) | Submitted report, including written answers and handwritten calculations |
| [part1.s](./part1.s) | Initial assembly Fibonacci exercise |
| [part2.s](./part2.s) | Callable Fibonacci exercise |
| [part3.c](./part3.c) | C version used for compiler comparison |
| [part3.s](./part3.s) | Compiler-generated assembly |
| [part3_2.s](./part3_2.s) | Additional assembly output for comparison |
| [part3_3.s](./part3_3.s) | Additional assembly output for comparison |
| [part5.s](./part5.s) | Software floating-point addition exercise |
| [addisjon.s](./addisjon.s) | Additional assembly file associated with addition |
| [addisjoner.txt](./addisjoner.txt) | Recorded floating-point addition results |
| [howto_RaspberryPi.pdf](./howto_RaspberryPi.pdf) | Raspberry Pi setup reference |

The exact optimization flags associated with the archived `part3*.s` files should be checked before assigning them to a particular optimization level.

Compiled executables are not needed in the source archive and can be rebuilt using the commands below.

## Part 1 — Iterative Fibonacci

The first exercise implements an iterative Fibonacci algorithm using registers, arithmetic instructions, comparisons and branches.

The assignment requires:

- Supporting non-negative input values.
- Updating the current and previous sequence values in a loop.
- Placing the final result in `r0`.
- Checking several inputs using GDB.

For the supplied input of `13`, the expected result is `233`.

**Source:** [part1.s](./part1.s)

## Part 2 — Functions and Calling Conventions

The second exercise moves the Fibonacci calculation into a function named `fib`.

The intended interface uses:

- `r0` for the input argument.
- `r0` for the returned result.
- `main` to call `fib` and print the result with `printf`.

The exercise introduces register preservation, the stack and the link register. A function that makes another function call must preserve its own return address when necessary, because a branch-with-link instruction updates `lr`.

The report discusses:

- Caller-saved and callee-saved registers.
- What happens to the input register after a function returns.
- Why `main` needs to preserve its return address when making calls.

**Source:** [part2.s](./part2.s)  
**Written answers:** [oblig3.pdf](./oblig3.pdf)

## Part 3 — Compiler-Generated Assembly

A C implementation of Fibonacci is compiled into assembly and compared with the handwritten version.

The assignment investigates three optimization levels:

| Flag | Optimization focus |
| --- | --- |
| `-Os` | Optimize for code size |
| `-O2` | Enable a broad set of optimizations |
| `-O3` | Enable additional, more aggressive optimizations |

The submitted report discusses differences in register allocation, branch instructions and loop structure.

It also notes that one generated version places the known Fibonacci result, `233`, directly in the code. This illustrates how a compiler can simplify a calculation when its input is known at compile time.

Compiler output depends on the compiler version, target settings and optimization options. Regenerated files may therefore differ from the archived examples.

**C source:** [part3.c](./part3.c)  
**Assembly outputs:** [part3.s](./part3.s) · [part3_2.s](./part3_2.s) · [part3_3.s](./part3_3.s)

## Part 4 — IEEE 754 Representation

The written exercise explores the IEEE 754 binary32 format:

| Field | Width |
| --- | --- |
| Sign | 1 bit |
| Exponent | 8 bits |
| Fraction | 23 bits |

The report includes handwritten calculations for:

- Representing `2.0`.
- Representing `3.0`.
- Representing `0.50390625`.
- Adding `2.0` and `0.50390625` through exponent alignment and significand addition.

For normal numbers, the leading significand bit is implicit rather than stored in the fraction field.

**Calculations:** [oblig3.pdf](./oblig3.pdf)

## Part 5 — Software Floating-Point Addition

The final programming exercise implements floating-point addition without ARM floating-point instructions.

The assignment's algorithm consists of:

1. Extracting the exponent fields.
2. Extracting the fraction fields and restoring the implicit leading bit.
3. Comparing the exponents.
4. Right-shifting the smaller operand's significand to align the operands.
5. Adding the significands.
6. Normalizing the result when necessary.
7. Reassembling the exponent and fraction fields.
8. Placing the resulting bit pattern in `r0`.

### Required Test Cases

The following are reference results for the assignment's test cases, not a claim that the archived implementation has been independently verified.

| First operand | Second operand | Expected result | Expected binary32 encoding |
| --- | --- | --- | --- |
| `1.0` | `1.0` | `2.0` | `0x40000000` |
| `2.0` | `1.0` | `3.0` | `0x40400000` |
| `3.0` | `3.5` | `6.5` | `0x40D00000` |
| `2.0` | `0.50390625` | `2.50390625` | `0x40204000` |

Compare the recorded results in `addisjoner.txt` with these values.

**Source:** [part5.s](./part5.s)  
**Recorded results:** [addisjoner.txt](./addisjoner.txt)

### Scope

The exercise assumes positive operands and does not require rounding.

It should not be treated as a complete IEEE 754 implementation. Handling of zero, subnormal numbers, negative operands, infinities, NaNs and exponent overflow would require additional implementation and testing.

## Building and Running

### Requirements

For the emulation workflow:

- `arm-linux-gnueabihf-g++`
- `qemu-arm-static`
- `gdb-multiarch`

The original course environment was entered using:

```bash
in2060_arm
```

This is a course-specific command, not a standard Linux tool.

### Compile the Assembly Programs

Run from this folder:

```bash
arm-linux-gnueabihf-g++ -static -g -o part1 part1.s
arm-linux-gnueabihf-g++ -static -g -o part2 part2.s
arm-linux-gnueabihf-g++ -static -g -o part5 part5.s
```

The `-g` flag includes debugging information. The `-static` flag follows the assignment's emulation setup.

Execute a program through QEMU:

```bash
qemu-arm-static ./part2
```

Programs that only leave a result in `r0` need debugger inspection; they do not necessarily print that result.

### Debug an Assembly Program

For example, to inspect `part1`:

```bash
qemu-arm-static -g 1234 ./part1 &
gdb-multiarch -tui ./part1
```

Inside GDB:

```text
target remote localhost:1234
break main
continue
tui reg general
```

Useful commands:

| Command | Purpose |
| --- | --- |
| `break main` | Stop at the start of `main` |
| `stepi` | Execute one machine instruction |
| `continue` | Resume execution |
| `info registers` | Print register values |
| `p/x $r0` | Display `r0` in hexadecimal |
| `p/d $r0` | Display `r0` in signed decimal |
| `quit` | Exit GDB |

Set a breakpoint before the function returns to inspect the final register value.

Restart the QEMU process for each new debugging session.

### Reproduce the Compiler Comparison

Use separate filenames to avoid overwriting the archived assembly:

```bash
arm-linux-gnueabihf-g++ -Os -S -o comparison_Os.s part3.c
arm-linux-gnueabihf-g++ -O2 -S -o comparison_O2.s part3.c
arm-linux-gnueabihf-g++ -O3 -S -o comparison_O3.s part3.c
```

The `-S` flag produces assembly instead of a linked executable.

### Raspberry Pi Alternative

On a compatible 32-bit ARM environment, the assignment provides this native compilation workflow:

```bash
gcc -g -o part1 part1.s
gdb -tui ./part1
```

An AArch64-only toolchain is not a direct replacement for the 32-bit ARM toolchain used here.

See [howto_RaspberryPi.pdf](./howto_RaspberryPi.pdf) for the original setup reference.

## Reflections and Known Issues

The submitted report is preserved as coursework rather than rewritten as a corrected reference. Some explanations need clarification:

- **Register preservation:** Under the usual AAPCS32 convention, `r0`–`r3` and `r12` are caller-saved. A callee must preserve the applicable callee-saved registers it modifies; the precise role of `r9` depends on the platform.
- **Return value:** The report states that `r0` contains zero after the Fibonacci loop. That may describe the exhausted loop counter, but the required function interface returns the Fibonacci result in `r0`. Check the source to distinguish the loop state from the final return value.
- **Link register:** Saving `lr` in `main` preserves its incoming return address. Calls to `fib` and `printf` update `lr` with their respective return locations.
- **`CBZ`:** The report describes this instruction as flag-dependent. `CBZ` instead tests a register directly and does not use the condition flags.
- **Optimization:** Fewer assembly lines do not necessarily mean fewer executed instructions, a smaller binary or faster execution.

Further work could include automated tests, explicit integer-overflow handling and broader floating-point edge-case coverage.

## What I Learned

- Translating an iterative algorithm into register operations and branches.
- Separating an assembly routine from its caller.
- Understanding return addresses and register-preservation responsibilities.
- Comparing handwritten code with compiler output.
- Interpreting floating-point bit fields.
- Using masks and shifts to implement arithmetic at the bit level.
- Inspecting program state with GDB.

## Attribution

The assignment instructions, starter programs and reference C implementation were provided by the course.

This folder preserves the submitted work and supporting files. It is a learning archive, not a validated numerical library.
