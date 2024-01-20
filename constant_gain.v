module constant_gain #(parameter MSB = 31)
   (
    input	   clk,
    input	   rst,
    input	   param_en,
    input [MSB:0]  param_in,
    input	   data_en,
    input [MSB:0]  data_in,
    output [MSB:0] out,
    output	   data_en_out
    );
   reg [MSB:0] gain;
   reg [MSB:0] data_out;
   assign out = data_out;
   reg	       en_out;
   assign data_en_out = en_out;
   

   task do_reset();
      begin
	 gain <= 0;
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
	 data_out <= gain * data_in;
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
