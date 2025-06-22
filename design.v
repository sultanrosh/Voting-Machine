// =====================================
// MODULE: buttonControl
// Purpose: Detects if a button is held long enough to count as a valid vote
// =====================================

module buttonControl(
  input clock,                    // Clock signal
  input reset,                    // Reset signal
  input button,                   // Button input from user
  output reg valid_vote           // Output signal indicating if vote is valid
);

  reg [30:0] counter;             // 31-bit counter to count clock cycles while button is pressed

  // Counter logic
  always @(posedge clock) begin
    if (reset)                    // If reset is high, clear counter
      counter <= 0;
    else begin
      if (button && counter < 11)  // If button held and counter below threshold, increment
        counter <= counter + 1;
      else if (!button)            // If button released, reset counter
        counter <= 0;
    end
  end

  // Valid vote signal generation based on counter
  always @(posedge clock) begin
    if (reset)                    // Reset vote status if reset
      valid_vote <= 1'b0;
    else begin
      if (counter == 10)         // If button was held for 10 cycles, it's valid
        valid_vote <= 1'b1;
      else                       // Otherwise not valid
        valid_vote <= 1'b0;
    end
  end

endmodule

// Summary:
// This module detects when a button is pressed and held for exactly 10 clock cycles.
// Once that condition is met, it raises the `valid_vote` signal high for one cycle.


// =====================================
// MODULE: voteLogger
// Purpose: Logs valid votes per candidate, only in voting mode
// =====================================
module voteLogger(
  input clock,                          // Clock signal
  input reset,                          // Reset signal
  input mode,                           // Mode: 0 = voting mode, 1 = viewing mode
  input cand1_vote_valid,              // Vote validity signal for candidate 1
  input cand2_vote_valid,              // Vote validity signal for candidate 2
  input cand3_vote_valid,              // Vote validity signal for candidate 3
  input cand4_vote_valid,              // Vote validity signal for candidate 4
  output reg [7:0] cand1_vote_recvd,   // Vote count for candidate 1
  output reg [7:0] cand2_vote_recvd,   // Vote count for candidate 2
  output reg [7:0] cand3_vote_recvd,   // Vote count for candidate 3
  output reg [7:0] cand4_vote_recvd    // Vote count for candidate 4
);

  always @(posedge clock) begin
    if (reset) begin                   // On reset, clear all vote counters
      cand1_vote_recvd <= 0;
      cand2_vote_recvd <= 0;
      cand3_vote_recvd <= 0;
      cand4_vote_recvd <= 0;
    end
    else if (mode == 0) begin         // Only allow counting in vote mode (mode == 0)
      if (cand1_vote_valid)
        cand1_vote_recvd <= cand1_vote_recvd + 1;
      else if (cand2_vote_valid)
        cand2_vote_recvd <= cand2_vote_recvd + 1;
      else if (cand3_vote_valid)
        cand3_vote_recvd <= cand3_vote_recvd + 1;
      else if (cand4_vote_valid)
        cand4_vote_recvd <= cand4_vote_recvd + 1;
    end
  end

endmodule

// Summary:
// This module listens for valid vote signals and increments vote counts
// for the appropriate candidate, only when in voting mode.


// =====================================
// MODULE: modeControl
// Purpose: Controls LED output depending on mode and vote state
// =====================================
module modeControl(
  input clock,                            // Clock signal
  input reset,                            // Reset signal
  input mode,                             // 0 = vote mode, 1 = view mode
  input valid_vote_casted,                // Signal that a valid vote was cast
  input [7:0] candidate1_vote,            // Vote count for candidate 1
  input [7:0] candidate2_vote,            // Vote count for candidate 2
  input [7:0] candidate3_vote,            // Vote count for candidate 3
  input [7:0] candidate4_vote,            // Vote count for candidate 4
  input candidate1_button_press,         // Button press flag for viewing candidate 1
  input candidate2_button_press,         // Button press flag for viewing candidate 2
  input candidate3_button_press,         // Button press flag for viewing candidate 3
  input candidate4_button_press,         // Button press flag for viewing candidate 4
  output reg [7:0] leds                   // Output to LED display
);

  reg [30:0] counter;                    // Counter for flashing effect duration

  always @(posedge clock) begin
    if (reset)
      counter <= 0;
    else if (valid_vote_casted)         // Start counter on valid vote
      counter <= 1;
    else if (counter != 0 && counter < 10) // Keep counting to show LED feedback
      counter <= counter + 1;
    else
      counter <= 0;
  end

  always @(posedge clock) begin
    if (reset)
      leds <= 0;
    else begin
      if (mode == 0 && counter > 0)
        leds <= 8'hFF;                  // Flash all LEDs when a vote is cast
      else if (mode == 0)
        leds <= 8'h00;                  // Turn off LEDs if no recent vote
      else if (mode == 1) begin         // View mode logic
        if (candidate1_button_press)
          leds <= candidate1_vote;
        else if (candidate2_button_press)
          leds <= candidate2_vote;
        else if (candidate3_button_press)
          leds <= candidate3_vote;
        else if (candidate4_button_press)
          leds <= candidate4_vote;
      end
    end
  end

endmodule

// Summary:
// This module controls how the LEDs behave depending on the mode and votes.
// In vote mode, it flashes all LEDs briefly when a vote is cast.
// In view mode, it displays the vote count for the selected candidate.


// =====================================
// MODULE: votingMachine
// Purpose: Top-level module wiring everything together
// =====================================
module votingMachine(
  input clock,                    // Clock signal
  input reset,                    // Reset signal
  input mode,                     // System mode: 0 = vote, 1 = view
  input button1,                  // Button for candidate 1
  input button2,                  // Button for candidate 2
  input button3,                  // Button for candidate 3
  input button4,                  // Button for candidate 4
  output [7:0] led                // Output to LEDs
);

  // Signals to track valid votes from each button
  wire valid_vote_1;             // Valid vote from button 1
  wire valid_vote_2;             // Valid vote from button 2
  wire valid_vote_3;             // Valid vote from button 3
  wire valid_vote_4;             // Valid vote from button 4

  // Signals to track vote counts per candidate
  wire [7:0] cand1_vote_recvd;   // Vote count for candidate 1
  wire [7:0] cand2_vote_recvd;   // Vote count for candidate 2
  wire [7:0] cand3_vote_recvd;   // Vote count for candidate 3
  wire [7:0] cand4_vote_recvd;   // Vote count for candidate 4

  // Combine all valid vote signals to detect any vote cast
  wire anyValidVote = valid_vote_1 | valid_vote_2 | valid_vote_3 | valid_vote_4;
  // This is used by modeControl to trigger LED feedback

  // Instantiate each buttonControl module
  // Each handles debounce and timing for one button input
  buttonControl bc1(.clock(clock), .reset(reset), .button(button1), .valid_vote(valid_vote_1));
  buttonControl bc2(.clock(clock), .reset(reset), .button(button2), .valid_vote(valid_vote_2));
  buttonControl bc3(.clock(clock), .reset(reset), .button(button3), .valid_vote(valid_vote_3));
  buttonControl bc4(.clock(clock), .reset(reset), .button(button4), .valid_vote(valid_vote_4));

  // Instantiate the voteLogger
  // Tracks how many votes each candidate has received
  voteLogger VL(
    .clock(clock),
    .reset(reset),
    .mode(mode),
    .cand1_vote_valid(valid_vote_1),
    .cand2_vote_valid(valid_vote_2),
    .cand3_vote_valid(valid_vote_3),
    .cand4_vote_valid(valid_vote_4),
    .cand1_vote_recvd(cand1_vote_recvd),
    .cand2_vote_recvd(cand2_vote_recvd),
    .cand3_vote_recvd(cand3_vote_recvd),
    .cand4_vote_recvd(cand4_vote_recvd)
  );

  // Instantiate the modeControl
  // Controls LED display logic depending on system mode and vote actions
  modeControl MC(
    .clock(clock),
    .reset(reset),
    .mode(mode),
    .valid_vote_casted(anyValidVote),
    .candidate1_vote(cand1_vote_recvd),
    .candidate2_vote(cand2_vote_recvd),
    .candidate3_vote(cand3_vote_recvd),
    .candidate4_vote(cand4_vote_recvd),
    .candidate1_button_press(valid_vote_1),
    .candidate2_button_press(valid_vote_2),
    .candidate3_button_press(valid_vote_3),
    .candidate4_button_press(valid_vote_4),
    .leds(led)
  );

endmodule

// Summary:
// This is the top-level module that wires together button control, vote logging,
// and LED display logic. It creates signal wires to connect the submodules and
// controls the flow of information for a complete voting machine on FPGA.
