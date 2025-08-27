// Calculation unit: subtract and compare the remainder and divisor. 
// If remainder < divisor, output C = 0 to control unit; else, C = 1
// Input: 
    // [16:0] Remainder - from dividend unit
    // [15:0] curr_divisor - from divisor unit
// Outputs:
    // C - go to control unit
    // [16:0] curr_remainder - go to dividend unit
module subtract_compare_unit(
    input [16:0] Remainder,
    input [15:0] curr_divisor,
    output reg C,
    output reg [16:0] curr_remainder
);


// subtractor 
always @(*) begin
    curr_remainder = Remainder - curr_divisor; 
end

// comparator
always @(*) begin
    if (Remainder < curr_divisor) begin
        C = 0;
    end else begin
        C = 1;
    end
end

endmodule