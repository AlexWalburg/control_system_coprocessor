module axilite_bresp
  (
   // internal signals
   input	    clk,
   input	    rst,
   input [1:0]	    resp,
   input	    resp_valid,
   // axi signals
   input	    bready,
   output	    bvalid,
   output reg [1:0] bresp
   );

   localparam	waiting_internal = 0;
   localparam	waiting_axi = 1;
   reg		state;

   assign bvalid = state == waiting_axi;

   task do_reset();
      begin
	 state <= waiting_internal;
      end
   endtask // do_reset

   task do_internal_wait();
      begin
	 if(resp_valid) begin
	    state <= waiting_axi;
	    bresp <= resp;
	 end
      end
   endtask // do_internal_wait

   task do_axi_wait();
      if(bready)
	state <= waiting_internal;
   endtask // do_axi_wait

   always @(posedge clk or posedge rst) begin
      if(rst)
	do_reset();
      else
	case (state)
	  waiting_internal: do_internal_wait();
	  waiting_axi: do_axi_wait();
	endcase // case (state)
   end
endmodule // axilite_bresp

