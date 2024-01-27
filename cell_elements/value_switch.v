module value_switch #(parameter MSB = 31,
		      parameter DEFAULT_TRIG_VALUE = 'h10)
   (
    input	   clk,
    input	   rst,
    input [MSB:0]  data_in,
    input	   data_en,
    input [MSB:0]  data_lo,
    input [MSB:0]  data_hi,
    input [MSB:0]  param_in,
    input	   param_en,
    output [MSB:0] data_out,
    output	   data_en_out
    );

   reg [MSB:0]	   trig_value;

   reg [MSB:0]	   out;
   reg		   en_out;

   wire		   abs_data = data_in[MSB] ? -data_in : data_in;

   task do_reset();
      begin
	 trig_value <= DEFAULT_TRIG_VALUE;
	 en_out <= 0;
      end
   endtask // do_reset

   task load_param();
      begin
	 trig_value <= param_in;
      end
   endtask // load_param

   task load_data();
      begin
	 out <= abs_data <= trig_value ? data_lo : data_hi;
	 en_out <= 1;
      end
   endtask // load_data

   task do_idle();
      begin
	 en_out <= 0;
      end
   endtask // do_idle

   always @(posedge clk or posedge rst) begin
      if(rst)
	do_reset();
      else begin
	 // priortize loading param as opposed to loading data
	 case ({param_en,data_en}) 
	   2'b1x: load_param();
	   2'b01: load_data();
	   default: do_idle();
	 endcase // case ({param_en,data_en)       
      end
   end
endmodule // value_switch
