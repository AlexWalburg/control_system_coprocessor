module error_subber #(parameter NUM_BITS=32)
   (
    input		  clk,
    input		  rst,
    input		  data_en,
    input [NUM_BITS-1:0]  data_in,
    input [NUM_BITS-1:0]  extra_data,
    output [NUM_BITS-1:0] data_out,
    output		  data_en_out
    );

   localparam		  MSB = NUM_BITS - 1;
   
   reg [MSB:0]	   sum;
   assign data_out = sum;
   reg		   en;
   assign data_en_out = en;

   task do_reset();
      begin
	 en <= 0;
	 sum <= 0;
      end
   endtask // do_reset

   task do_idle();
      begin
	 en <= 0;
      end
   endtask // do_idle
   integer i;
   task do_write();
      begin
	 sum <= data_in - extra_data;
	 en <=1;
      end
   endtask // do_write
   
   always @(posedge clk or posedge rst) begin
      if(rst)
	do_reset();
      else
	if(data_en)
	  do_write();
	else
	  do_idle();
   end
endmodule // two_adder

