module testout_tb();
   reg clk = 0;
   reg rst = 0;
   reg [1343:0]	axi_params = 0;
   reg [14:0]	data = 1 << 4;
   reg		data_en = 1;
   reg		param_en = 0;
   wire [14:0]	data_out;
   wire		data_out_en;

   always #1 clk <= ~clk;

   initial begin
      $dumpfile("testout_test");
      $dumpvars(0,test);
      rst <= 1;
      #2;
      rst <= 0;
      #100;
      $finish();
   end
   
   cell_control_system_interconnect test(.*);
endmodule   
      
