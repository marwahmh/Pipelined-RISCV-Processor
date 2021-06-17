`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2020 03:00:39 PM
// Design Name: 
// Module Name: inst_com
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module inst_com(input [31:0] inst,pc_in,output reg [31:0]inst_out,pc_out);
reg [15:0]com_inst;
always @(*)
begin
if (inst[1:0]==2'b11)
    begin
        inst_out=inst;
        pc_out=pc_in;
    end
else 
begin
pc_out=pc_in-2'd2;
com_inst=inst[15:0];
case(inst[1:0])
    2'b00:begin //////c0 >>2 inst.
           if(inst[15:13]==3'b010)
           inst_out={7'd0,com_inst[5],com_inst[12:10],com_inst[6],1'd0,(com_inst[9:7]+4'd8),3'b010,1'd0,(com_inst[4:2]+4'd8),7'b0000011};//lw
           else
           inst_out={7'd0,1'b0,(com_inst[4:2]+4'd8),1'b0,(com_inst[9:7]+4'd8),3'b010,com_inst[5],com_inst[12:10],com_inst[6],7'b0100011};//sw               
          end
          
    2'b01:begin //////c1 >>14 inst.
                     if(inst[15:13]==3'b000)//nop & addi
                     begin
                     if({inst[12],inst[6:2]}==5'd0)
                     inst_out=32'd51; ///nop
                     else
                     inst_out={6'd0,inst[12],inst[6:2],com_inst[11:7],3'b000,com_inst[11:7],7'b0010011};///addi               
                     end

                    
                      if(inst[15:13]==3'b001)//jal
                      inst_out={1'd0,inst[8],inst[10:9],inst[6],inst[7],inst[2],inst[11],com_inst[5:3],inst[12],8'd0,5'b00001,7'b1101111};///jal            

                      if(inst[15:13]==3'b010)//li
                      inst_out={6'd0,inst[12],inst[6:2],5'b00000,3'b000,com_inst[11:7],7'b0010011};///li 
                      
                      if(inst[15:13]==3'b011)//lui 
                      begin
                          if((com_inst[11:7]!=05'd0)||(com_inst[11:7]!=05'd2))                               
                              inst_out={14'd0,inst[12],inst[6:2],com_inst[11:7],7'b0110111};///lui  
                              else 
                              inst_out=32'd51; ///nop
                     end
                     if(inst[15:13]==3'b100)/////////100
                     begin
                     case(inst[11:10])
                    2'b00:
                            begin
                             if(inst[6:2]!=5'd0)
                             inst_out={7'd0,inst[6:2],1'b0,(com_inst[9:7]+4'd8),3'b101,1'd0,(com_inst[9:7]+4'd8),7'b0010011};///SRLI               
                           else 
                              inst_out=32'd51; ///nop
                            end
                      2'b01:
                            begin
                               if(inst[6:2]!=5'd0)
                               inst_out={7'b0100000,inst[6:2],1'b0,(com_inst[9:7]+4'd8),3'b101,1'd0,(com_inst[9:7]+4'd8),7'b0010011};///SRAI               
                             else 
                                inst_out=32'd51; ///nop
                              end  
                      2'b10:
                                inst_out={7'b010000,inst[6:2],inst[12],1'b0,(com_inst[9:7]+4'd8),3'b111,1'd0,(com_inst[9:7]+4'd8),7'b0010011};//ANDI               
                     2'b11:
                     case(inst[6:5])
                                                2'b01:inst_out={7'b0100000, (com_inst[4:2] + 4'd8), (com_inst [9:7]+4'd8 ), 3'b000, (com_inst [9:7]+4'd8), 7'b0110011}; //sub
                                                2'b01:inst_out={7'b0000000, (com_inst[4:2] + 4'd8), (com_inst [9:7]+4'd8 ), 3'b100, (com_inst [9:7]+4'd8), 7'b0110011}; //XOR
                                                2'b10:inst_out={7'b0000000, (com_inst[4:2] + 4'd8), (com_inst [9:7]+4'd8 ), 3'b110, (com_inst [9:7]+4'd8), 7'b0110011}; //OR
                                                2'b11:inst_out={7'b0000000, (com_inst[4:2] + 4'd8), (com_inst [9:7]+4'd8 ), 3'b111, (com_inst [9:7]+4'd8), 7'b0110011}; //AND
                                            
                      endcase
                      endcase
                      if(inst[15:13]==3'b101)//j
                      inst_out={1'd0,inst[8],inst[10:9],inst[6],inst[7],inst[2],inst[11],com_inst[5:3],inst[12],8'd0,5'b00000,7'b1101111};///j            
                      
                      if(inst[15:13]==3'b110)//BEQZ
            inst_out={ 4'd0,com_inst[12],com_inst[6:4],com_inst[2], 5'b0, 1'b0,(com_inst [9:7]+4'd8),3'b000,com_inst[11:10], com_inst[4:3], 1'b0, 7'b1100011};
                      if(inst[15:13]==3'b111)//BNQZ
            inst_out={ 4'd0,com_inst[12],com_inst[6:4],com_inst[2], 5'b0, 1'b0,(com_inst [9:7]+4'd8),3'b001,com_inst[11:10], com_inst[4:3], 1'b0, 7'b1100011};

                     end
                     end
                     
       2'b10:begin //////c2 >>6 inst.
              case(inst[15:13])
                    3'd0:inst_out={7'b0000000, com_inst [6:2], com_inst [11:7], 3'b001, com_inst [11:7], 7'b0010011}; //SLLI

                   3'b100:begin
                   if(inst[12]!=0)begin
                      if(inst[6:2]!=5'd0)
                      inst_out={7'd0,inst[6:2],com_inst[11:7],3'b000,com_inst[11:7],7'b0110011};///add
                      else
                      inst_out={12'd0,com_inst[11:7],3'b000,5'd1,7'b1100111};///JALR                    
                      end
                      else
                      begin
                                         if(inst[6:2]!=5'd0)
                         inst_out={7'd0,inst[6:2],5'd0,3'b000,com_inst[11:7],7'b0110011};///mv
                                            else
                                            inst_out={12'd0,com_inst[11:7],3'b000,5'd0,7'b1100111};///JR  
                      end
                          

                       end       
             
              endcase
             end
           
          
endcase
end 
end

endmodule
