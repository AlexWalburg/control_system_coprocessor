module n_adder #(parameter NUM_BITS=32,
		 num_sums = 2)
   (
    input			  clk,
    input			  rst,
    input			  data_en,
    input [NUM_BITS*num_sums-1:0] data_in,
    output [NUM_BITS-1:0]	  data_out,
    output			  data_en_out
    );
   
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
	 en_out <= 0;
      end
   endtask // do_idle
   integer i;
   task do_write();
      begin
	 sum <= data_in[0+:NUM_BITS];
	 for (i = 1; i < num_sums; i = i + 1)
	   sum <= sum + data_in[i*NUM_BITS+:NUM_BITS];
	 en_out <=1;
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

