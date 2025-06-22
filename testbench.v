

  // Test stimulus block
  // Applies a series of button presses and mode changes to simulate voting
  initial begin
    // Initial state: Apply reset and clear buttons
    reset = 1; mode = 0; button2 = 0; button3 = 0; button4 = 0; #100; // Hold reset initially
    
    // Deassert reset and test button1 (Candidate 1)
    // NOTE: Each #number is a delay (e.g., #5 means wait 5ns before executing the next line)
    // To register a valid vote, the button must be held high for at least 10 clock cycles (100ns)


    #100 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0; // Release reset
    #5 reset = 0; mode = 0; button1 = 1; button2 = 0; button3 = 0; button4 = 0;   // Short press (invalid)
    #10 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;  // Release
    #5 reset = 0; mode = 0; button1 = 1; button2 = 0; button3 = 0; button4 = 0;   // Long press (valid)
    #200 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0; // Release
    #5 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;   // Idle
    #10 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;  // Idle
    #5 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;   // Idle

    #5 reset = 0; mode = 0; button1 = 0; button2 = 1; button3 = 0; button4 = 0;   // Valid vote for candidate 2
    #200 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0; // Release
    #5 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;   // Idle
    #10 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;  // Idle
    #5 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;   // Idle

    #5 reset = 0; mode = 0; button1 = 0; button2 = 1; button3 = 1; button4 = 0;   // Simultaneous press
    #200 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0; // Release
    #5 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;   // Idle
    #10 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;  // Idle
    #5 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;   // Idle

    #5 reset = 0; mode = 1; button1 = 0; button2 = 1; button3 = 0; button4 = 0;   // View vote count for candidate 2
    #200 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0; // Back to vote mode
    #5 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;   // Idle
    #10 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;  // Idle
    #5 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;   // Idle

    #5 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 1; button4 = 0;   // Valid vote for candidate 3
    #200 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0; // Release
    #5 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;   // Idle
    #10 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;  // Idle
    #5 reset = 0; mode = 0; button1 = 0; button2 = 0; button3 = 0; button4 = 0;   // Idle

    $finish; // End simulation
  end

  // Dump waveform for analysis
  initial begin
    $dumpfile("dump.vcd");                // Name of VCD file
    $dumpvars(0, test);                    // Dump variables from test module
  end

  // Display signal values at each timestep
  initial
    $monitor($time,
             " mode = %b, button1 = %b, button2 = %b, button3 = %b, button4 = %b, led = %d",
             mode, button1, button2, button3, button4, led);

endmodule
