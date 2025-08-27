module signdiv(
    output [15:0] Quotient,
    output [15:0] Remainder,
    input St,
    input [15:0] Dbus,
    input CLK,
    input rst,
    output Rdy
);

// internal signals
wire C;         // sc_unit => control_unit
wire Su;        // control_unit => dividend
wire Sh;        // control_unit => dividend
wire Ld;        // control_unit => dividend
wire [1:0] Lc;    // control_unit => dividend & divisor
wire [16:0] curr_remainder;     // sc_unit => dividend
wire [16:0] remainder;          // dividend => sc_unit & output_unit
wire [15:0] quotient;           // dividend => output_unit
wire dividend_sign;             // dividend => output_unit
wire divisor_sign;              // divisor => output_unit
wire [15:0] curr_divisor;       // divisor => sc_unit


// module instantiation
control_unit controller(.rst(rst), .St(St), .C(C), .clk(CLK),
                        .Su(Su), .Sh(Sh), .Ld(Ld), .lc(Lc), .Rdy(Rdy) );

dividend dividend_unit( .Su(Su), .Sh(Sh), .Ld(Ld), .clk(CLK), .rst(rst), .Lc(Lc), .Dbus(Dbus), .curr_remainder(curr_remainder),
                        .Remainder(remainder), .Quotient(quotient), .dividend_sign(dividend_sign) );

divisor divisor_unit( .Dbus(Dbus), .Lc(Lc), .clk(CLK), .rst(rst),
                      .divisor_sign(divisor_sign), .curr_divisor(curr_divisor) );

subtract_compare_unit sc_unit(.Remainder(remainder), .curr_divisor(curr_divisor),
                              .C(C), .curr_remainder(curr_remainder) );

output_unit out_unit(.remainder(remainder), .quotient(quotient), .dividend_sign(dividend_sign), .divisor_sign(divisor_sign), 
                   .final_remainder(Remainder), .final_quotient(Quotient) );

endmodule
