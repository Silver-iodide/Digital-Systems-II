

// Carry ripple adder
// k-bit inputs - a, b
// (k+1) bit output - out
module generic_adder
	#(parameter K = 6) (
	input [K-1:0] a, b, 
	output [K:0] out 
	);
	