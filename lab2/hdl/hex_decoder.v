
// 4-input 1-hex-output converter
module hex_decoder(

	input b3, 
	input b2, 
	input b1,  
	input b0, 
	
	output [7:0] x
);

assign x[0] = ((~b3) & (~b2) & (~b1) & b0) |
(b3 & (~b2) & b1 & b0) |
(b3 & b2 & (~b1)) |
(b2 & (~b1) & (~b0));

assign x[1] = (b3 & b1 & b0) |
((~b3) & b2 & (~b1) & b0) |
(b2 & b1 & (~b0)) |
(b3 & b2 & (~b1) & (~b0));

assign x[2] = ((~b3) & (~b2) & b1 & (~b0)) |
(b3 & b2 & b1) |
(b3 & b2 & (~b0));

assign x[3] = ((~b3) & (~b2) & (~b1) & b0) |
((~b3) & b2 & (~b1) & (~b0)) |
(b2 & b1 & b0);

assign x[4] = ((~b3) & b0) |
((~b3) & b2 & (~b1)) |
((~b2) & (~b1) & b0);

assign x[5] = (b3 & b2 & (~b1)) |
((~b3) & (~b2) & b0) |
((~b3) & b1 & b0) |
((~b2) & b1 & (~b0));

assign x[6] = ((~b3) & b2 & b1 & b0) |
((~b3) & (~b2) & (~b1)); 

assign x[7] = 1; 
endmodule
