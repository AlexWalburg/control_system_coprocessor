module constant_gain #(parameter MSB = 31,
		       parameter GAIN_SIZE = 31,
		       parameter DEFAULT_GAIN = 0,
		       parameter NUM_DECIMAL = 8)
   (
    input		clk,
    input		rst,
    input		param_en,
    input [GAIN_SIZE:0]	param_in,
    input		data_en,
    input [MSB:0]	data_in,
    output [MSB:0]	out,
    output		data_en_out
    );

   localparam	   fp_multsize = MSB+GAIN_SIZE;
   
   reg [MSB:0] gain;
   reg [MSB:0] data_out;
   assign out = data_out;
   reg	       en_out;
   assign data_en_out = en_out;

   wire [fp_multsize-1:0] multout = gain*data_in;

   task do_reset();
      begin
	 gain <= DEFAULT_GAIN;
	 en_out <= 0;
	 data_out <= 0;
      end
   endtask // do_reset

   task load_param();
      begin
	 gain <= param_in;
	 en_out <= 0;
      end
   endtask // load_param

   task load_data();
      begin
	 // sign compressed multiplication with num decimal and msb setup
	 data_out <= {multout[fp_multsize-1],multout[NUM_DECIMAL+:MSB]};
	 en_out <= 1;
      end
   endtask // load_data

   task do_idle();
      en_out <= 0;
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
   
endmodule // constant_gain
