// Things changed:
// reset signal being added, and simulate the reset as follows: 
// #0 - reset = 1; # 5 - reset = 0
module lab4_tb;

  // Inputs
  reg clk;
  reg a;
  reg b;
  reg rst; 

  // Output
  wire unlock;

  // Instantiate the Unit Under Test (UUT)
  
mealy_fsm  uut (
    .clk(clk),
    .a(a),
    .b(b),
    .rst(rst),
    .unlock(unlock)
  );

  // Clock generation: 10ns period
  always #5 clk = ~clk;

  // Test sequence
  initial begin
    // Initialize inputs
    clk = 0;
    a = 0;
    b = 0;
    rst = 1;
    // Hold reset-like idle state for a bit
    #5;
    rst = 0; #15; 

    $display("Starting Test 1: Correct unlock sequence...");

    // Cycle 1: a = 1, b = 0
    a = 1; b = 0; #10;
    a = 0; b = 0; #10;

    // Cycle 2: a = 0, b = 1
    a = 0; b = 1; #10;
    a = 0; b = 0; #10;

    // Cycle 3: a = 1, b = 0
    a = 1; b = 0; #10;
    a = 0; b = 0; #10;

    // Cycle 4: a = 1, b = 0 -> unlock expected
    a = 1; b = 0; #10;

    if (unlock !== 1) begin
      $error("FAILED: Unlock should be HIGH after correct sequence.");
    end else begin
      $display("PASSED: Unlock correctly asserted.");
    end

    // Wait in unlocked state
    a = 0; b = 0; #10;

    // Trigger reset by setting any input high
    a = 1; b = 0; #10;

    if (unlock !== 0) begin
      $error("FAILED: Unlock should be LOW after input high post-unlock.");
    end else begin
      $display("PASSED: Unlock correctly de-asserted.");
    end

    // Additional test: incorrect sequence
    $display("Starting Test 2: Incorrect sequence...");

    a = 1; b = 0; #10;
    a = 0; b = 1; #10;  // Skipping the required 00 cycle here!
    a = 1; b = 0; #10;
    a = 0; b = 0; #10;
    a = 1; b = 0; #10;

    if (unlock !== 0) begin
      $error("FAILED: Unlock should remain LOW for incorrect sequence.");
    end else begin
      $display("PASSED: Unlock correctly stayed LOW for bad sequence.");
    end

    // Todo: add two more test cases:
    // One that checks for the valid input/output
    // One for an invalid input/output 
    $display("Two more test cases being added.");
    $display("Test 3 for valid input:"); 
    
    // press reset to return to S0
    rst = 1; #5;
    rst = 0; #5;

    // We will still insert a-b-a-a sequence, but this time, 
    // there will be more cycles of both input low between the input sequences,
    // and each element of the sequences will last for more cycles as well. 

    // Cycle 1: a = 1, b = 0
    a = 1; b = 0; #20;
    a = 0; b = 0; #30;

    // Cycle 2: a = 0, b = 1
    a = 0; b = 1; #20;
    a = 0; b = 0; #30;

    // Cycle 3: a = 1, b = 0
    a = 1; b = 0; #20;
    a = 0; b = 0; #30;

    // Cycle 4: a = 1, b = 0 -> unlock expected
    a = 1; b = 0; #20;

    if (unlock == 1) begin
      $display("Passed: unlock correctly asserted with more cycles between the sequence elements.");
    end else begin
      $display("Failed: unlock remains low with more cycles between the sequence elements.");
    end

    a = 0; b = 1; #10; // make the state returns to S0, ready for the next testcase

    $display("Test 4 for the invalid input: ");
    // Blitzkrieg! a-b-a-a appear near one another without any cycles between sequence elements

    a = 1; b = 0; #10;
    a = 0; b = 1; #10;
    a = 1; b = 0; #10;
    a = 1; b = 0; #10;

    // Check the unlock
    if (unlock == 0) begin
      $display("Passed: lightning war failed :( ");
    end else begin
      $display("Failed: lightning war success! XD");
    end

    $display("All tests completed. Robust!");
    $finish;
  end

endmodule
