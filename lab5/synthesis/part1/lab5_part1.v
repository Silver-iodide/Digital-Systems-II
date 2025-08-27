
module lab5_part1(

	//////////// SEG7 //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW
);


//  REG/WIRE declarations
wire write_en;
wire ram_select;	// if ram_select = 0, select ram0 for writing; else, select ram1
wire clk;
wire [3:0] addr;	// also being displayed in HEX3
wire [3:0] new_data;	// also being displayed in HEX2
wire [3:0] ram1_data;				// also being displayed in HEX1
wire [3:0] ram0_data; 			// also being displayed in HEX0


//  Structural coding
assign write_en = SW[9];
assign ram_select = SW[8];
assign clk = KEY[0];
assign addr[3:0] = SW[7:4];
assign new_data[3:0] = SW[3:0]; 
assign ram1_en = write_en & ram_select;
assign ram0_en = write_en & (~ram_select);

// ram has been initialized with all 1's in every bit
ram ram1(.clk(clk), .addr(addr), .mwr(ram1_en), .mdi(new_data), .mdo(ram1_data));
ram ram0(.clk(clk), .addr(addr), .mwr(ram0_en), .mdi(new_data), .mdo(ram0_data));

hex_decoder hex3(.b3(addr[3]), .b2(addr[2]), .b1(addr[1]), .b0(addr[0]), .x(HEX3));
hex_decoder hex2(.b3(new_data[3]), .b2(new_data[2]), .b1(new_data[1]), .b0(new_data[0]), .x(HEX2));
hex_decoder hex1(.b3(ram1_data[3]), .b2(ram1_data[2]), .b1(ram1_data[1]), .b0(ram1_data[0]), .x(HEX1));
hex_decoder hex0(.b3(ram0_data[3]), .b2(ram0_data[2]), .b1(ram0_data[1]), .b0(ram0_data[0]), .x(HEX0));



endmodule
