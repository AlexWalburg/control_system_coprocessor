module axilite_reader
  #(parameter ADDR_WIDTH = 32)
   (
    input		    clk,
    input		    rst,
    input [ADDR_WIDTH-1:0]  addr,
    input		    valid,
    output		    ready,
    input		    deassert_addr, // flow control, write 1 to this to turn off addr
    output [ADDR_WIDTH-1:0] held_addr, // addr pulled out of axi line
    output		    addr_ready
    );
   // state defines
   localparam		    WAITING_FOR_DATA = 0;
   localparam		    HOLDING_DATA = 1;
   
   // registers needed
   reg [ADDR_WIDTH-1:0]	    internal_addr;
   assign held_addr = internal_addr;
   reg			    state;
   assign addr_ready = state;
   reg			    ready_out;
   assign ready = ready_out;

   task do_reset(); 
      begin
	 state <= WAITING_FOR_DATA;
	 internal_addr <= 0;
	 ready_out <= 0;
      end
   endtask // do_reset

   task do_data_wait();
      begin
	 if(valid) begin
	    ready_out <= 1;
	    state <= HOLDING_DATA;
	    internal_addr <= addr;
	 end
      end
   endtask // do_data_wait

   task do_data_hold();
      begin
	 ready_out <= 0;
	 if(deassert_addr)
	   state <= WAITING_FOR_DATA;	 
      end
   endtask // do_data_hold
   
   always @(posedge clk or posedge rst) begin
      if(rst) begin
	 do_reset();
      end
      else begin
	 case (state)
	   WAITING_FOR_DATA: do_data_wait();
	   HOLDING_DATA: do_data_hold();
	 endcase // case (state)
      end
      
endmodule // axilite_reader

   
