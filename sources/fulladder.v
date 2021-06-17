`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2020 06:04:00 AM
// Design Name: 
// Module Name: fulladder
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


module fulladder  #(parameter n=8)( input [n-1:0] A, B, output [n-1:0] s);
wire [n:0]c;
assign c[0]=0;   
genvar i;
generate
for(i = 0; i < n; i = i+1)
begin
assign s[i]=A[i]^B[i]^c[i];
assign c[i+1]=(A[i]&B[i])|(A[i]&c[i])|(c[i]&B[i]);
end

endgenerate
endmodule

