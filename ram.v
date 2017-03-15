module rom(address, data, cs,rw,clk);
 input [9:0]address;
 output [7:0]data;
 input cs;
 input rw;
 input clock;

 reg [7:0] mem [0:1023];
 reg [7:0] dataout;

 always@(posedge clock)
 begin
     if(cs)
     begin
         if(rw)
         begin
             mem[address]=data;
         end
         else
         begin
             dataout=mem[address];
         end
     end
 end

 assign data=(cs&~rw)?dataout:8'bz;

endmodule
