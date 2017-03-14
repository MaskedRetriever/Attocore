module rom(address, data, cs);
 input [7:0]address;
 output [7:0]data;
 input cs;

 reg [7:0] mem [0:255];

 assign data=(cs)?mem[address]:8'bz;

 initial begin
     $readmemb("rom.txt", mem);
 end
endmodule
