module prime ( in , isprime );
    input [3:0] in; // 4 - bit input
    output isprime; // true if input is prime
    reg isprime;
    
    always @ (in) begin
        case (in)
        1, 2, 3, 5, 7, 13: isprime = 1'b1;
        default : isprime = 1'b0;
        endcase
    end
endmodule

// the design module:
// Input: in - 4-bit
// Output: isprime - 1 bit
// We will only need to test from 0 - 15 as this is the input range.
// Definition of a prime number: have only 2 factors: 1 and themselves

module prime_tb();

reg [3:0] in;
wire isprime;
integer j;

prime p(in, isprime);

initial begin
    for (in = 0; in < 16; in = in+1) begin
        #10;

        case(in)
        // corner case
        0, 1: begin
            if (isprime == 1) begin 
                $display("Error: 0 or 1 is not a prime number!");
        end 
        end
        2:  begin
            if (isprime == 0) begin 
                $display("Error: 2 is a prime number!");
        end 
        end

        // common cases
        default: begin
            for (j = 2; j < in; j = j+1) begin
                if ((isprime == 1) && ((in % j) == 0)) begin
                    $display("Error: %d is not a prime number", in);
                end
            end
        end

        endcase

        $display("Test passed!");
        #10;
        $finish;
        
    end
end
endmodule