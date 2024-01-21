module axilite_csr_write_data
  #(parameter DATA_SIZE = 32*4,
    parameter ADDR_SIZE = 32,
    parameter DATA_WIDTH = 32,
    parameter RESP_OKAY = 0,
    parameter RESP_EXOKAY = 1,
    parameter RESP_SLVERR = 2,
    parameter RESP_DECERR = 3,
    parameter INITIAL_VALUE = 0)
   (
    input		       clk,
    input		       rst,
    input [DATA_WIDTH-1:0]     wdata,
    input [ADDR_SIZE-1:0]      addr,
    input		       addr_good,
    input		       wvalid,
    input [num_strobe-1:0]     wstrobe, 
    output reg [DATA_SIZE-1:0] regs,
    output reg		       wready,
    // to let bresp know what it needs to write
    output [1:0]	       resp,
    output		       resp_valid 		       
    );

   
   localparam		    num_strobe = DATA_WIDTH/8;
   localparam		    num_addr_bits_to_zero = $clog2(DATA_WIDTH/8);


   wire			    good_addr_write = ~addr_out_of_range;
   assign resp_valid = wready;
   assign resp = good_addr_write ? RESP_OKAY : RESP_SLVERR;
   
   wire [ADDR_SIZE-1:0]	    real_addr; // we zero out the num_addr_bits_to_zero bits to dword/qword align this
   assign real_addr = {addr[ADDR_SIZE-1:num_addr_bits_to_zero],{num_addr_bits_to_zero{1'b0}}};

   wire		 addr_out_of_range;
   assign addr_out_of_range = real_addr*8 > DATA_SIZE - DATA_WIDTH;
   
   task do_reset();
      begin
	 regs <= INITIAL_VALUE;
	 wready <= 0;
      end
   endtask // do_reset

   task do_idle();
      wready <= 0;
   endtask // do_idle

   integer unsigned i;
   task do_write();
      begin
	 if(good_addr_write) begin
	    for(i = 0; i < num_strobe; i = i + 1)
	      if(wstrobe[i])
		regs[(real_addr + i)*8 +: 8] = wdata[i*8 +:8];
	 end
	 wready <= 1;
      end
   endtask // do_write

   always @(posedge clk or posedge rst) begin
      if(rst)
	do_reset();
      else begin
	 if(addr_good && wvalid && ~wready)
	   do_write();
	 else
	   do_idle();
      end
   end
   
endmodule // axilite_csr_write_data
