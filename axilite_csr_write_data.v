module axilite_csr_write_data
  #(parameter DATA_SIZE = 32*4,
    parameter ADDR_SIZE = 32,
    parameter DATA_WIDTH = 32,
    parameter RESP_OKAY = 0,
    parameter RESP_EXOKAY = 1,
    parameter RESP_SLVERR = 2,
    parameter RESP_DECERR = 3)
   (
    input		       clk,
    input		       rst,
    input [DATA_SIZE-1:0]      data,
    input [ADDR_SIZE-1:0]      addr,
    input		       addr_good,
    input		       wvalid,
    output		       deassert_addr,
    output reg [DATA_SIZE-1:0] regs,
    output		       wready,
    // to let bresp know what it needs to write
    output [3:0]	       resp,
    output		       resp_valid 		       
    );

   localparam		    num_strobe = DATA_SIZE/8;
   localparam		    num_addr_bits_to_zero = $clog2(DATA_WIDTH/8);

   wire [ADDR_SIZE-1:0]	    real_addr; // we zero out the num_addr_bits_to_zero bits to dword/qword align this
   assign real_addr = {addr[ADDR_SIZE-1:num_addr_bits_to_zero],num_addr_bits_to_zero*{0}};

   wire		 addr_out_of_range;
   assign addr_out_of_range = addr*8 > DATA_SIZE - DATA_WIDTH;

   task do_reset();
   endtask // do_reset

   task do_idle();
   endtask // do_idle

   task do_write();
   endtask // do_write
   
endmodule // axilite_csr_write_data
