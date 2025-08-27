

// Carry ripple adder
// k-bit inputs - a, b
// (k+1) bit output - out
module generic_adder
	#(parameter K = 6) (
	input [K-1:0] a, b, 
	output wire [K:0] out 
	);
	
	
	wire [K:0] carry; 	
	wire [K:0] s_out; 
	genvar i; 
	
	assign carry[0] = 0;

	generate
	for (i=0; i<K; i=i+1) begin : adder_block
	full_adder adder_i (.a(a[i]), .b(b[i]), .cin(carry[i]), .cout(carry[i+1]), .s(out[i]));
	
	end
	endgenerate
	
	assign out[K] = carry[K]; 
	
endmodule
