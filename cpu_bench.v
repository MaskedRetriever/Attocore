module bench;
 reg clock,reset;
 wire data_dir;
 reg [7:0]data_in;
 wire [15:0]address_bus;
 wire [7:0]data_bus;

 attocore a1(clock, reset, data_dir, data_bus, address_bus);
 rom r1(address_bus[7:0],data_bus,data_dir);

 initial begin
     $dumpvars(0,bench);
     reset=0;
     clock=0;
     data_in=0;
     #5;
     reset=1;
     #500;
     $finish;
 end

 always begin
     #10 clock=~clock;
 end
endmodule
