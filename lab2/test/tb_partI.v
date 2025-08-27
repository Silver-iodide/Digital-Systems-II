module tb_partI();

// define the I/O needed
reg [15:0] test;    //split inputs with test[15:8] and test [7:0]
reg cin;            //always set to 0
wire [7:0] s;
wire cout;
wire overflow;

integer i;


// instantiate the module
Part1 Check (.A(test[15:8]), .B(test[7:0]), .cin(cin), .S(s), .cout(cout), .Overflow(overflow));

// plug in data - A, B, cin - into the module 
initial begin 
    cin = 0;
    for (i = 0; i < (1 << 16); i = i + 1) begin
        test = i;
        #5;
        if ({cout, s} != (test[15:8] + test[7:0]))
            $display("Error! A = %b, B = %b, sum = %b, cout = %b, overflow = %b", test[15:8], test[7:0], s, cout, overflow);
        if ((overflow == 1) && (cout == s[7])) begin
            $display("Overflow check failed! A = %b, B = %b, sum = %b, cout = %b, overflow = %b", test[15:8], test[7:0], s, cout, overflow);            
        end
        #5;
    end
    #10 $finish;
    
end
// Check the result - S & cout - equals to A+B+cin
// If not, print Error and I/O value

// If Overflow equals to 1, check whether cout and S[7] are the same
// If they are the same, print error and the I/O value
endmodule