`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2020 09:33:20 AM
// Design Name: 
// Module Name: mux2x1
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


module mux2x1_nbit #(parameter N=32)(input [N-1:0]in1,input [N-1:0]in2,input s,output reg [N-1:0]out);
    always@(*)
    begin
    if(s==1)
    out=in2;
    else
    out=in1;
    end
endmodule
