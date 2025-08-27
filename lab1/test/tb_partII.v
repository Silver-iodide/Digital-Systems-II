module tb_partII;
wire [9:0] SW;
wire [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
reg [3:0] curr_input; 

assign SW[3:0] = curr_input;

partII UUT (.SW(SW), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), 
    .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5)
    );

initial begin
    curr_input = 4'b0000;
    repeat (16) begin
    #100
    $display("input = %b, out_hex1 = %b, out_hex0 = %b", curr_input, HEX1, HEX0);
    curr_input = curr_input + 4'b0001; 
    end

end
endmodule