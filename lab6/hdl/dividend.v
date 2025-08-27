// Dividend unit:
// Inputs: 
    // [15:0] Dbus - data bus 
    // [16:0] curr_remainder - from subtract_compare_unit
    // [1:0] Lc - load counter from control unit
    // Su - write enable 
    // Sh - shift left enable
    // Ld - load enable
    // clk - clock
    // rst - reset D's value
// Outputs:
    // Remainder - upper 17 bits, go to output unit
    // Quotient - lower 16 bits, go to output unit
    // dividend_sign - go to output unit
module dividend(
    input Su, Sh, Ld, clk, rst,
    input [1:0] Lc,
    input [15:0] Dbus,
    input [16:0] curr_remainder,
    output [16:0] Remainder,
    output [15:0] Quotient,
    output reg dividend_sign
);

reg [32:0] D;

// Sequential Logic
// If load signal = 1, load Dbus into D
// If shift signal = 1, left shift D 
// If update signal = 1, update [32:16] D with curr_remainder and D[0] = 1;
always @(posedge clk or posedge rst) begin

    if (rst) begin
        D <= 33'h000000000;     // clear D register
    end

    else if ((Ld == 1) && (Lc == 1)) begin
        
        if (Dbus[15] == 1) begin
            // negative, set dividend sign into 1 for future sign check
            dividend_sign <= 1;
            D[31:16] <= ~Dbus;
        end else begin
            // positive
            D[31:16] <= Dbus;
            dividend_sign <= 0; 
        end
    end 
    
    else if ((Ld == 1) && (Lc == 2)) begin
        
        if (dividend_sign == 1) begin
            D[15:0] <= (~Dbus) + 1; 
            // Check whether there is a carry out bit
            // if yes, then update the upper 16 bit of D by adding 1 as well
            if (((~Dbus) + 1) == 0) begin
                D[31:16] <= D[31:16] + 1;
            end
        end else begin
            D[15:0] <= Dbus;
        end
    end 
    
    else if (Sh == 1) begin
        D[32:1] <= D[31:0];
        D[0] <= 0;
    end
    
    else if (Su == 1) begin
        D[32:16] <= curr_remainder; 
        D[0] <= 1; 
    end

end

assign Remainder = D[32:16];
assign Quotient = D[15:0];
endmodule