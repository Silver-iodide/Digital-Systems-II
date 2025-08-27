module tb_partIII();
// change these settings to accomodate different bits
// reg [K-1:0] a, b;
// wire [K:0] out;

parameter K = 7;

reg [K-1:0] a, b; 
wire [K:0] out; 
integer i, j; 

//default parameter K = 6

generic_adder #(K) whatever_bit (.a(a), .b(b), .out(out));

// Check whether out = a+b
initial begin
for (i = 0; i < (1 << K); i = i+1) begin
    for (j = 0; j < (1 << K); j = j+1) begin
        a = i;
        b = j; 
        #5;
        if (out != a+b)
            $display("Error! a = %b, b = %b, output = %b", a, b, out); 
        #5;
    end
end
// #10 $finish;
end

endmodule