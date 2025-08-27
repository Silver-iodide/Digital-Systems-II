// Top level module for the square root unit 
// Input:
    // Clock
    // ResetN - when ResetN == 0, the reset has been activated
    // St - start the square root calculation
    // [7:0] N - the number needs to be calculated
// Output:
    // Done - equals 1 when the calculation finishes
    // [3:0] Sqrt - the calculation result 
module square_root_unit(
    input Clock, ResetN, St,
    input [7:0] N, 

    output Done,
    output [3:0] Sqrt,
	 output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2
);

wire B;
wire Load, Su, Inc, rst;
wire [7:0] subtractor_out;
wire [7:0] N_out;
wire [4:0] odd_num;

controller ctrl_unit(.St(St), .B(B), .Rst(ResetN), .clk(Clock), .Load(Load), .Su(Su), .Inc(Inc), .rst(rst), .Done(Done));
N N_unit(.clk(Clock), .N(N), .subtractor_in(subtractor_out), .Load(Load), .Su(Su), .curr_val(N_out));
subtractor subtractor_unit(.N_in(N_out), .curr_num(odd_num), .next_N(subtractor_out), .B(B));
square_root squareroot_unit(.Inc(Inc), .clk(Clock), .rst(rst), .curr_num(odd_num));

//assign Sqrt = odd_num[4:1];

hex_decoder hex0(.x(Sqrt),         .seg(HEX0));
hex_decoder hex1(.x(N[3:0]),       .seg(HEX1));
hex_decoder hex2(.x(N[7:4]),       .seg(HEX2));

assign Sqrt = odd_num[4:1];

endmodule