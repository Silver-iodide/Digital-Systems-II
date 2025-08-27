module counter(
    input rst,
    input clk,
    output reg [1:0] state
);

reg [1:0] next_state;

localparam S0 = 2'b00;
localparam S1 = 2'b11;
localparam S2 = 2'b10;
localparam S3 = 2'b01;

// sequential logic
always @(posedge clk or posedge rst) begin
    if (rst == 1) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// combinational logic
always @(*) begin
    case(state)
    
    S0: begin
        next_state = S1;
    end

    S1: begin
        next_state = S2;
    end

    S2: begin
        next_state = S3;
    end

    S3: begin
        next_state = S0;
    end

    endcase
end

endmodule


module counter_tb();

reg clk;
reg rst;
wire [1:0] state;

initial clk =0;

always begin
    #5; clk = ~clk;
end

counter c(rst, clk, state);

initial begin
    $monitor("Current state: %d", state);

    rst = 1; 
    #10;

    rst = 0;

    #100;

    $finish;
end


endmodule