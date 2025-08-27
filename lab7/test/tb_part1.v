module tb_part1;

    parameter K = 8;
    parameter N = 4;

    reg clk, clr, wrreq, rdreq;
    reg [K-1:0] d;
    wire [K-1:0] q;
    wire full, empty;
    wire [$clog2(N):0] usedw;

    fifo #(.K(K), .N(N)) dut (
        .clk(clk),
        .rst(clr),
        .write(wrreq),
        .read(rdreq),
        .din(d),
        .dout(q),
        .full(full),
        .empty(empty),
        .D(usedw)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        $display("Time\t wrreq\t rdreq\t d\t q\t full\t empty\t usedw");
        $monitor("%0t\t %b\t %b\t %d\t %d\t %b\t %b\t %d",
            $time, wrreq, rdreq, d, q, full, empty, usedw);

        clr = 1; wrreq = 0; rdreq = 0; d = 0;
        // Time 0 ---------------------------------------------
        #10 clr = 0;

        // Fill FIFO to full
        repeat (N) begin
            @(negedge clk); // First time Time 10 -------------
            wrreq = 1;
            d = d + 1;
        end

        @(negedge clk);
        // Time 50 --------------------------------------------
        wrreq = 1;  // Try to write when full
        d = 99;

        @(negedge clk);     // Time 60 ------------------------
        wrreq = 0;

        // Read all elements
        repeat (N) begin
            @(negedge clk); // First time Time 70 -------------
            rdreq = 1;
        end

        @(negedge clk);
        rdreq = 1; // Try to read when empty

        @(negedge clk);
        rdreq = 0;

        // Interleaved write/read
        repeat (3) begin
            @(negedge clk);
            wrreq = 1;
            d = d + 1;
            rdreq = 1;
        end

        @(negedge clk);
        wrreq = 0;
        rdreq = 0;

        #20 $finish;
    end

endmodule
