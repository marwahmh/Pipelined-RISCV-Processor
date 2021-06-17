`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2020 09:49:47 AM
// Design Name: 
// Module Name: alu_control
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
module alu_control(input [6:0]fun7, [1:0] ALUOp,[2:0] fun3,output reg[3:0] ALU_Selection);
always@(*)
   begin
   case (ALUOp)
   2'b00:  ALU_Selection=4'b0000;////any load store 
   2'b01:  ALU_Selection=4'b0001; //sub for branches
   2'b11:  ALU_Selection=4'b00_11;////lui
   2'b10:  
    case (fun3)
        3'b000:  
            case (fun7)
                 7'b0000000: ALU_Selection=4'b0000; //add
                 7'b0100000: ALU_Selection=4'b0001; //sub
                 endcase
        3'b111: ALU_Selection=4'b01_01;  //and   
        3'b110: ALU_Selection=4'b01_00;  //or 
        3'b100: ALU_Selection=4'b01_11;  //xor
        3'b001: ALU_Selection=4'b10_01;  //sll
        3'b010: ALU_Selection=4'b11_01;  //slt
        3'b011: ALU_Selection=4'b11_11;  //sltu
        3'b101:  
					case (fun7)
						 7'b0000000: ALU_Selection=4'b10_00; //srl
						 7'b0100000: ALU_Selection=4'b10_10; //sra
						 endcase   
        endcase   
        endcase
        end 

        
endmodule
