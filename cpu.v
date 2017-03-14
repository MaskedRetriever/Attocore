module attocore(clock, reset, data_dir, data_bus, address_bus);
 input clock, reset;
 output [15:0]address_bus;
 output data_dir;
 inout [7:0]data_bus;

 //Registers 
 reg [15:0]addr_reg; //r0,r1
 reg [15:0]pc_reg; //r2,r3
 reg [7:0]ir_reg; //r4
 reg [7:0]alu_a_reg; //r5
 reg [7:0]alu_b_reg; //r6
 reg [7:0]alu_y_reg; //r7
 reg [7:0]r8;
 reg [7:0]r9;
 reg [7:0]r10;
 reg [7:0]r11;
 reg [7:0]r12;
 reg [7:0]r13;
 reg [7:0]r14;
 reg [7:0]r15;

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
         addr_reg=0;
         pc_reg=0;
         ir_reg=0;
         alu_a_reg=0;
         alu_b_reg=0;
         alu_y_reg=0;
         r8=0;
         r9=0;
         r10=0;
         r11=0;
         r12=0;
         r13=0;
         r14=0;
         r15=0;
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
             r_address_bus=pc_reg;
             r_data_dir=1;
             next_SystemState=1;
         end
         1://Instruction Decode
         begin
             ir_reg=data_bus;
             pc_reg=pc_reg+1;
             case(ir_reg[7:5])
                 0://noop
                 begin
                     next_SystemState=0;
                 end
                 1://jump
                 begin
                     pc_reg=addr_reg;
                     next_SystemState=0;
                 end
                 2:next_SystemState=0;//Arithmatic
                 3:next_SystemState=5;
             endcase
             next_SystemState=0;
         end
         2:r_data_bus=2;
         3:
         begin
             r9=data_bus;
             addr_reg=0;
         end
     endcase
 end

endmodule




