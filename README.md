🗳️ Verilog Voting Machine on Zynq-7000 SoC – Full Documentation
📋 Overview
This project implements a 4-button voting machine system in Verilog for simulation and hardware testing using the Zynq-7000 ARM/FPGA SoC Development Board.

It includes:

Button debouncing and hold-time validation logic (buttonControl)

Vote counting and logging module (voteLogger)

LED output control for feedback and results display (modeControl)

A top-level module (votingMachine) that wires it all together

A testbench that simulates multiple voting scenarios and displays output on LEDs

The design ensures valid votes are only registered if buttons are held for a specific duration, simulating real-world mechanical button hold times and preventing false triggers.

🧠 How the System Works
🧩 Module Overview
1. buttonControl
Validates that a button is held for a sustained period (10 clock cycles).

Helps prevent bouncing or accidental button presses.

Outputs valid_vote = 1 when the button has been pressed long enough.

2. voteLogger
In vote mode (mode = 0), logs a vote for one of the 4 candidates if a valid vote is detected.

Uses four separate 8-bit counters to track the number of votes for each candidate.

Only one candidate can receive a vote at a time due to else if logic.

3. modeControl
Controls the LED display based on the mode:

Mode 0 (voting mode): LEDs flash to show a vote was successfully cast.

Mode 1 (view results mode): LEDs display vote count for selected candidate when a button is pressed.

4. votingMachine (Top-level module)
Instantiates the three submodules and wires them together.

Routes input button presses, modes, and reset to appropriate logic.

Combines valid votes to inform modeControl when to flash LEDs.

📦 File Structure
├── buttonControl.v        // Validates sustained button press
├── voteLogger.v           // Increments candidate vote counters
├── modeControl.v          // Controls LED display for feedback and results
├── votingMachine.v        // Top-level integration module
├── testbench.v            // Simulates multiple voting scenarios
├── dump.vcd               // (Generated) Simulation waveform file

🛠️ Hardware Requirements
✅ Zynq-7000 ARM/FPGA SoC Development Board

✅ 4 push-buttons (connected to button1–button4)

✅ 8-bit LED display (for output via led)

✅ Clock source (e.g., onboard 50MHz oscillator)

✅ Reset button

🚦 Inputs and Outputs
| Signal      | Direction | Width | Description                           |
| ----------- | --------- | ----- | ------------------------------------- |
| `clock`     | Input     | 1     | Clock signal (e.g., 50MHz)            |
| `reset`     | Input     | 1     | Active-high reset                     |
| `mode`      | Input     | 1     | 0 = voting mode, 1 = result view mode |
| `button1-4` | Input     | 1     | Candidate vote buttons                |
| `led`       | Output    | 8     | LED output (feedback or vote count)   |


🧪 Testbench Explanation
A full simulation testbench is included (testbench.v), which:

Applies reset

Simulates button presses and releases

Switches between voting and view mode

Waits with #5, #10, #200 between actions to simulate human interaction

🔁 Example Time Delay:
#5 reset = 0; mode = 0; button1 = 1;
#5 means wait 5 time units (in simulation) before applying these inputs.

This models how long the button is held. A vote only becomes valid after 10 clock cycles, so multiple #5 or #10 sequences are used.




🔌 Hardware Deployment (Zynq-7000)
Synthesize and Implement

Use Vivado to create a new project.

Import all Verilog modules.

Assign pins for buttons and LEDs based on your board’s constraint file (.xdc).

Connect Inputs/Outputs

Map buttons to physical pins (SWs or push buttons).

Map led[7:0] to 8 user LEDs.

Generate Bitstream

Program the FPGA with the synthesized design.

Use the board

Hold a button for ~10 clock cycles (or a few milliseconds depending on clock freq) to cast a vote.

Switch to view mode and press a button to see vote count for that candidate.

💡 Notes
This system ignores simultaneous button presses—only the first detected gets logged due to else if logic.

Clock frequency determines how long buttons need to be held. For a 50MHz clock, 10 clock cycles = 200ns. In real hardware, you may want to increase counter range to make it human-pressable (e.g., 1 million cycles = 20ms).

All modules are rising-edge triggered for synchronization.

🏁 Final Summary
This Verilog project:

Demonstrates modular FPGA design.

Emphasizes real-world considerations like input debouncing and mode switching.

Is fully synthesizable for a real FPGA (Zynq-7000), not just for simulation.

Teaches signal flow, instantiation, conditional logic, and testbench methodology.


