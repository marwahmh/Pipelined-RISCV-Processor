`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2020 10:30:54 AM
// Design Name: 
// Module Name: test
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



module test1();
reg  clk;
reg  rst;



main m (.clk (clk), .rst (rst));

initial begin 
     clk = 0; 
     rst= 0; 
     end 
     
always begin  #5  clk =  ! clk; end

initial 
     begin 
     rst= 1;
     end 
/////////////////////test led/////////////////////////

initial begin 
#20
     rst= 0;


#20    
     rst= 0;
#20 
    
     rst=0;
///////////////////////////////////////////////////////
#20 
    
     rst=0;



#20 
    
     rst=0;


#20 
    
     rst=0;

    

#20 
    
     rst= 0;


end
endmodule
