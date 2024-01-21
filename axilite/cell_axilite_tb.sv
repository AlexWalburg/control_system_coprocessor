module cell_axilite_tb();
   reg aclk = 0;
   reg aresetn;
   // read addr channel
   reg [31:0]	    araddr = 0;
   reg		    arvalid = 0;
   wire		    arready;
   // read data channel
   wire [31:0]	    rdata;
   wire [1:0]	    rresp;
   wire		    rvalid;
   reg		    rready = 0;

   reg [31:0]	    awaddr;
   reg		    awvalid = 0;
   wire		    awready;
   reg [31:0]	    wdata;
   reg [3:0]	    wstrb = 0;
   reg		    wvalid = 0;
   wire		    wready;
   reg		    bready = 0;
   wire		    bvalid;
   wire [1:0]	    bresp;

   always #1 aclk <= ~aclk;

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

   task do_read(input [31:0] addr);
      araddr <= addr;
      arvalid <= 1;
      rready <= 0;
      #2;
      while(~arready) #1;
      arvalid <= 0;
      while(~rvalid) #1;
      rready <= 1;
      #2;
      rready <= 0;
   endtask // do_read

   initial begin
      $dumpfile("axilite_test.vcd");
      $dumpvars(0,axilite_cell);
   end
   
   initial begin
      aresetn <= 0;
      #2;
      aresetn <= 1;
      do_write(0,32'h11223344,4'b1111);
      do_write(4,32'h55667788,4'b1011);
      do_read(0);
      do_read(4);
      $finish();
   end

   cell_axilite axilite_cell(.*);
endmodule; // cell_axilite_tb
