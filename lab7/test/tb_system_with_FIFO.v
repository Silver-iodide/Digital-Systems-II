`timescale 1ns/1ps

module tb_system_with_FIFO;

    // Parameters
    parameter K = 4;
    parameter N = 4;
    parameter M = 6;

    // DUT ports
    reg write_clk, read_clk, rst;
    wire [$clog2(N):0] dataNum_in_FIFO;

    // Instantiate DUT
    system_with_FIFO #(K, N, M) DUT (
        .write_clk(write_clk),
        .read_clk(read_clk),
        .rst(rst),
        .dataNum_in_FIFO(dataNum_in_FIFO)
    );

    // Default (can be overridden in each experiment block)
    real WRITE_HALF_PERIOD = 5;  // 10ns full period
    real READ_HALF_PERIOD  = 5;

    // Clock generators
    initial write_clk = 0;
    initial read_clk = 0;
    always #(WRITE_HALF_PERIOD) write_clk = ~write_clk;
    always #(READ_HALF_PERIOD)  read_clk  = ~read_clk;

    // Clock period control macros
    `define RUN_DURATION 180  // ns per experiment


    // Monitor key info
    initial begin
        $display("Time\t#FIFO Items");
        $monitor("%0t\t%d", $time, dataNum_in_FIFO);
    end

    // Run Experiments
    initial begin
        // Experiment 1: Same frequency
        $display("=== Experiment 1: Same clock frequency ===");
        WRITE_HALF_PERIOD = 5;  // 100MHz
        READ_HALF_PERIOD  = 5;
        rst = 1;
        #20 rst = 0;
        #`RUN_DURATION;

        // Experiment 2: Read clock 2x faster
        $display("=== Experiment 2: Read 2x faster than write ===");
        rst = 1;
        WRITE_HALF_PERIOD = 10;  // 50MHz
        READ_HALF_PERIOD  = 5;   // 100MHz
        #20 rst = 0;
        #`RUN_DURATION;

        // Experiment 3: Write clock 2x faster than read
        $display("=== Experiment 3: Write 2x faster than read ===");
        rst = 1;
        WRITE_HALF_PERIOD = 5;   // 100MHz
        READ_HALF_PERIOD  = 10;  // 50MHz
        #20 rst = 0;
        #`RUN_DURATION;

        $display("=== All experiments complete ===");
        $finish;
    end

endmodule
