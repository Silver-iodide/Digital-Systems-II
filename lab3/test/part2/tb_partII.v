module tb_partII;

// Waveform I/O:
reg [7:0] I;
wire O2, O1, O0, v;
integer x, i, y;

// Instantiate design module Priority Encoder 8:3
PE83 test ( .SW(I[7:0]), .LEDR({O2, O1, O0, v}) ); 

initial begin
    for (i = 0; i < 10; i=i+1) begin
        x = $random % 256; 
        
        // assign the x into the wire
        // Change to x[7:0] if error occurs
        I[7:0] = x[7:0];
        
        #5;     // waiting for module respond

        // display the input and output
        $display ("Input = %b", x[7:0]);     // x is the input I7-I0
        $display ("Out = %b%b%b, valid bit = %b", O2, O1, O0, v); 
        // concatenate O2-O0 and store the value into y
        y = {O2, O1, O0};
        
        casex (x[7:0])

            8'b00000001: if ((y == 0) && (v == 1)) begin 
                $display("Test success!");
            end else begin
                $display("Test failed.");
            end

            8'b0000001x: if ((y == 1) && (v == 1)) begin 
                $display("Test success!");
            end else begin
                $display("Test failed.");
            end            
            
            8'b000001xx: if ((y == 2) && (v == 1)) begin 
                $display("Test success!");
            end else begin
                $display("Test failed.");
            end            
            
            8'b00001xxx: if ((y == 3) && (v == 1)) begin 
                $display("Test success!");
            end else begin
                $display("Test failed.");
            end            
            
            8'b0001xxxx: if ((y == 4) && (v == 1)) begin 
                $display("Test success!");
            end else begin
                $display("Test failed.");
            end            
            
            8'b001xxxxx: if ((y == 5) && (v == 1)) begin 
                $display("Test success!");
            end else begin
                $display("Test failed.");
            end            
            
            8'b01xxxxxx: if ((y == 6) && (v == 1)) begin 
                $display("Test success!");
            end else begin
                $display("Test failed.");
            end            
            
            8'b1xxxxxxx: if ((y == 7) && (v == 1)) begin 
                $display("Test success!");
            end else begin
                $display("Test failed.");
            end

	    default: if ((y == 0) && (v == 0)) begin 
                $display("Test success!");
            end else begin
                $display("Test failed.");
            end
        endcase

        #5; // next loop
    end
end

endmodule