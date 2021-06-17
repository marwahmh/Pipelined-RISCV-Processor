`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2020 04:52:56 PM
// Design Name: 
// Module Name: BranchingUnit
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

//zf: zero flag
//ltf: less than flag signed
//ltuf: less than flag unsigned 
module BranchingUnit(input Branch, zf,ltf,ltuf, [2:0] func3, output reg TakeBranch );
always @(*) begin
if (Branch)
begin

if ( (zf && (func3==3'b000) ) ||  (!zf && (func3==3'b001)) || (ltf && (func3==3'b100)) 
      || (!ltf && (func3==3'b101)) || (ltuf && (func3==3'b110)) || (!ltuf && (func3==3'b111)) ) 
TakeBranch=1;
else
TakeBranch=0;


end
else
TakeBranch=0;

end
    
endmodule
