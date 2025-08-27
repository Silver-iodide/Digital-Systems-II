module ripple_carry_adder_8bit(
    input [7:0] A, B,
	 input cin,  // Carry in
	 output [7:0] S,  // Sum
	 output cout,  //  Carry out
	 output Overflow
);

    wire [7:0] carry;
	 
	 full_adder FA0(A[0], B[0], cin, S[0], carry[0]);
	 full_adder FA1(A[1], B[1], carry[0], S[1], carry[1]);
	 full_adder FA2(A[2], B[2], carry[1], S[2], carry[2]);
	 full_adder FA3(A[3], B[3], carry[2], S[3], carry[3]);
	 full_adder FA4(A[4], B[4], carry[3], S[4], carry[4]);
	 full_adder FA5(A[5], B[5], carry[4], S[5], carry[5]);
	 full_adder FA6(A[6], B[6], carry[5], S[6], carry[6]);
	 full_adder FA7(A[7], B[7], carry[6], S[7], carry[7]);
	 //Overflow : Carry in XOR Carry out
	 //assign Overflow = carry[6] ^ cout;
	 assign Overflow = carry[6] ^ carry[7];
	 assign cout = carry[7];
	 
endmodule
	 

// Todo: 
// 1. Carry in always 0;
// 2. 

module full_adder(
    input a,b,ci,
    output s,c0
);

    assign s = a ^ b ^ci;
	 assign c0 = (a & b) | (a & ci) | (b & ci);
	 
endmodule
