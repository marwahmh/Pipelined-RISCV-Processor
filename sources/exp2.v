`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2020 10:44:07 AM
// Design Name: 
// Module Name: exp2
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


module exp2 #(parameter n=32)( input clk, input reset,enable, input [n-1:0] in, input [4:0] regread1,regread2,regwrite, output [n-1:0] regout1, regout2);
 wire [31:0] load;
 wire [31:0] R [0:31];
 assign load = enable <<regwrite;
 generate 
     genvar i;
     for(i=0; i<n;i=i+1)
     begin 
       if (i==0)
                 exp1_n_D_flip #(n)register ( clk, reset, 0,  in , R[i]);
           else
    exp1_n_D_flip #(n)register ( clk, reset, load[i],  in , R[i]);
         end 
     endgenerate
assign regout1=R[regread1];
assign regout2= R[regread2];
endmodule
