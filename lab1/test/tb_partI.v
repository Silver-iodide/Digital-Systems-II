module tb_partI;

wire [9:0] LEDR;
wire [9:0] SW;
reg [2:0] count;
assign SW[2:0] = count;
 
partI UUT (.LEDR(LEDR), .SW(SW));

initial begin 
 count = 3'b000;
 repeat (8) begin
#100
$display("in = %b, out = %b", count, LEDR[0]);
count = count + 3'b001;
 end
end

endmodule