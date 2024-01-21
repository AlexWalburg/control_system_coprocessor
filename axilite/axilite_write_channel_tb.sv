module axi_csr_write_data_tb();
   reg clk = 0;
   reg rst;

   reg [31:0] awaddr;
   reg	      awvalid = 0;
   wire	      awready;
   reg [31:0] wdata;
   reg [3:0]  wstrb = 0;
   reg	      wvalid = 0;
   wire	      wready;
   reg	      bready = 0;
   wire	      bvalid;
   wire [1:0] bresp;
   wire [32*4-1:0] regs;
   
   
   always #1 clk <= ~clk;

   task write_addr(input [31:0] addr);
      awaddr <= addr;
      awvalid <= 1;
      #2;
      while(~awready) #1;
      awvalid <= 0;
      #2;
   endtask // write_addr
   
   task write_data(input [31:0] data, input [3:0] strobe);
      wdata <= data;
      wstrb <= strobe;
      wvalid <= 1;
      while(~wready) #1;
      wvalid <= 0;
      #2;
   endtask // write_data

   task wait_resp();
      while(~bvalid) #1;
      bready <= 1;
      #2;
      bready <= 0;
      #2;
   endtask // wait_resp


   task do_write(input [31:0] addr, input[31:0] data, input[3:0] strobe);
      write_addr(addr);
      write_data(data,strobe);
      wait_resp();
   endtask; // do_write

   initial begin
      $dumpfile("write_test.vcd");
      $dumpvars(0,csr_write);
   end
   
   initial begin
      rst <= 1;
      #2;
      rst <= 0;
      do_write(0,32'h11223344,4'b1111);
      do_write(4,32'h55667788,4'b1011);
      $finish();
   end

   axilite_write_channel csr_write
     (
      .*
      );
   
   
endmodule; // axi_csr_write_data_tb
