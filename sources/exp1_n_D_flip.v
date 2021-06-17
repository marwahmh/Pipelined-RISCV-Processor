`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2020 09:16:38 AM
// Design Name: 
// Module Name: exp1_n_D_flip
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


module exp1_n_D_flip #(parameter n=8)(input clk,rst,load,input [n-1:0]d,output  [n-1:0]Q);
wire [n-1:0]out;
genvar j,i;
generate
for(j = 0; j < n; j = j+1)
begin
mux2x1 muxs(Q[j],d[j],load,out[j]);
DFlipFlop register(clk,rst,out[j],Q[j]);
end

endgenerate
endmodule
