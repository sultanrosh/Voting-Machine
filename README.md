# 🗳️ Verilog Voting Machine on Zynq-7000 SoC – Full Documentation

## 📋 Overview

This project implements a **4-button voting machine system in Verilog** for simulation and hardware testing using the **Zynq-7000 ARM/FPGA SoC Development Board**.

### It includes:

* **Button debouncing and hold-time validation logic** (`buttonControl`)
* **Vote counting and logging module** (`voteLogger`)
* **LED output control for feedback and results display** (`modeControl`)
* A **top-level module** (`votingMachine`) that wires it all together
* A **testbench** (`testbench.v`) that simulates multiple voting scenarios and displays output on LEDs

The design ensures valid votes are only registered if buttons are held for a specific duration, simulating real-world mechanical button hold times and preventing false triggers.

---

## 🧠 How the System Works

### 🧹 Module Overview

#### `buttonControl`

* Validates that a button is held for a sustained period (10 clock cycles).
* Helps prevent bouncing or accidental button presses.
* Outputs `valid_vote = 1` when the button has been pressed long enough.

#### `voteLogger`

* In vote mode (`mode = 0`), logs a vote for one of the 4 candidates if a valid vote is detected.
* Uses four separate **8-bit counters** to track the number of votes for each candidate.
* Only one candidate can receive a vote at a time due to `else if` logic.

#### `modeControl`

* Controls the LED display based on the mode:

  * **Mode 0 (voting mode):** LEDs flash to show a vote was successfully cast.
  * **Mode 1 (view results mode):** LEDs display vote count for selected candidate when a button is pressed.

#### `votingMachine` (Top-level module)

* Instantiates the three submodules and wires them together.
* Routes input button presses, mode, and reset to appropriate logic.
* Combines valid votes to inform `modeControl` when to flash LEDs.

---

## 📦 File Structure

```
├── buttonControl.v        # Validates sustained button press
├── voteLogger.v           # Increments candidate vote counters
├── modeControl.v          # Controls LED display for feedback and results
├── votingMachine.v        # Top-level integration module
├── testbench.v            # Simulates multiple voting scenarios
├── dump.vcd               # (Generated) Simulation waveform file
```

---

## 🛠️ Hardware Requirements

* ✅ **Zynq-7000 ARM/FPGA SoC Development Board**
* ✅ 4 push-buttons (connected to `button1` to `button4`)
* ✅ 8-bit LED display (for output via `led`)
* ✅ Clock source (e.g., onboard 50MHz oscillator)
* ✅ Reset button

---

## 🚦 Inputs and Outputs

| Signal      | Direction | Width | Description                           |
| ----------- | --------- | ----- | ------------------------------------- |
| `clock`     | Input     | 1     | Clock signal (e.g., 50MHz)            |
| `reset`     | Input     | 1     | Active-high reset                     |
| `mode`      | Input     | 1     | 0 = voting mode, 1 = result view mode |
| `button1-4` | Input     | 1     | Candidate vote buttons                |
| `led`       | Output    | 8     | LED output (feedback or vote count)   |

---

## 🧪 Testbench Explanation (`testbench.v`)

The simulation testbench performs the following:

* Applies reset
* Simulates button presses and releases
* Switches between voting and view mode
* Uses `#5`, `#10`, `#200` delays to simulate real-world button holding and release timing

### 🔁 Example Time Delay:

```verilog
#5 reset = 0; mode = 0; button1 = 1;
```

This line means: "Wait 5 simulation time units, then apply the input values."

* A vote only becomes valid after **10 clock cycles** of sustained button press.
* Thus, **multiple #5 or #10 delays** simulate a user holding a button.

---

## 🔌 Hardware Deployment (Zynq-7000)

### 1. **Synthesize and Implement**

* Use **Vivado** to create a new project.
* Import all Verilog modules.
* Assign pins for buttons and LEDs based on your board’s constraint file (`.xdc`).

### 2. **Connect Inputs/Outputs**

* Map buttons to physical pins (e.g., push buttons).
* Map `led[7:0]` to 8 user LEDs.

### 3. **Generate Bitstream**

* Program the FPGA with the synthesized design.

### 4. **Use the Board**

* Hold a button for \~10 clock cycles (or a few milliseconds depending on clock freq) to cast a vote.
* Switch to view mode (`mode = 1`) and press a button to view vote counts on LEDs.

---

## 💡 Notes

* The system **ignores simultaneous button presses** — only the first `else if` vote gets logged.
* **Clock frequency** affects timing: for a 50MHz clock, 10 cycles = 200ns. To make it human-pressable, increase the counter threshold (e.g., 1,000,000 cycles for \~20ms).
* All modules are triggered on the **positive edge of the clock**.

---

## 🏁 Final Summary

This Verilog project:

* Demonstrates **modular FPGA design**
* Emphasizes **real-world timing and input validation**
* Is **fully synthesizable** for a real FPGA (Zynq-7000), not just simulation
* Teaches **signal flow**, **instantiation**, **sequential logic**, and **testbench methodology**

---

**Project by:** *Your Name Here*
**License:** MIT (or specify your license)

---
