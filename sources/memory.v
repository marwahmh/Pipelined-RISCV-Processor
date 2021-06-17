`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2020 05:49:09 PM
// Design Name: 
// Module Name: data_mem
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

`define OFFSET 12'd2048
module mem(input clk,input [60:0]in,output [63:0]out);
wire MemRead,MemWrite;
wire[11:0] inst_addr_in,inst_addr,data_addr;
wire[2:0] fun3;
wire[31:0] data_in;
reg [31:0] data_out,inst_out;
assign MemRead=in[60];
assign MemWrite=in[59];
assign inst_addr_in=in[58:47];
assign data_addr=in[46:35];
assign fun3=in[34:32];
assign data_in=in[31:0];



assign inst_addr=12'd2048 +inst_addr_in;


reg [7:0] mem [0:4095];
initial begin
mem[0]=8'd17;
mem[1]=8'd2;
mem[2]=0;
mem[3]=0;
 mem[4]=8'd9;
 mem[5]=0;
 mem[6]=0;
 mem[7]=0;
 mem[8]=8'd25; 
mem[9]=0;
mem[10]=0;
mem[11]=0;

/*

{mem[3+`OFFSET],mem[2+`OFFSET],mem[1+`OFFSET],mem[0+`OFFSET]}=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
{mem[7+`OFFSET],mem[6+`OFFSET],mem[5+`OFFSET],mem[4+`OFFSET]}=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
{mem[11+`OFFSET],mem[10+`OFFSET],mem[9+`OFFSET],mem[8+`OFFSET]}=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
{mem[15+`OFFSET],mem[14+`OFFSET],mem[13+`OFFSET],mem[12+`OFFSET]}=32'b0000000_0010_00001_110_00100_0110011 ; //or x4, x1, x2
{mem[19+`OFFSET],mem[18+`OFFSET],mem[17+`OFFSET],mem[16+`OFFSET]}=32'b0_000001_00011_00100_000_0000_0_1100011; //beq x4, x3, 16
{mem[23+`OFFSET],mem[22+`OFFSET],mem[21+`OFFSET],mem[20+`OFFSET]}=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
{mem[27+`OFFSET],mem[26+`OFFSET],mem[25+`OFFSET],mem[24+`OFFSET]}=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
{mem[31+`OFFSET],mem[30+`OFFSET],mem[29+`OFFSET],mem[28+`OFFSET]}=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
{mem[35+`OFFSET],mem[34+`OFFSET],mem[33+`OFFSET],mem[32+`OFFSET]}=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
{mem[39+`OFFSET],mem[38+`OFFSET],mem[37+`OFFSET],mem[36+`OFFSET]}=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
{mem[43+`OFFSET],mem[42+`OFFSET],mem[41+`OFFSET],mem[40+`OFFSET]}=32'b0000000_00010_00001_110_00101_0110011 ; //or x5, x1, x2
{mem[47+`OFFSET],mem[46+`OFFSET],mem[45+`OFFSET],mem[44+`OFFSET]}=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
{mem[51+`OFFSET],mem[50+`OFFSET],mem[49+`OFFSET],mem[48+`OFFSET]}=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
{mem[55+`OFFSET],mem[54+`OFFSET],mem[53+`OFFSET],mem[52+`OFFSET]}=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
*/



{mem[3+`OFFSET],mem[2+`OFFSET],mem[1+`OFFSET],mem[0+`OFFSET]}=32'b00000000000100000001000100000011; //lh x2,1(x0) 
{mem[7+`OFFSET],mem[6+`OFFSET],mem[5+`OFFSET],mem[4+`OFFSET]}=32'b00000000001100000101010010000011; //lhu x9,3(x0)
{mem[11+`OFFSET],mem[10+`OFFSET],mem[9+`OFFSET],mem[8+`OFFSET]}=32'b00000000000100010000001000010011; //addi x4, x2,1
{mem[15+`OFFSET],mem[14+`OFFSET],mem[13+`OFFSET],mem[12+`OFFSET]}=32'b00000000100000011100010010010011; //xori x9,x3,8
{mem[19+`OFFSET],mem[18+`OFFSET],mem[17+`OFFSET],mem[16+`OFFSET]}=32'b00000100001000100001_0100_0_1100011; /*bne  x4,x2,b1  "it is put to check the branching and removed to check the instructions in the middle"*/
{mem[23+`OFFSET],mem[22+`OFFSET],mem[21+`OFFSET],mem[20+`OFFSET]}=32'b00000000000100000000010100100011; //sb x1,10(x0)
{mem[27+`OFFSET],mem[26+`OFFSET],mem[25+`OFFSET],mem[24+`OFFSET]}=32'b00000000000100010001000110010011; //slli  x3,x2,1
{mem[31+`OFFSET],mem[30+`OFFSET],mem[29+`OFFSET],mem[28+`OFFSET]}=32'b00000000001000010011010010110011; //sltu x9,x2,x2 
{mem[35+`OFFSET],mem[34+`OFFSET],mem[33+`OFFSET],mem[32+`OFFSET]}=32'b00000000000000001100001010110111; //lui x5,12
{mem[39+`OFFSET],mem[38+`OFFSET],mem[37+`OFFSET],mem[36+`OFFSET]}=32'b00000000000000000000001110000011; //lb x7,0(x0)
{mem[43+`OFFSET],mem[42+`OFFSET],mem[41+`OFFSET],mem[40+`OFFSET]}=32'b00000000000100010010010100010011; //slti x10,x2,1 
{mem[47+`OFFSET],mem[46+`OFFSET],mem[45+`OFFSET],mem[44+`OFFSET]}=32'b00000000001000010110001110010011; //ori  x7,x2,2
{mem[51+`OFFSET],mem[50+`OFFSET],mem[49+`OFFSET],mem[48+`OFFSET]}=32'b11111111111000011011010100010011; //sltiu x10,x3,-2 
{mem[55+`OFFSET],mem[54+`OFFSET],mem[53+`OFFSET],mem[52+`OFFSET]}=32'b00000000010000010100010000110011; //xor  x8,x2,x4
{mem[59+`OFFSET],mem[58+`OFFSET],mem[57+`OFFSET],mem[56+`OFFSET]}=32'b00000000000100010101001100010011;//srli  x6,x2,1 
{mem[63+`OFFSET],mem[62+`OFFSET],mem[61+`OFFSET],mem[60+`OFFSET]}=32'b01000000000100010101001010010011; //srai  x5,x2,1
{mem[67+`OFFSET],mem[66+`OFFSET],mem[65+`OFFSET],mem[64+`OFFSET]}=32'b00000000010000000001010110100011; //sh x4,11(x0)
{mem[71+`OFFSET],mem[70+`OFFSET],mem[69+`OFFSET],mem[68+`OFFSET]}=32'b00000000000100010101001110110011;//srl  x7,x2,x1
{mem[75+`OFFSET],mem[74+`OFFSET],mem[73+`OFFSET],mem[72+`OFFSET]}=32'b00000000001000010111010000010011; //andi  x8,x2,2
{mem[79+`OFFSET],mem[78+`OFFSET],mem[77+`OFFSET],mem[76+`OFFSET]}=32'b00000000001000000100010000000011; //lbu x8,2(x0)
{mem[83+`OFFSET],mem[82+`OFFSET],mem[81+`OFFSET],mem[80+`OFFSET]}=32'b00000000000100010001001000110011; //sll  x4, x2, x1
{mem[87+`OFFSET],mem[86+`OFFSET],mem[85+`OFFSET],mem[84+`OFFSET]}=32'b01000000000100010101001010110011; //sra  x5,x2,x1

{mem[91+`OFFSET],mem[90+`OFFSET],mem[89+`OFFSET],mem[88+`OFFSET]}=32'b0000000_00011_0010_010_01010_0110011;//slt x10,x3,x2
{mem[95+`OFFSET],mem[94+`OFFSET],mem[93+`OFFSET],mem[92+`OFFSET]}=32'b00000000001000010110001110010011; //ori  x7,x2,2  50
{mem[99+`OFFSET],mem[98+`OFFSET],mem[97+`OFFSET],mem[96+`OFFSET]}=32'b000000_000010_00011_100_1000_0_1100011; //blt x3,x2,b2 23
{mem[103+`OFFSET],mem[102+`OFFSET],mem[101+`OFFSET],mem[100+`OFFSET]}=32'b000000000001_00100_000_00100_0010011; //addi x4, x4,1
{mem[107+`OFFSET],mem[106+`OFFSET],mem[105+`OFFSET],mem[104+`OFFSET]}=32'b000000000001_00100_000_00100_0010011; //addi x4, x4,1 
{mem[111+`OFFSET],mem[110+`OFFSET],mem[109+`OFFSET],mem[108+`OFFSET]}=32'b000000000011_00010_101_0100_0_1100011;// bge x2,x3,b3 
{mem[115+`OFFSET],mem[114+`OFFSET],mem[113+`OFFSET],mem[112+`OFFSET]}=32'b000000000001_00100_000_00101_0010011; //addi x5, x4,1
{mem[119+`OFFSET],mem[118+`OFFSET],mem[117+`OFFSET],mem[116+`OFFSET]}=32'b000000000001_00100_000_00100_0010011; //addi x4, x4,1  52
{mem[123+`OFFSET],mem[122+`OFFSET],mem[121+`OFFSET],mem[120+`OFFSET]}=32'b0000000000110001011001000_1100011;//bltu x2,x3,b4 
{mem[127+`OFFSET],mem[126+`OFFSET],mem[125+`OFFSET],mem[124+`OFFSET]}=32'b000000000001_00100_000_00100_0010011; //addi x4, x4,1
{mem[131+`OFFSET],mem[130+`OFFSET],mem[129+`OFFSET],mem[128+`OFFSET]}=32'b000000000100_00100_000_00100_0010011; //addi x4, x4,1  53
{mem[135+`OFFSET],mem[134+`OFFSET],mem[133+`OFFSET],mem[132+`OFFSET]}=32'b000000000010000111111010001100011;//bgeu x3,x2,b5
{mem[139+`OFFSET],mem[138+`OFFSET],mem[137+`OFFSET],mem[136+`OFFSET]}=32'b000000000001_00100_000_00100_0010011; //addi x4, x4,1
{mem[143+`OFFSET],mem[142+`OFFSET],mem[141+`OFFSET],mem[140+`OFFSET]}=32'b000000000001_00100_000_00100_0010011; //addi x4, x4,1
{mem[147+`OFFSET],mem[146+`OFFSET],mem[145+`OFFSET],mem[144+`OFFSET]}=32'b00000000100000000000000011101111;//jal x1,b6 
{mem[151+`OFFSET],mem[150+`OFFSET],mem[149+`OFFSET],mem[148+`OFFSET]}=32'b000000000001_00100_000_00100_0010011; //addi x4, x4,1
{mem[155+`OFFSET],mem[154+`OFFSET],mem[153+`OFFSET],mem[152+`OFFSET]}=32'b000000000001_00100_000_00100_0010011; //addi x4, x4,1
{mem[159+`OFFSET],mem[158+`OFFSET],mem[157+`OFFSET],mem[156+`OFFSET]}=32'b000000001100_00001_000_00001_1100111;//jalr x1,x1,12 
{mem[163+`OFFSET],mem[162+`OFFSET],mem[161+`OFFSET],mem[160+`OFFSET]}=32'b000000000001_00100_000_00100_0010011; //addi x4, x4,1
//{mem[167+`OFFSET],mem[166+`OFFSET],mem[165+`OFFSET],mem[164+`OFFSET]}=32'b00000000000000000000001100010111;  //auipc x6,0 
{mem[167+`OFFSET],mem[166+`OFFSET],mem[165+`OFFSET],mem[164+`OFFSET]}=32'b00000000000000000000000001110011; //ecall


end


always@ (*)
begin
if (MemRead==1)
begin
//inst_out =0;
case(fun3)
	3'b000 :begin  if(mem[data_addr][7]==1)
				data_out={24'b111111111111111111111111,mem[data_addr]}; //LB
			else
				data_out={24'b000000000000000000000000,mem[data_addr]}; //LB
			end

	3'b001 :if(mem[data_addr+1][7]==1)
				data_out={16'b11111111_11111111,mem[data_addr+1],mem[data_addr]}; 
			else
				data_out={16'b0000000000000000,mem[data_addr+1],mem[data_addr]}; //LH
				
	3'b010 :data_out={mem[data_addr+3],mem[data_addr+2],mem[data_addr+1],mem[data_addr]};//LW
	3'b100 :data_out={24'b00000000_00000000_00000000,mem[data_addr]}; //LBU
	3'b101 :data_out={16'b00000000_00000000,mem[data_addr+1],mem[data_addr]};//LHU

	endcase
end
else 
data_out=0;

end

always@ (posedge clk)
begin
if (MemWrite==1)
begin 
inst_out =0;
case(fun3)
3'b000: mem[data_addr]=data_in[7:0]; //sb
3'b001: begin mem[data_addr]=data_in[7:0]; mem[data_addr+1]=data_in[15:8]; end//sh
3'b010: begin mem[data_addr]=data_in[7:0]; mem[data_addr+1]=data_in[15:8]; mem[data_addr+2]=data_in[23:16]; mem[data_addr+3]=data_in[31:24]; end //sw
endcase
end
end
always@(*)
begin
if((MemWrite==0)&&(MemRead==0))

inst_out ={mem[inst_addr+3],mem[inst_addr+2],mem[inst_addr+1],mem[inst_addr]};
end
assign out={data_out,inst_out};

endmodule

