# 🧩 UVM Verification Environment for SPI-Wrapper-RAM

## 📜 Project Overview

This repository presents a comprehensive **Universal Verification Methodology (UVM)** testbench developed to verify a system integrating an **SPI Slave** and a **Single-Port RAM** through an **SPI Wrapper** interface.

The main objective of this project is to demonstrate **modular verification reuse**, where individual UVM environments for component-level verification (SPI Slave and RAM) are integrated into a **system-level verification environment** for the SPI Wrapper.

---

## 🧠 Project Structure and Verification Phases

The verification process is divided into three major parts, each focusing on a specific design block:

### **Part 1 – SPI Slave Verification**
- **Design Under Test (DUT):** SPI Slave core that implements the **Serial Peripheral Interface (SPI)** protocol.
- **UVM Environment:** Validates SPI protocol compliance through dedicated sequences covering various transactions (e.g., Write Address, Write Data, Read Address, Read Data).

### **Part 2 – Single-Port RAM Verification**
- **Design Under Test (DUT):** Parameterized **Single-Port RAM** with default configuration:  
  `MEM_DEPTH = 256`, `ADDR_SIZE = 8`
- **UVM Environment:** Ensures correct read/write behavior, address range integrity, and data coherence through randomized and directed tests.

### **Part 3 – SPI Wrapper (System Integration Verification)**
- **Design Under Test (DUT):** The **SPI Wrapper**, serving as the integration layer between the SPI Slave (front-end) and the RAM (back-end).
- **UVM Environment:** A top-level verification environment reusing both the SPI Slave and RAM environments as **passive agents**, enabling full system-level verification of data integrity and communication flow.

---

## 🎯 Verification Highlights

### **Coverage Goals**
To ensure comprehensive verification, the following coverage goals were targeted:
- **Code Coverage:** 100% line, toggle, branch, and expression coverage.
- **Functional Coverage:**
  - Coverpoints on interface signals (`rx_data`, `SS_n`, `MOSI`, etc.)
  - Cross-coverage between command types (`din[9:8]`, `MOSI` command bits) and control signals (`rx_valid`, `tx_valid`)
  - Sequential coverage capturing transaction ordering such as:
    ```
    Write Address → Write Data → Read Address → Read Data
    ```

### **Assertions**
SystemVerilog Assertions (SVA) were implemented to ensure protocol correctness and signal integrity:
- **Safety Checks:** Reset behavior validation (outputs must de-assert upon reset).
- **Liveness Checks:** Ensures that commands trigger corresponding responses (e.g., write followed by read).
- **Temporal Checks:** Verifies timing relations between key signals (`rx_valid`, `tx_valid`, etc.).

### **Sequences and Scenarios**
Multiple parameterized and randomized sequences were created to ensure exhaustive verification:
- `reset_sequence`
- `write_only_sequence`
- `read_only_sequence`
- `write_read_sequence` (randomized operation with probabilistic selection)

---

## 👥 Project Team

-Saeed Maher Saeed
-Sameh Mohammed Sameh 
-Hazem Ahmed Mohamed Elsheshtawy

---


> **Developed with passion for verification excellence and UVM reusability.**
