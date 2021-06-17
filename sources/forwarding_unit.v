`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2020 09:21:49 PM
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit( input [4:0] RS1 , RS2 , RD_ex_mem , RD_mem_wb, input EX_MEM_RegWrite,
 MEM_WB_RegWrite, output reg [1:0] forwardA,forwardB);

   
   always @(*) begin
   if (EX_MEM_RegWrite && (RD_ex_mem != 0) && (RD_ex_mem == RS1))
   forwardA = 2'b10;
   else
   if ((MEM_WB_RegWrite && (RD_mem_wb != 0) && (RD_mem_wb == RS1)) && !(EX_MEM_RegWrite && (RD_ex_mem != 0) && (RD_ex_mem == RS1)))
   forwardA = 2'b01;
   else 
   forwardA = 2'b00;
   
   if (EX_MEM_RegWrite && (RD_ex_mem != 0) && (RD_ex_mem == RS2))
   forwardB = 2'b10;
   else
   if ((MEM_WB_RegWrite && (RD_mem_wb != 0) && (RD_mem_wb == RS2)) && !(EX_MEM_RegWrite && (RD_ex_mem != 0) && (RD_ex_mem == RS2)))
   forwardB = 2'b01;
   else 
   forwardB = 2'b00;
   end
   
endmodule
