module derivative #(parameter MSB = 31)
   (
    input	   clk,
    input	   rst,
    input [MSB:0]  data_in,
    input	   data_en,
    output [MSB:0] data_out,
    output	   data_en_out
    );
   reg [MSB:0] past_value;
   reg	       past_value_valid;

   reg [MSB:0] out;
   reg	       en;
   assign data_out = out;
   assign data_en_out = en;

   task do_reset();
      begin
	 past_valid <= 0;
	 past_value_valid <= 0;
	 out <= 0;
	 en <= 0;
      end
   endtask // do_reset

   task load_data();
      begin
	 if(past_valid_value) begin
	    out <= data_in - past_value;
	    past_value <= data_in;
	    past_value_valid <= 1;
	 end
	 else
	   en <= 1;
      end
   endtask // load_data

   task do_idle();
      en <= 0;
   endtask // do_idle

   always @(posedge clk or posedge rst) begin
      if(rst)
	do_reset();
      else
	if(data_en)
	  load_data();
	else
	  do_idle();
   end	   
endmodule // derivative
