# UART Communication System using Verilog

## Overview
This project implements a **UART (Universal Asynchronous Receiver Transmitter) communication system** in Verilog HDL on FPGA.

UART enables **asynchronous serial communication** between devices without requiring a shared clock. Instead, both transmitter and receiver agree on a common **baud rate**. To improve timing accuracy and noise immunity, **16x oversampling** is used at the receiver side.

The system includes:

- UART Transmitter
- UART Receiver
- FIFO Buffer
- Baud Rate Generator
- Button Debounce Circuit

The project was tested using **PuTTY** for serial communication with FPGA hardware.

---

# System Architecture

Laptop (PuTTY) ↔ UART Receiver → FIFO → Processing Unit (+1 Incrementor) → UART Transmitter ↔ Laptop (PuTTY)

The FPGA receives serial data from PuTTY, stores it in FIFO, increments the received value by **1**, and transmits it back to the laptop.

---

# UART Transmitter

## Working Principle
The transmitter converts **parallel input data** into **serial data** and sends it bit-by-bit based on the sample tick from the baud rate generator.

## Inputs
- Parallel input data
- Sample tick
- Reset
- Clock
- `tx_start` (start transmission signal)

## Outputs
- Serial output (`TX`)
- Transmission complete signal (`tx_done`)

## States
1. **Idle** → TX line high
2. **Start** → TX line low
3. **Data** → Sends bits (LSB first)
4. **Stop** → TX line high
5. Return to Idle

---

# UART Receiver

## Working Principle
The receiver converts incoming serial data into parallel form.

It continuously monitors the RX line for a **falling edge** to detect the start bit and samples incoming bits using **16x oversampling**.

## Inputs
- Serial input (`RX`)
- Sample tick
- Reset
- Clock

## Outputs
- Parallel output data
- Data ready signal

## States
1. **Idle**
2. **Start Detection**
3. **Data Reception**
4. **Stop Detection**
5. Return to Idle

## Oversampling
The receiver samples each bit **16 times** and captures data at the **middle sample point** for better stability and noise immunity.

---

# UART Frame Format

Each frame contains:

- **Idle Bit** → Logic High
- **Start Bit** → Logic Low
- **8 Data Bits** (LSB first)
- **Parity Bit** → Not used
- **Stop Bit** → Logic High

---

# FIFO Buffer

## Working Principle
FIFO (**First In First Out**) temporarily stores data while preserving order.

It prevents:

- **Overflow** → Writing when full
- **Underflow** → Reading when empty

## Inputs
- Clock
- Reset
- Write enable
- Read enable
- Parallel input data

## Outputs
- Parallel output data
- Full flag
- Empty flag

## Internal Components
- Write Pointer
- Read Pointer
- Memory Array

## Parameters
- `DBITS = 8`
- `ADDR_SPACE_EXP = 4`

Memory Depth:

2⁴ = **16 locations**

---

# Baud Rate Generator

## Working Principle
Since UART has no shared clock, a baud generator produces timing pulses for both transmitter and receiver.

Baud rate used:

**9600 bps**

It divides the FPGA system clock into slower UART timing ticks.

## Inputs
- Clock
- Reset

## Output
- Sample Tick

## Parameters
- `N = 10`
- `M = 651`

Where:

M = System Clock / (16 × Baud Rate)

---

# Button Debounce Circuit

## Working Principle
Mechanical buttons create unwanted transitions (bouncing).

The debounce circuit ensures only stable button presses are detected by:

- Counting stable clock cycles
- Updating output only after sufficient stability

---

# Verification

Each module was individually verified using dedicated **testbenches**:

- UART Transmitter Testbench
- UART Receiver Testbench
- FIFO Testbench
- Baud Generator Testbench
- Debounce Circuit Testbench

Waveforms were analyzed using simulation tools.

---

# Demonstration

The complete design was demonstrated on FPGA hardware before **Dr. Srinivas Boppu**.

Communication flow:

1. Laptop sends data via PuTTY
2. FPGA receives data
3. Data stored in FIFO
4. FPGA increments received value by **1**
5. Result transmitted back to laptop
6. PuTTY displays updated value

---

# Key Learnings

This project helped understand:

- Serial-to-parallel conversion
- Parallel-to-serial conversion
- UART timing synchronization
- Oversampling for noise immunity
- FIFO memory management
- Baud rate generation
- Hardware debouncing
- FPGA-based serial communication

---

# Conclusion

This project successfully demonstrates UART communication using Verilog HDL with FIFO buffering and real-time data processing.

It provided practical experience in digital communication concepts such as:

- Serialization
- Parallelization
- Synchronization
- Data buffering
- Reliable asynchronous communication

The implemented **+1 incrementor system** validates end-to-end UART communication between FPGA and PC.

---
