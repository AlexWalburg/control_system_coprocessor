module axilite_read_data
  #(parameter DATA_SIZE = 32*4,
    parameter ADDR_SIZE = 32,
    parameter DATA_WIDTH = 32,
    parameter RESP_OKAY = 0,
    parameter RESP_EXOKAY = 1,
    parameter RESP_SLVERR = 2,
    parameter RESP_DECERR = 3)
   (
    input			clk,
    input			rst,
    input [DATA_SIZE-1:0]	data,
    input [ADDR_SIZE-1:0]	addr,
    input			addr_good,
    output			deassert_addr,
    output reg [DATA_WIDTH-1:0]	rdata,
    output reg [1:0]		rresp,
    output reg			rready,
    input			rvalid
    );

   task do_reset();
      begin
      end
   endtask // do_reset

   wire addr_out_of_range;
   // * 8 is due to byte level addressing, should turn into bitshift
   // - DATA_WIDTH is due to axilite requiring full burst every time
   assign addr_out_of_range = addr*8 > DATA_SIZE - DATA_WIDTH;
   assign deassert_addr = ~addr_out_of_range && addr_good && rready;

   task read_data();
      begin
	 if(addr_out_of_range || ~addr_good) begin
	    rresp <= RESP_SLVERR;
	 end else begin
	    rresp <= RESP_OKAY;
	    rdata <= data[addr*8 +: DATA_WIDTH];
	 end
	 rready <= 1;
      end
   endtask // read_data

   task idle();
      begin
	 rready <= 0;
	 deassert_addr <= 0;
      end
   endtask // idle

   always @(posedge clk or posedge rst) begin
      if(rst) begin
	 do_reset();
      end
      else begin
	 if(rvalid) begin
	    read_data();
	 end else begin
	    idle();
	 end
      end
   end
   
endmodule // axilite_read_data
