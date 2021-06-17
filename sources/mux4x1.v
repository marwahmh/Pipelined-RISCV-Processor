`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2020 05:05:53 AM
// Design Name: 
// Module Name: mux4x1
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

module mux4x1 #(parameter n=8)(
    input [n-1:0]num1,
    input [n-1:0] num2,num3,num4,
    input [1:0]s,
    output reg [n-1:0] out
    );
    always@(*)
    begin
    case (s)
    2'b00: out= num1; //
    2'b01: out= num2;//
    2'b10: out= num3;//
    2'b11: out= num4;//
    default: out=0;
    endcase
    end
endmodule

