// Output unit:
// This unit is for converting the unsigned results into the actual signed result
// based on the original dividend and divisor sign. 

/*************************************************
// Case (dividend and divisor are positive):
    // remains the same

// Case (dividend < 0, divisor > 0):
    // quotient = ~quotient + 1;
    // remainder = ~remainder + 1;

// Case (dividend > 0, divisor < 0):
    // quotient = ~quotient + 1;
    // remainder remains;

// Case (all negative):
    // quotient remains;
    // remainder = ~remainder + 1; 
**************************************************/
// Inputs:
    // [16:0] remainder
    // [15:0] quotient
    // dividend_sign
    // divisor_sign
// Outputs:
    // [15:0] final_remainder - modified for testbench
    // [15:0] final_quotient
module output_unit(
    input [16:0] remainder,
    input [15:0] quotient,
    input dividend_sign, divisor_sign,  // 1 => negative, 0 > positive
    output reg [15:0] final_remainder,
    output reg [15:0] final_quotient
);


always @(*) begin
    
    case({dividend_sign, divisor_sign})
        2'b00: begin
            final_quotient = quotient;
            final_remainder = remainder[15:0];
        end

        2'b10: begin
            final_quotient = (~quotient) + 1;
            final_remainder = (~remainder[15:0]) + 1;
        end

        2'b01: begin
            final_quotient = (~quotient) + 1;
            final_remainder = remainder[15:0];
        end

        2'b11: begin
            final_quotient = quotient;
            final_remainder = (~remainder[15:0]) + 1; 
        end

    endcase
end

endmodule