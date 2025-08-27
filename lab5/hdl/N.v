// N module:
// Input: 
    // [7:0] N: The original number which will be used to calculate its square root
    // subtractor_in - input value from the subtractor unit
    // Load - load 'N' into this register
    // Su - load the subtractor result into this register
    // clk - clock signal
// Output:
    // [7:0] curr_val - current register value

module N(
    input clk,
    input [7:0] N,
    input [7:0] subtractor_in,
    input Load,
    input Su, 
    output reg [7:0] curr_val
);

/*
Sequential Logic:
If load has been pressed, N will be loaded into the register;
Else if Su is pressed, subtractor's output will be loaded instead;
Else, the register remains its value
*/
always @(posedge clk) begin
    
    if (Load) begin
        curr_val <= N;
    end else if (Su) begin
        curr_val <= subtractor_in;
    end
end

endmodule