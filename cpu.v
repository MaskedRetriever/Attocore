module attocore(clock, reset, data_dir, data_bus, address_bus);
 input clock, reset;
 output [15:0]address_bus;
 output data_dir;
 inout [7:0]data_bus;

 //Registers 
 reg [7:0]regfile[15:0];
 //Register aliases
 wire [15:0]addr;
 wire [15:0]pc;
 wire [7:0]ir;
 wire [7:0]alu_a;
 wire [7:0]alu_b;
 wire [7:0]alu_y;
 wire [7:0]alu_c_out;
 assign addr={regfile[1],regfile[0]};
 assign pc={regfile[3],regfile[2]};
 assign ir=regfile[4];
 assign alu_a=regfile[5];
 assign alu_b=regfile[6];
 assign alu_y=regfile[7];

 //ALU
 atto_alu a1(regfile[4][3:0],regfile[5],regfile[6],alu_c_out);

 //State Machine
 reg [4:0]SystemState;
 reg [4:0]next_SystemState;

 //Output Drivers
 reg [15:0]r_address_bus;
 reg [7:0]r_data_bus;
 reg r_data_dir;
 
 //Assignments
 assign address_bus = r_address_bus;
 assign data_bus = r_data_bus;
 assign data_dir = r_data_dir;
 
 always@(reset)
 begin
     if(~reset)
     begin
         regfile[0]=0;
         regfile[1]=0;
         regfile[2]=0;
         regfile[3]=0;
         regfile[4]=0;
         regfile[5]=0;
         regfile[6]=0;
         regfile[7]=0;
         regfile[8]=0;
         regfile[9]=0;
         regfile[10]=0;
         regfile[11]=0;
         regfile[12]=0;
         regfile[13]=0;
         regfile[14]=0;
         regfile[15]=0;
         SystemState=0;
         next_SystemState=0;
         r_data_dir=0;
         r_data_bus=8'bz;
         r_address_bus=0;
     end
 end

 always@(posedge clock)
 begin
     SystemState=next_SystemState;
     case(SystemState)
         0://Instruction Fetch
         begin
             r_data_bus=8'bz;
             r_address_bus={regfile[3],regfile[2]};//Program Counter Register
             r_data_dir=1;
             next_SystemState=1;
         end
         1://Instruction Decode
         begin
             regfile[4]=data_bus;//Update instruction Register
             {regfile[3],regfile[2]}={regfile[3],regfile[2]}+1; //Increment Program Counter
             case(regfile[4][7:5]) //3-bit instruction field
                 0://noop
                 begin
                     next_SystemState=0;
                 end
                 1://jump
                 begin
                     regfile[2]=regfile[0];
                     regfile[3]=regfile[1];//copy addr to pc
                     next_SystemState=2;
                 end
                 2:next_SystemState=3;//Arithmatic
                 3:next_SystemState=4;//Value Set
                 4:next_SystemState=6;//Read
                 5:next_SystemState=7;//Write
                 6:next_SystemState=8;//Copy
             endcase
         end
         2:next_SystemState=0;
         3:
         begin
             regfile[7]=alu_c_out;
             next_SystemState=0;
         end
         4:
         begin
             r_data_bus=8'bz;
             r_address_bus={regfile[3],regfile[2]};//fetch data
             r_data_dir=1;
             next_SystemState=5;
         end
         5:
         begin
             {regfile[3],regfile[2]}={regfile[3],regfile[2]}+1;//Increment PC
             regfile[regfile[4][3:0]]=data_bus;
             next_SystemState=0;
         end
         6:next_SystemState=0;
         7:next_SystemState=0;
         8:next_SystemState=0;
         9:next_SystemState=0;

     endcase
 end

endmodule




