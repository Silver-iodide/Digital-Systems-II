// Divisor unit:
// Inputs:
    // [15:0] Dbus - data bus 
    // [1:0] Lc - load counter from control unit
    // clk - clock
    // rst
// Outputs:
    // divisor_sign - sign check
    // [15:0] curr_divisor - divisor, go to subtract_compare_unit
module divisor(
    input [15:0] Dbus,
    input [1:0] Lc,
    input clk,
    input rst,
    output reg divisor_sign,
    output reg [15:0] curr_divisor
);


always @(posedge clk or posedge rst) begin
    if (rst) begin
        curr_divisor <= 16'h0000;
    end 
    else if (Lc == 3) begin
        if (Dbus[15] == 1) begin
            divisor_sign <= 1;
            curr_divisor <= (~Dbus) + 1;
        end else begin
            curr_divisor <= Dbus;
            divisor_sign <= 0; 
        end
    end
end

endmodule