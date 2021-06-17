`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2020 09:04:17 AM
// Design Name: 
// Module Name: main
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



module main( input clk,input rst);

wire [31:0] pc_counter,  pc_out,pc_out1 ,inst_out, sum_add_branch , pc_counter1;
wire [31:0] immgen_out, sum_add_4, read_data_mem, write_data;
wire [31:0] num1, num2,alu_out;
wire [31:0] read_data_1, read_data_2;
wire [4:0] rs1_id , rs2_id, rd_id, shamt_id,opcode_id;
wire [1:0] sel_pc,ALUOp,MemtoReg;
wire [6:0] func7_id;
wire [3:0] alufn;
wire [2:0] func3_id;
wire branch,MemRead,MemWrite, ALUSrc1 ,ALUSrc2, RegWrite, Halt,jal;
wire  cf, zf, vf, sf,ltf ,ltuf,TakeBranch;
//pipelining wires //fetching
wire [95:0] if_id_in, if_id_out;
wire [31:0] instruct_if;
//decoding wires
wire [31:0] pc_out_id,instruct_id, sum_add_4_id;
wire [195:0] id_ex_in,id_ex_out;
//executing wires
wire branch_ex, jal_ex , MemRead_ex, MemWrite_ex,  ALUSrc1_ex , ALUSrc2_ex, RegWrite_ex , Halt_ex; 
wire [1:0] ALUOp_ex, MemtoReg_ex;
wire [31:0]  sum_add_4_ex,pc_out_ex, read_data_1_ex, read_data_2_ex,immgen_out_ex;
wire [4:0] shamt_ex,rd_ex,rs1_ex,rs2_ex;
wire [2:0] func3_ex;
wire [6:0] func7_ex;
//memory stage wires
wire [145:0] ex_mem_in, ex_mem_out;
wire branch_mem,jal_mem,MemRead_mem,MemWrite_mem,RegWrite_mem,zf_mem,ltf_mem,ltuf_mem;
wire [1:0] MemtoReg_mem;
wire [31:0] sum_add_4_mem, alu_out_mem,read_data_2_mem,sum_add_branch_mem;
wire [2:0] func3_mem;
wire [4:0] rd_mem;
//wb stage wires
wire [103:0] mem_wb_in,mem_wb_out;
wire [1:0] MemtoReg_wb;
wire RegWrite_wb;
wire [31:0]sum_add_4_wb,alu_out_wb,read_datamem_wb;
wire[4:0] rd_wb;
//memory wires
wire [60:0] mem_in;
wire [63:0] mem_out;
wire stall_mem,stall_hazard;
wire [1:0] forwardA,forwardB;
wire [10:0] control_sig;
wire [6:0] control_sig_ex;
wire [31:0] read_data_1_ex1,read_data_1_ex2,read_data_2_ex1,read_data_2_ex2;

//fetching stage
        assign sel_pc ={jal_mem,TakeBranch}; 
        assign stall= stall_mem |stall_hazard ;
        mux4x1 #(32) mux1(sum_add_4 ,sum_add_branch_mem, alu_out_mem ,0, sel_pc , pc_counter1);  
        mux2x1_nbit mux_halt (pc_counter1, pc_out , Halt , pc_counter );   //halt                                

        //add mux here to select between pc_counter and pc_out (old pc) in case of halt
        exp1_n_D_flip #(32) pc ( clk,rst, ~stall, pc_counter, pc_out); ////changed enabler
        fulladder #(32) add1(  pc_out, 4, sum_add_4 ); 
        //InstMem  instruct_id_mem( pc_out[7:2],   instruct_if); 
        assign mem_in ={MemRead_mem,  MemWrite_mem, pc_out[11:0],alu_out_mem[11:0],func3_mem,read_data_2_mem};
         mem memory( ~clk, mem_in, mem_out);
        assign read_data_mem =mem_out [63:32] ;  
     //   assign instruct_if =mem_out [31:0] ; 
         
//decoding stage   
        inst_com com(mem_out [31:0],pc_out,inst_out,pc_out1);
        assign instruct_if =(((inst_out [6:2]==5'b11100 )&&!((inst_out [14:12]==3'b000) &&(inst_out[20]==0))) || (inst_out [6:2]==5'b00011) ||(sel_pc)  )? 32'd51 : inst_out[31:0]; // csr/fence/ebreak
       
        assign if_id_in ={ sum_add_4 , pc_out1,instruct_if};
        exp1_n_D_flip #(96) if_id (~clk,rst,~stall, if_id_in , if_id_out);
        
        assign sum_add_4_id= if_id_out [95:63];
        assign pc_out_id= if_id_out [63:32];
        assign instruct_id  = if_id_out [31:0];
        assign rs1_id= instruct_id[19:15];
        assign rs2_id= instruct_id[24:20];
        assign shamt_id =instruct_id[24:20];
        assign  rd_id = instruct_id[11:7];
        assign  opcode_id=instruct_id[6:2];
        assign func3_id= instruct_id[14:12];
        assign func7_id= instruct_id[31:25];
        
        hazard_detection hazard_detect( rs1_id,rs2_id,rd_ex, MemRead_ex ,stall_hazard);                               
        ControlUnit control(  opcode_id ,rst,  branch, jal , MemRead, MemWrite,  ALUSrc1 , ALUSrc2, RegWrite , Halt , ALUOp, MemtoReg );
        mux2x1_nbit #(11) CU_mux ({branch, jal , MemRead, MemWrite,  ALUSrc1 , ALUSrc2, RegWrite , ALUOp, MemtoReg}, 0 , stall|(sel_pc) , control_sig );                                    
        exp2 #(32) RF(clk, rst,RegWrite_wb,  write_data, rs1_id,rs2_id, rd_wb,  read_data_1, read_data_2); 
        rv32_ImmGen  immediate_gen(    instruct_id,    immgen_out ); 
        
        //Bonus no.4 attempt
      /*  wire [31:0] BranchCompInput1,BranchCompInput2;
        wire [1:0] ForwardBranch1,ForwardBranch2;
        forwarding_unit forward2( rs1_id,rs2_id,rd_mem,rd_wb,RegWrite_mem,RegWrite_wb,ForwardBranch1,ForwardBranch2);
        mux4x1  #(32) forwardaa(read_data_1,write_data,alu_out_mem ,0,ForwardBranch1,BranchCompInput1);       
        mux4x1  #(32) forwardbb(read_data_2,write_data,alu_out_mem ,0,ForwardBranch2,BranchCompInput2);   
        BranchComparator c1(BranchCompInput1,BranchCompInput2, branch , zf, ltf,ltuf);
        BranchingUnit branch_unit ( branch, zf , ltf , ltuf , func3_id ,  TakeBranch ); 
        fulladder #(32) add2( pc_out_id, immgen_out, sum_add_branch ); 
      */
           
        
//Executing stage       

        assign id_ex_in={rs1_id,control_sig, sum_add_4_id,pc_out_id,read_data_1, read_data_2,shamt_id,immgen_out,func3_id,func7_id,rd_id};
        exp1_n_D_flip #(196) id_ex (~clk,rst,1, id_ex_in,id_ex_out);
        

        assign rs1_ex = id_ex_out [195:191];
        //breaking the control_sig_ex insted of id_ex_out
        
        assign branch_ex = id_ex_out [190];
        assign jal_ex = id_ex_out [189];
        assign MemRead_ex = id_ex_out [188];
        assign MemWrite_ex = id_ex_out [187];
        assign ALUSrc1_ex = id_ex_out [186];
        assign ALUSrc2_ex = id_ex_out [185];
        assign RegWrite_ex = id_ex_out [184];
        assign ALUOp_ex = id_ex_out [183:182];
        assign MemtoReg_ex = id_ex_out [181:180];
        
        
        
        //breaking the rest of id_ex_out
        assign sum_add_4_ex = id_ex_out [179:148];
        assign pc_out_ex = id_ex_out [147:116];
        assign read_data_1_ex = id_ex_out [115:84];
        assign read_data_2_ex = id_ex_out [83:52];
        assign shamt_ex = id_ex_out [51:47];
        assign rs2_ex = id_ex_out [51:47];
        assign immgen_out_ex = id_ex_out [46:15];
        assign func3_ex = id_ex_out [14:12];
        assign func7_ex = id_ex_out [11:5];
        assign rd_ex = id_ex_out [4:0];
                                                   
        forwarding_unit forward( rs1_ex,rs2_ex,rd_mem,rd_wb,RegWrite_mem,RegWrite_wb,forwardA,forwardB);
                 //forwarding unit except for muxes

 
        mux4x1  #(32) forwarda(read_data_1_ex,write_data,alu_out_mem ,0,forwardA,read_data_1_ex1);        
        mux4x1  #(32) forwardb(read_data_2_ex,write_data,alu_out_mem ,0,forwardB,read_data_2_ex1);   
        mux2x1_nbit #(32) mux_alu_rs1 (read_data_1_ex1, pc_out_ex , ALUSrc1_ex , num1 );                                    
        mux2x1_nbit #(32) mux_alu_rs2 (read_data_2_ex1, immgen_out_ex, ALUSrc2_ex , num2 );  
        
        alu_control AUL_CON( func7_ex ,  ALUOp_ex, func3_ex, alufn );        
        prv32_ALU  alu (num1 , num2 ,shamt_ex, alu_out ,cf, zf, vf, sf,  alufn );
        fulladder #(32) add2( pc_out_ex, immgen_out_ex, sum_add_branch ); 
        
        //assigning the flags for less than and less than unsigned
        assign ltf=(sf != vf);
        assign ltuf=(~cf);
        
        mux2x1_nbit #(7) flush_ex ({branch_ex,jal_ex,MemRead_ex,MemWrite_ex,RegWrite_ex,MemtoReg_ex}, 0 , (sel_pc==1) , control_sig_ex ); 


//MEM stage
        assign ex_mem_in={control_sig_ex,sum_add_4_ex,alu_out,zf,ltf,ltuf,read_data_2_ex,sum_add_branch,func3_ex,rd_ex};
        exp1_n_D_flip #(146) ex_mem (~clk,rst,1, ex_mem_in,ex_mem_out);
 
        assign branch_mem = ex_mem_out[145];
        assign jal_mem = ex_mem_out[144];
        assign MemRead_mem = ex_mem_out[143];
        assign MemWrite_mem = ex_mem_out[142];
        assign RegWrite_mem = ex_mem_out[141];
        assign MemtoReg_mem = ex_mem_out[140:139];
        assign sum_add_4_mem = ex_mem_out[138:107];
        assign alu_out_mem = ex_mem_out[106:75];
        assign zf_mem = ex_mem_out[74];
        assign ltf_mem = ex_mem_out[73];
        assign ltuf_mem = ex_mem_out[72];
        assign read_data_2_mem = ex_mem_out[71:40];
        assign sum_add_branch_mem = ex_mem_out[39:8];
        assign func3_mem = ex_mem_out[7:5];
        assign rd_mem = ex_mem_out[4:0];

        assign stall_mem=(MemWrite_mem|MemRead_mem)?1:0; 
       
        BranchingUnit branch_unit ( branch_mem, zf_mem , ltf_mem , ltuf_mem , func3_mem ,  TakeBranch );

//WB stage
     
        assign mem_wb_in={MemtoReg_mem,RegWrite_mem,sum_add_4_mem,alu_out_mem,read_data_mem,rd_mem} ;
        exp1_n_D_flip #(104) mem_wb (~clk,rst,1, mem_wb_in,mem_wb_out);
        
        assign MemtoReg_wb = mem_wb_out[103:102];
        assign RegWrite_wb = mem_wb_out[101];
        assign sum_add_4_wb = mem_wb_out[100:69];
        assign alu_out_wb = mem_wb_out[68:37];
        assign read_datamem_wb = mem_wb_out[36:5];
        assign rd_wb = mem_wb_out[4:0];
        
        mux4x1 #(32) mux2( alu_out_wb , read_datamem_wb ,sum_add_4_wb , 0  , MemtoReg_wb, write_data); 

endmodule


