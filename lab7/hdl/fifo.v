// Tail pointer - write address
// Head pointer - Read address
// head chasing tail - read address chasing write address

/*
* Algorithm:
* If write request & not full:  
*       write din into the current write address; 
*       update D <= D + 1;
*       update write address: If write_addr == N - 1: write_addr <= 0; else: write_addr <= write_addr + 1; 
*       
* If read request & not empty:
*       send current RAM data into dout:    dout <= ram[read_addr];
*       update D <= D - 1;
*       update read address: If read_addr == N - 1: read_addr <= 0; else: read_addr <= read_addr + 1; 


* Empty, Full, and D logic:
*       Empty & Full are Combinational logic:
*           If D = 0, empty = 1; else: empty = 0;
*           If D = N, full = 1; else: full = 0; 
*
*       D is Sequential logic: 
*           +1 if write a data, -1 if read a data
*           In this way, the D will be correct before the next cycle, so empty and full will be correct as well.
*           This is for easier design of 'Consumer' module
*/
module fifo
#(parameter K = 8, parameter N = 4)
(
    input clk, rst, read, write, 
    input [K-1:0] din, 
    output reg [K-1:0] dout, 
    output reg full, empty, 
    output [$clog2(N):0] D      // How many data loaded in the RAM
);

    // Declare the RAM variable
	reg [K-1:0] ram[N-1:0];
    reg [$clog2(N):0] write_addr;
    reg [$clog2(N):0] read_addr;
    // Just make sure the FIFO will work in the limited write and read operation
    reg [7:0] write_count; 
    reg [7:0] read_count;


// Sequential Logic for read & write request

    // Will be the write clock later
    always @ (posedge clk or posedge rst) begin

        if (rst) begin
            // Here we need to make the write_addr pointing to the original ram location (0 in this case)
            // Also initialize write_count to 0
            write_addr <= 0; 
            write_count <= 0; 
        end

		else if (write && (!full)) begin

			ram[write_addr] <= din;
            write_count <= write_count + 1;
            if (write_addr == (N-1)) begin
                write_addr <= 0;
            end else begin
                write_addr <= write_addr + 1;
            end

        end
	end
	
    // Will be the read clock later
	always @ (posedge clk or posedge rst) begin

        if (rst) begin
            // Here we need to make the read_addr pointing to the original ram location (0 in this case)
            // Also initialize read_count to 0
            read_addr <= 0; 
            read_count <= 0; 
        end

        else if (read && (!empty)) begin

            dout <= ram[read_addr];
            read_count <= read_count + 1;
            if (read_addr == (N-1)) begin
                read_addr <= 0;
            end else begin
                read_addr <= read_addr + 1;
            end

        end

	end

// Combinational Logic for empty and full signal
// Also D 
    assign D = write_count - read_count;

    always @ (*) begin

        if (D == 0) begin
            empty = 1;
        end else begin
            empty = 0;
        end 

        if (D == N) begin
            full = 1;
        end else begin
            full = 0;
        end

    end

endmodule