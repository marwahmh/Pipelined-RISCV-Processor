`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2020 11:20:55 AM
// Design Name: 
// Module Name: ControlUnit
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
`include "defines.v"

module ControlUnit( input [4:0] Opcode, input rst, output reg Branch, Jal, MemRead, MemWrite,  ALUSrc1,ALUSrc2, RegWrite,Halt, output reg [1:0] ALUOp,WBsel);

always@(*)
begin
if(rst) begin
{Branch,Jal,MemRead, MemWrite,  ALUSrc1,ALUSrc2, RegWrite,Halt,  ALUOp,WBsel}=0;

end
else
begin
case(Opcode)
`OPCODE_LUI:
begin
Branch=0;
Jal=0;
MemRead=0;
MemWrite=0;
RegWrite=1;
ALUSrc2=1;
Halt=0;
WBsel=2'b00; //imm
ALUOp=2'b11;
end 
`OPCODE_AUIPC: 
begin
Branch=0;
Jal=0;
MemRead=0;
MemWrite=0;
RegWrite=1;
ALUSrc1=1; //pc
ALUSrc2=1; //imm
ALUOp=0; //ADD
Halt=0;
WBsel=2'b00; //alu out
end 
`OPCODE_JAL: 
begin
Branch=0;
Jal=1;
MemRead=0;
MemWrite=0;
RegWrite=1;
ALUSrc1=1; //pc
ALUSrc2=1; //imm
ALUOp=0; //ADD
Halt=0;
WBsel=2'b10; //pc+4
end 
`OPCODE_JALR: 
begin
Branch=0;
Jal=1;
MemRead=0;
MemWrite=0;
RegWrite=1;
ALUSrc1=0; //rs1
ALUSrc2=1; //imm
ALUOp=0; //ADD
Halt=0;
WBsel=2'b10; //pc+4
end
`OPCODE_Branch: 
begin
Branch=1;
Jal=0;
MemRead=0;
MemWrite=0;
RegWrite=0;
ALUSrc1=0; //rs1
ALUSrc2=0; //rs2
ALUOp=2'b01; //SUB
Halt=0;
//WBsel=2'b11; //no write back
end 
`OPCODE_Load: 
begin
Branch=0;
Jal=0;
MemRead=1;
MemWrite=0;
RegWrite=1;
ALUSrc1=0; //rs1
ALUSrc2=1; //imm
ALUOp=0; //ADD
Halt=0;
WBsel=2'b01; //mem
end 
`OPCODE_Store: 
begin
Branch=0;
Jal=0;
MemRead=0;
MemWrite=1;
RegWrite=0;
ALUSrc1=0; //rs1
ALUSrc2=1; //imm
ALUOp=0; //ADD
Halt=0;
//WBsel=2'b01; //mem
end 
`OPCODE_Arith_I: 
begin
Branch=0;
Jal=0;
MemRead=0;
MemWrite=0;
RegWrite=1;
ALUSrc1=0; //rs1
ALUSrc2=1; //imm
ALUOp=2'b10; //arithmetic operations
Halt=0;
WBsel=2'b00; //alu out
end 
`OPCODE_Arith_R: 
begin
Branch=0;
Jal=0;
MemRead=0;
MemWrite=0;
RegWrite=1;
ALUSrc1=0; //rs1
ALUSrc2=0; //rs2
ALUOp=2'b10; //arithmetic operations
Halt=0;
WBsel=2'b00; //alu out
end 
`OPCODE_SYSTEM:
Halt=1;
endcase
end
end
endmodule
