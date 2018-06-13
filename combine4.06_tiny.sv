//memory change, make it automaticlly read
module Cell_SPU(clk,reset,PC,PC_Fe_1,PC_Fe_2,data_test_r2,data_test_r3, data_test_r4,data_test2,RC_LS_level6,RC_value_1,RC_value_temp_1,
	result_level6_pip1,PC_level7_1,PC_level7_2,result_level7_pip1, Data_LS,result_level1_pip1,result_level1_pip2,Imm_level1_2,
  control_level1_2, RA_value_level1_2,RB_value_level1_2,RC_value_level1_2, control_level1_1, RA_value_level1_1,RB_value_level1_1,RC_value_level1_1,
  PC_Dec_1, PC_Dec_2, PC_Dep_1, PC_Dep_2, PC_RF_1, PC_RF_2, PC_level1_1, PC_level1_2,PC_level2_1, PC_level2_2, PC_level3_1, PC_level3_2, PC_level4_1, PC_level4_2, PC_level5_1, PC_level5_2, PC_level6_1, PC_level6_2,
  pipe_Dec_1, pipe_Dec_2, instruction_Dec_1,instruction_Dec_2, instruction_Fe_1,instruction_Fe_2, Dep_Install_Initial, Install_Dep_pipe1, Install_Dep_pipe2,
  PC_result_level1_1, PC_result_level4_1, branch_level1_1,branch_level4_1);
input clk,reset;
logic [0:63] data_out;
output logic [0:31]PC;
output logic [0:127]data_test_r2, data_test_r3, data_test_r4;

///////////////////////////////////////////
///Variable for cache miss
logic cache_miss;
logic [0:1023] Mem_to_ILB;
logic [0:31] PC_temp;


///////////////////////////////////////////
///variable for Fetch stage
output logic [0:31]instruction_Fe_1,instruction_Fe_2;
output logic [0:31]PC_Fe_1,PC_Fe_2;
output logic [0:31] instruction_Dec_1,instruction_Dec_2;

///////////////////////////////////////////////
///variable for Decode stage
 logic [0:2] unit_Dec_1, latency_Dec_1;
 output logic [0:1] pipe_Dec_1, pipe_Dec_2;
 logic [0:6] RB_Dec_1, RC_Dec_1,  control_Dec_1; // RA, RB, RC is the source address. RT is the denstination address.
 logic [0:15] Imm_Dec_1; 
 output logic [0:31] PC_Dec_1, PC_Dec_2;;
 logic [0:2] unit_Dec_2, latency_Dec_2;
 //logic [0:1] pipe_Dec_2;
 logic [0:6] RA_Dec_2, RB_Dec_2, RC_Dec_2; // RA, RB, RC is the source address. RT is the denstination address.
 logic [0:15] Imm_Dec_2; 
 logic [0:6]RA_Dec_1,RT_Dec_1,RT_Dec_2;
 logic [0:6] control_Dec_2;

///////////////////////////////////////////////////
///variable for depdence stage
 logic [0:2] unit_Dep_1, latency_Dep_1;
 logic [0:1] pipe_Dep_1, pipe_Dep_2;
 logic [0:6] RA_Dep_1, RB_Dep_1, RC_Dep_1, RT_Dep_1, control_Dep_1; // RA, RB, RC is the source address. RT is the denstination address.
 logic [0:15] Imm_Dep_1; 
 output logic [0:31] PC_Dep_1, PC_Dep_2;
 logic [0:2] unit_Dep_2, latency_Dep_2;
 //logic [0:1] pipe_Dep_2;
 logic [0:6] RA_Dep_2, RB_Dep_2, RC_Dep_2, RT_Dep_2, control_Dep_2; // RA, RB, RC is the source address. RT is the denstination address.
 logic [0:15] Imm_Dep_2; 
 //logic [0:31] PC_Dep_2;

//////////////////////////////////////////////
///variable for Register Fetch stage
 logic [0:2] unit_RF_1, latency_RF_1;
 logic [0:1] pipe_RF_1;
 logic [0:6] RB_RF_1,RT_RF_1, control_RF_1; // RA, RB, RC is the source address. RT is the denstination address.
 logic [0:6]RA_RF_1,RT_RF_2,RC_RF_1;
 logic [0:15] Imm_RF_1; 
 output logic [0:31] PC_RF_1, PC_RF_2;
 logic [0:2] unit_RF_2, latency_RF_2;
 logic [0:1] pipe_RF_2;
 logic [0:6] RA_RF_2, RB_RF_2, RC_RF_2, control_RF_2; // RA, RB, RC is the source address. RT is the denstination address.
 logic [0:15] Imm_RF_2; 
 //logic [0:31] PC_RF_2;
  
 //////////////////////////////////////////
 ////variable for calculation
 logic [0:127]RA_value_1,RB_value_1;
 output logic [0:127] RC_value_1;
 logic [0:127]RA_value_2,RB_value_2,RC_value_2;
 	//temp value before RF stage.t
 logic [0:127] RA_value_temp_1,RB_value_temp_1,RA_value_temp_2,RB_value_temp_2,RC_value_temp_2;
 output logic [0:127]RC_value_temp_1;

//////////////////////////////////////////////
///variable for level_1
 logic [0:2] unit_level1_1, latency_level1_1;
 logic [0:1] pipe_level1_1;
 output logic [0:6] control_level1_1; // RA, RB, RC is the source address. RT is the denstination address.
 logic [0:15] Imm_level1_1; 
 output logic [0:31] PC_level1_1, PC_level1_2;
 logic [0:2] unit_level1_2, latency_level1_2;
 logic [0:1] pipe_level1_2;
 output logic [0:6] control_level1_2; // RA, RB, RC is the source address. RT is the denstination address.
 output logic [0:15] Imm_level1_2; 
 //logic [0:31] PC_level1_2;
 output logic [0:127] RB_value_level1_1,RC_value_level1_1,RA_value_level1_1;
 output logic [0:127] RA_value_level1_2,RB_value_level1_2,RC_value_level1_2;


 logic [0:6]RT_addr_level1_1,RT_addr_level1_2;
 output logic [0:127]result_level1_pip1,result_level1_pip2;
//////////////////////////////////////////////////
///variable for level_2
 output logic [0:31]PC_level2_1,PC_level2_2;
 logic [0:2]unit_level2_1,unit_level2_2;
 logic [0:2]latency_level2_1,latency_level2_2;
 logic [0:6]control_level2_1,control_level2_2;
 logic [0:6]RT_addr_level2_1,RT_addr_level2_2;
 logic [0:127]result_level2_pip1,result_level2_pip2;

///////////////////////////////////////////////
///variable for level 3
 output logic [0:31]PC_level3_1,PC_level3_2;
 logic [0:2]unit_level3_1,unit_level3_2;
 logic [0:2]latency_level3_1,latency_level3_2;
 logic [0:6]control_level3_1,control_level3_2;
 logic [0:6]RT_addr_level3_1,RT_addr_level3_2;
 logic [0:127]result_level3_pip1,result_level3_pip2;

///////////////////////////////////////////////
///variable for level4
 output logic [0:31]PC_level4_1,PC_level4_2;
 logic [0:2]unit_level4_1,unit_level4_2;
 logic [0:2]latency_level4_1,latency_level4_2;
 logic [0:6]control_level4_1,control_level4_2;
 logic [0:6]RT_addr_level4_1,RT_addr_level4_2;
 logic [0:127]result_level4_pip1,result_level4_pip2;

///////////////////////////////////////////////////
//variable for level5
 output logic [0:31]PC_level5_1,PC_level5_2;
 logic [0:2]unit_level5_1,unit_level5_2;
 logic [0:2]latency_level5_1,latency_level5_2;
 logic [0:6]control_level5_1,control_level5_2;
 logic [0:6]RT_addr_level5_1,RT_addr_level5_2;
 logic [0:127]result_level5_pip1,result_level5_pip2;

/////////////////////////////////////////////////
///variable for level 6
 output logic [0:31]PC_level6_1,PC_level6_2;
 logic [0:2]unit_level6_1,unit_level6_2;
 logic [0:2]latency_level6_1,latency_level6_2;
 logic [0:6]control_level6_1,control_level6_2;
 logic [0:6]RT_addr_level6_1,RT_addr_level6_2;
 logic [0:127]result_level6_pip2;

//////////////////////////////////////////
///variable for level 7
 output logic [0:31]PC_level7_1,PC_level7_2;
 logic [0:2]unit_level7_1,unit_level7_2;
 logic [0:2]latency_level7_1,latency_level7_2;
 logic [0:6]control_level7_1,control_level7_2;
 logic [0:6]RT_addr_level7_2;
 logic [0:127]result_level7_pip2;
 output logic [0:127]result_level7_pip1;
 logic wr_en_wrba_1;
 logic [0:6]RT_addr_level7_1;

////////////////////////////////////////////
////variable for branch calculation
 logic [0:31]PC_result_1,PC_result_2,PC_Cal_1,PC_Cal_2;
 logic wr_en_wrba_2;
 
 logic [0:127]RC_LS_level1,RC_LS_level2,RC_LS_level3,RC_LS_level4,RC_LS_level5;
 output logic [0:127]data_test2;
 output logic [0:127]Data_LS;
 output logic [0:127]RC_LS_level6;
 output logic [0:127]result_level6_pip1;
 logic wr_en_LS;

//////////////////////////////////////////////
///
logic Flush_level4, Flush_level3, Flush_level2, Flush_leve11, Flush_RF, Flush_Dep, Flush_Dec, Flush_Fe, Flush_ILB;
logic Install_Dep , Install_Dec, Install_Fe, Install_ILB;

//signal for hazard
logic Decode_Install_Initial; //The siganl to initilize the install in decode stage
logic store_check_flag; //signal to show store instruction in the pipeline
logic [0:1] WAW_Install_flag; //flag to show WAW hazard, 0 means no hazard found
logic [0:3]   forward_sig_RA1, forward_sig_RB1, forward_sig_RC1, forward_sig_RA2, forward_sig_RB2, forward_sig_RC2;
logic RA1_Install_flag, RB1_Install_flag, RC1_Install_flag, RA2_Install_flag, RB2_Install_flag, RC2_Install_flag;
logic RA1_Install_Dep_Ins, RB1_Install_Dep_Ins, RC1_Install_Dep_Ins, RA2_Install_Dep_Ins, RB2_Install_Dep_Ins, RC2_Install_Dep_Ins;

output logic Dep_Install_Initial; //The signal shows CPU needs to install, will be used for stage before the Dependence stage
output logic Install_Dep_pipe1, Install_Dep_pipe2;

output logic branch_level1_1;
logic branch_level1_2; 
logic branch_level2_1, branch_level2_2; 
logic branch_level3_1, branch_level3_2; 
output logic branch_level4_1;
logic  branch_level4_2; 



output logic [0:31] PC_result_level1_1;
logic [0:31] PC_result_level1_2; 
logic [0:31] PC_result_level2_1, PC_result_level2_2; 
logic [0:31] PC_result_level3_1, PC_result_level3_2; 
output logic [0:31] PC_result_level4_1;
logic  PC_result_level4_2; 



//================================================================================//
//                                                     ILB Rd
 ILB ILB_Fetch(clk,data_out,PC,Mem_to_ILB,cache_miss);

always_ff @(posedge clk) begin
   if (reset) begin
    PC<=0;
   end
   else if(cache_miss==1'b1)begin
	 PC<=PC;		//it's possible to have two no_zero PC in pipeline
   end
   else if(Flush_ILB == 1)begin
   	PC <= PC_result_level4_1; 
   end
   else if( Install_ILB == 1) begin
    PC <= PC;
   end
   else begin
   PC<=PC+32'd8;   
  end
end

//PC module for cache miss
//PC_temp denotes the first PC addresss of each block in the cache
always_comb begin
	PC_temp = PC & 32'hFFFFFF80;
end

//*** when branch is taken, use PC needed to be loaded from other places
//================================================================================//
//                                                      ILB Rd -> Fetch
assign Flush_ILB = branch_level4_1;
assign Install_ILB = Dep_Install_Initial || Decode_Install_Initial || Install_Dep_pipe1 || Install_Dep_pipe2 || WAW_Install_flag;

always_ff @(posedge clk) begin
 if(Flush_ILB == 1)begin
    PC_Fe_1 <=  32'd0;
    PC_Fe_2 <= 32'd0;
  instruction_Fe_1 = 32'd0;
  instruction_Fe_2 = 32'd0;
  end
  else if(Install_ILB == 1) begin
    PC_Fe_1 <=  PC_Fe_1;
    PC_Fe_2 <= PC_Fe_2;
  instruction_Fe_1 = instruction_Fe_1;
  instruction_Fe_2 = instruction_Fe_2;
  end
  else begin
    PC_Fe_1<=PC;
    PC_Fe_2<=PC+32'd4;
  instruction_Fe_1 <= data_out[0:31];
  instruction_Fe_2 <= data_out[32:63];
  end
end


//================================================================================//
//							Fetch Stage											  
/*always_comb begin
  instruction_Fe_1 = data_out[0:31];
  instruction_Fe_2 = data_out[32:63];
end */

assign Install_Fe = Dep_Install_Initial || Install_Dep_pipe1 || Install_Dep_pipe2 || WAW_Install_flag;
assign Flush_Fe = branch_level4_1;

//==============================================================================//
//							Fetch -> Decode                                      
always_ff @(posedge clk) begin
   if (Flush_Fe == 1) begin //branch taken 
   PC_Dec_1<=32'd0;
   PC_Dec_2<=32'd0;
   instruction_Dec_1 <= 32'd0;
   instruction_Dec_2 <= 32'd0;
   end
   else if(Install_Fe == 1) begin //The data hazard
   PC_Dec_1<=PC_Dec_1;
   PC_Dec_2<=PC_Dec_2;
   instruction_Dec_1 <= instruction_Dec_1;
   instruction_Dec_2 <= instruction_Dec_2;
   end 
   else if(Decode_Install_Initial == 1)begin //The structural hazard
	   	if(PC_Dec_1 > PC_Dec_2) begin
	    	PC_Dec_1<=PC_Dec_1;  
	    	instruction_Dec_1 <= instruction_Dec_1;
	    	PC_Dec_2<=32'd0;
	    	instruction_Dec_2 <= 32'd0;
	    end
	    else begin
	   		PC_Dec_1<=32'd0;
	   		instruction_Dec_1 <= 32'd0;
	   		PC_Dec_2<=PC_Dec_2;
	   		instruction_Dec_2 <= instruction_Dec_2;
	    end // else
   end // else if(Decode_Install_Initial == 1)end
   else begin
   PC_Dec_1<=PC_Fe_1;
   PC_Dec_2<=PC_Fe_2;
   instruction_Dec_1 <= instruction_Fe_1;
   instruction_Dec_2 <= instruction_Fe_2;
   end
end

//================================================================================//
//							Decode Stage										
//Decode
decode_mod decode_inst_1(instruction_Dec_1,unit_Dec_1,pipe_Dec_1,latency_Dec_1,control_Dec_1,Imm_Dec_1,RA_Dec_1,RB_Dec_1,RC_Dec_1,RT_Dec_1);
decode_mod decode_inst_2(instruction_Dec_2,unit_Dec_2,pipe_Dec_2,latency_Dec_2,control_Dec_2,Imm_Dec_2,RA_Dec_2,RB_Dec_2,RC_Dec_2,RT_Dec_2);

always_comb begin
	if((pipe_Dec_1 == 2'd1 && pipe_Dec_2 == 2'd1) || (pipe_Dec_1 == 2'd0 && pipe_Dec_2 == 2'd0)) //The two instruction use even pip or odd pipe at the same time
		Decode_Install_Initial =1;
	else
		Decode_Install_Initial = 0;
end

//==============================================================================//
//							Decode -> Dependence                         
assign Flush_Dec = branch_level4_1;
assign Install_Dec = Dep_Install_Initial;

always_ff @(posedge clk) begin//Decode->Dependency
	//////////////////////////////////////////////////
	if (Flush_Dec== 1) begin //flush has the most priority
          PC_Dep_1<=32'd0;
          unit_Dep_1<=3'd8;
          latency_Dep_1<=3'd1;
          control_Dep_1<=7'd85;
          Imm_Dep_1<=16'd0;
          RA_Dep_1<=7'd0;
          RB_Dep_1<=7'd0;
          RC_Dep_1<=7'd0;
          RT_Dep_1<=7'd0;
        /////////////////////////////////////////////////
          PC_Dep_2<=32'd0;
          unit_Dep_2<=3'd8;
          latency_Dep_2<=3'd1;
          control_Dep_2<=7'd85;
          Imm_Dep_2<=16'd0;
          RA_Dep_2<=7'd0;
          RB_Dep_2<=7'd0;
          RC_Dep_2<=7'd0;
          RT_Dep_2<=7'd0; 
  end
  else if (Install_Dec== 1) begin  //Install from the data hazard
          PC_Dep_1<=PC_Dep_1;
          unit_Dep_1<=unit_Dep_1;
          latency_Dep_1<=latency_Dep_1;
          control_Dep_1<=control_Dep_1;
          Imm_Dep_1<=Imm_Dep_1;
          RA_Dep_1<=RA_Dep_1;
          RB_Dep_1<=RB_Dep_1;
          RC_Dep_1<=RC_Dep_1;
          RT_Dep_1<=RT_Dep_1;
        /////////////////////////////////////////////////
          PC_Dep_2<=PC_Dep_2;
          unit_Dep_2<=unit_Dep_2;
          latency_Dep_2<=latency_Dep_2;
          control_Dep_2<=control_Dep_2;
          Imm_Dep_2<=Imm_Dep_2;
          RA_Dep_2<=RA_Dep_2;
          RB_Dep_2<=RB_Dep_2;
          RC_Dep_2<=RC_Dep_2;
          RT_Dep_2<=RT_Dep_2; 
  end
  else if(Install_Dep_pipe1 == 1 || WAW_Install_flag == 1) begin
          PC_Dep_1<=PC_Dep_1;
          unit_Dep_1<=unit_Dep_1;
          latency_Dep_1<=latency_Dep_1;
          control_Dep_1<=control_Dep_1;
          Imm_Dep_1<=Imm_Dep_1;
          RA_Dep_1<=RA_Dep_1;
          RB_Dep_1<=RB_Dep_1;
          RC_Dep_1<=RC_Dep_1;
          RT_Dep_1<=RT_Dep_1;   
        ///////////////////////////////////////////////// 
          PC_Dep_2<=32'd0;
          unit_Dep_2<=3'd8;
          latency_Dep_2<=3'd1;
          control_Dep_2<=7'd85;
          Imm_Dep_2<=16'd0;
          RA_Dep_2<=7'd0;
          RB_Dep_2<=7'd0;
          RC_Dep_2<=7'd0;
          RT_Dep_2<=7'd0;
  end
  else if(Install_Dep_pipe2 == 1 || WAW_Install_flag == 1) begin
          PC_Dep_1<=32'd0;
          unit_Dep_1<=3'd8;
          latency_Dep_1<=3'd1;
          control_Dep_1<=7'd85;
          Imm_Dep_1<=16'd0;
          RA_Dep_1<=7'd0;
          RB_Dep_1<=7'd0;
          RC_Dep_1<=7'd0;
          RT_Dep_1<=7'd0;
            /////////////////////////////////////////////////
          PC_Dep_2<=PC_Dep_2;
          unit_Dep_2<=unit_Dep_2;
          latency_Dep_2<=latency_Dep_2;
          control_Dep_2<=control_Dep_2;
          Imm_Dep_2<=Imm_Dep_2;
          RA_Dep_2<=RA_Dep_2;
          RB_Dep_2<=RB_Dep_2;
          RC_Dep_2<=RC_Dep_2;
          RT_Dep_2<=RT_Dep_2; 
  end
  else if (Decode_Install_Initial == 1)begin //The dependence in the same stage
  	if(PC_Dec_1 > PC_Dec_2) begin
  		if(pipe_Dec_2 == 2'd1) begin
		   PC_Dep_1<=32'd0;
          unit_Dep_1<=3'd8;
          latency_Dep_1<=3'd1;
          control_Dep_1<=7'd85;
          Imm_Dep_1<=16'd0;
          RA_Dep_1<=7'd0;
          RB_Dep_1<=7'd0;
          RC_Dep_1<=7'd0;
          RT_Dep_1<=7'd0;
        /////////////////////////////////////////////////
          PC_Dep_2<=PC_Dec_2;
          unit_Dep_2<=unit_Dec_2;
          latency_Dep_2<=latency_Dec_2;
          control_Dep_2<=control_Dec_2;
          Imm_Dep_2<=Imm_Dec_2;
          RA_Dep_2<=RA_Dec_2;
          RB_Dep_2<=RB_Dec_2;
          RC_Dep_2<=RC_Dec_2;
          RT_Dep_2<=RT_Dec_2;
      end
      else begin
      	  PC_Dep_1<=PC_Dec_2;
          unit_Dep_1<=unit_Dec_2;
          latency_Dep_1<=latency_Dec_2;
          control_Dep_1<=control_Dec_2;
          Imm_Dep_1<=Imm_Dec_2;
          RA_Dep_1<=RA_Dec_2;
          RB_Dep_1<=RB_Dec_2;
          RC_Dep_1<=RC_Dec_2;
          RT_Dep_1<=RT_Dec_2;
          ////////////////////////////////
          PC_Dep_2<=32'd0;
          unit_Dep_2<=3'd8;
          latency_Dep_2<=3'd1;
          control_Dep_2<=7'd85;
          Imm_Dep_2<=16'd0;
          RA_Dep_2<=7'd0;
          RB_Dep_2<=7'd0;
          RC_Dep_2<=7'd0;
          RT_Dep_2<=7'd0;
      end
  	end // if(PC_Dec_1 > PC_Dep_2)
  	else if(PC_Dec_2 > PC_Dec_1) begin
  		if(pipe_Dec_1 == 2'd0) begin
          PC_Dep_1<=PC_Dec_1;
          unit_Dep_1<=unit_Dec_1;
          latency_Dep_1<=latency_Dec_1;
          control_Dep_1<=control_Dec_1;
          Imm_Dep_1<=Imm_Dec_1;
          RA_Dep_1<=RA_Dec_1;
          RB_Dep_1<=RB_Dec_1;
          RC_Dep_1<=RC_Dec_1;
          RT_Dep_1<=RT_Dec_1;     
        ///////////////////////////////////////////////// 
          PC_Dep_2<=32'd0;
          unit_Dep_2<=3'd8;
          latency_Dep_2<=3'd1;
          control_Dep_2<=7'd85;
          Imm_Dep_2<=16'd0;
          RA_Dep_2<=7'd0;
          RB_Dep_2<=7'd0;
          RC_Dep_2<=7'd0;
          RT_Dep_2<=7'd0;
        end
        else begin
          PC_Dep_1<=32'd0;
          unit_Dep_1<=3'd8;
          latency_Dep_1<=3'd1;
          control_Dep_1<=7'd85;
          Imm_Dep_1<=16'd0;
          RA_Dep_1<=7'd0;
          RB_Dep_1<=7'd0;
          RC_Dep_1<=7'd0;
          RT_Dep_1<=7'd0;
         /////////////////////////////////////////////////
        //even pipe
          PC_Dep_2<=PC_Dec_1;
          unit_Dep_2<=unit_Dec_1;
          latency_Dep_2<=latency_Dec_1;
          control_Dep_2<=control_Dec_1;
          Imm_Dep_2<=Imm_Dec_1;
          RA_Dep_2<=RA_Dec_1;
          RB_Dep_2<=RB_Dec_1;
          RC_Dep_2<=RC_Dec_1;
          RT_Dep_2<=RT_Dec_1;
          end 	
  	end // if(PC_Dec_1 > PC_Dep_2)
  end  
  else if ((pipe_Dec_1==2'd1 && pipe_Dec_2==2'd3)||(pipe_Dec_1==2'd3 && pipe_Dec_2==2'd0)||(pipe_Dec_1==2'd1 && pipe_Dec_2==2'd0)) begin
  		//////////////////////////////////////////////////
  		//odd pipe
          PC_Dep_1<=PC_Dec_2;
          unit_Dep_1<=unit_Dec_2;
          latency_Dep_1<=latency_Dec_2;
          control_Dep_1<=control_Dec_2;
          Imm_Dep_1<=Imm_Dec_2;
          RA_Dep_1<=RA_Dec_2;
          RB_Dep_1<=RB_Dec_2;
          RC_Dep_1<=RC_Dec_2;
          RT_Dep_1<=RT_Dec_2;
        /////////////////////////////////////////////////
        //even pipe
          PC_Dep_2<=PC_Dec_1;
          unit_Dep_2<=unit_Dec_1;
          latency_Dep_2<=latency_Dec_1;
          control_Dep_2<=control_Dec_1;
          Imm_Dep_2<=Imm_Dec_1;
          RA_Dep_2<=RA_Dec_1;
          RB_Dep_2<=RB_Dec_1;
          RC_Dep_2<=RC_Dec_1;
          RT_Dep_2<=RT_Dec_1;      
  end
  else begin //If the pipe is right or miss instruction, then nothing need to be changed
          PC_Dep_1<=PC_Dec_1;
          unit_Dep_1<=unit_Dec_1;
          latency_Dep_1<=latency_Dec_1;
          control_Dep_1<=control_Dec_1;
          Imm_Dep_1<=Imm_Dec_1;
          RA_Dep_1<=RA_Dec_1;
          RB_Dep_1<=RB_Dec_1;
          RC_Dep_1<=RC_Dec_1;
          RT_Dep_1<=RT_Dec_1;
        /////////////////////////////////////////////////
          PC_Dep_2<=PC_Dec_2;
          unit_Dep_2<=unit_Dec_2;
          latency_Dep_2<=latency_Dec_2;
          control_Dep_2<=control_Dec_2;
          Imm_Dep_2<=Imm_Dec_2;
          RA_Dep_2<=RA_Dec_2;
          RB_Dep_2<=RB_Dec_2;
          RC_Dep_2<=RC_Dec_2;
          RT_Dep_2<=RT_Dec_2;      
  end
end
//================================================================================//
//							Dependence Stage			     					  
//In the dependence stage all the data hazard has been solved by Install untill it can be 
//data forward
data_hazard data_hazard_RA_pip1(RA_Dep_1,control_Dep_1,RT_RF_1,RT_addr_level1_1,RT_addr_level2_1,RT_addr_level3_1,RT_addr_level4_1,RT_addr_level5_1,RT_addr_level6_1,
  RT_RF_2,RT_addr_level1_2,RT_addr_level2_2,RT_addr_level3_2,RT_addr_level4_2,RT_addr_level5_2,RT_addr_level6_2,
  latency_level1_1,latency_level2_1,latency_level3_1,latency_level4_1,latency_level5_1,latency_level6_1,
  latency_level1_2,latency_level2_2,latency_level3_2,latency_level4_2,latency_level5_2,latency_level6_2,
  PC_Dep_1, PC_Dep_2, RT_Dep_2,
  forward_sig_RA1,RA1_Install_flag, RA1_Install_Dep_Ins, store_check_flag); 
data_hazard data_hazard_RB_pip1(RB_Dep_1,control_Dep_1,RT_RF_1,RT_addr_level1_1,RT_addr_level2_1,RT_addr_level3_1,RT_addr_level4_1,RT_addr_level5_1,RT_addr_level6_1,
  RT_RF_2,RT_addr_level1_2,RT_addr_level2_2,RT_addr_level3_2,RT_addr_level4_2,RT_addr_level5_2,RT_addr_level6_2,
  latency_level1_1,latency_level2_1,latency_level3_1,latency_level4_1,latency_level5_1,latency_level6_1,
  latency_level1_2,latency_level2_2,latency_level3_2,latency_level4_2,latency_level5_2,latency_level6_2,
  PC_Dep_1, PC_Dep_2, RT_Dep_2,
  forward_sig_RB1,RB1_Install_flag, RB1_Install_Dep_Ins, store_check_flag); 
data_hazard data_hazard_RC_pip1(RC_Dep_1,control_Dep_1,RT_RF_1,RT_addr_level1_1,RT_addr_level2_1,RT_addr_level3_1,RT_addr_level4_1,RT_addr_level5_1,RT_addr_level6_1,
  RT_RF_2,RT_addr_level1_2,RT_addr_level2_2,RT_addr_level3_2,RT_addr_level4_2,RT_addr_level5_2,RT_addr_level6_2,
  latency_level1_1,latency_level2_1,latency_level3_1,latency_level4_1,latency_level5_1,latency_level6_1,
  latency_level1_2,latency_level2_2,latency_level3_2,latency_level4_2,latency_level5_2,latency_level6_2,
  PC_Dep_1, PC_Dep_2, RT_Dep_2,
  forward_sig_RC1,RC1_Install_flag, RC1_Install_Dep_Ins, store_check_flag);

data_hazard data_hazard_RA_pip2(RA_Dep_2,control_Dep_1,RT_RF_1,RT_addr_level1_1,RT_addr_level2_1,RT_addr_level3_1,RT_addr_level4_1,RT_addr_level5_1,RT_addr_level6_1,
  RT_RF_2,RT_addr_level1_2,RT_addr_level2_2,RT_addr_level3_2,RT_addr_level4_2,RT_addr_level5_2,RT_addr_level6_2,
  latency_level1_1,latency_level2_1,latency_level3_1,latency_level4_1,latency_level5_1,latency_level6_1,
  latency_level1_2,latency_level2_2,latency_level3_2,latency_level4_2,latency_level5_2,latency_level6_2,
  PC_Dep_2, PC_Dep_1, RT_Dep_1,
  forward_sig_RA2,RA2_Install_flag, RA2_Install_Dep_Ins, store_check_flag); 
data_hazard data_hazard_RB_pip2(RB_Dep_2,control_Dep_1,RT_RF_1,RT_addr_level1_1,RT_addr_level2_1,RT_addr_level3_1,RT_addr_level4_1,RT_addr_level5_1,RT_addr_level6_1,
  RT_RF_2,RT_addr_level1_2,RT_addr_level2_2,RT_addr_level3_2,RT_addr_level4_2,RT_addr_level5_2,RT_addr_level6_2,
  latency_level1_1,latency_level2_1,latency_level3_1,latency_level4_1,latency_level5_1,latency_level6_1,
  latency_level1_2,latency_level2_2,latency_level3_2,latency_level4_2,latency_level5_2,latency_level6_2,
  PC_Dep_2, PC_Dep_1, RT_Dep_1,
  forward_sig_RB2,RB2_Install_flag, RB2_Install_Dep_Ins, store_check_flag); 
data_hazard data_hazard_RC_pip2(RC_Dep_2,control_Dep_1,RT_RF_1,RT_addr_level1_1,RT_addr_level2_1,RT_addr_level3_1,RT_addr_level4_1,RT_addr_level5_1,RT_addr_level6_1,
  RT_RF_2,RT_addr_level1_2,RT_addr_level2_2,RT_addr_level3_2,RT_addr_level4_2,RT_addr_level5_2,RT_addr_level6_2,
  latency_level1_1,latency_level2_1,latency_level3_1,latency_level4_1,latency_level5_1,latency_level6_1,
  latency_level1_2,latency_level2_2,latency_level3_2,latency_level4_2,latency_level5_2,latency_level6_2,
  PC_Dep_2, PC_Dep_1, RT_Dep_1,
  forward_sig_RC2,RC2_Install_flag, RC2_Install_Dep_Ins, store_check_flag);


store_check store_check(store_check_flag, control_RF_1, control_RF_2,control_level1_1, control_level1_2,control_level2_1, control_level2_2,
 control_level3_1, control_level3_2,control_level4_1, control_level4_2,control_level5_1, control_level5_2,control_level6_1, control_level6_2);


WAW_hazard WAW_harzard(WAW_Install_flag, RT_Dep_1, RT_Dep_2, PC_Dep_1, PC_Dep_2);

assign Dep_Install_Initial = (RA1_Install_flag || RB1_Install_flag || RC1_Install_flag || RA2_Install_flag || RB2_Install_flag || RC2_Install_flag);

//==============================================================================//
//					               Dependence  -> Register Fetch                   

assign Install_Dep_pipe1 = (RA1_Install_Dep_Ins || RB1_Install_Dep_Ins || RC1_Install_Dep_Ins );
assign Install_Dep_pipe2 = (RA2_Install_Dep_Ins || RB2_Install_Dep_Ins || RC2_Install_Dep_Ins );
assign Flush_Dep = branch_level4_1;


always_ff @(posedge clk) begin//Dep->RF
  if(Flush_Dep == 1 || Dep_Install_Initial) begin //stall here 
          PC_RF_1<=0;
          unit_RF_1<=3'd8;
          latency_RF_1<=3'd1;
          control_RF_1<=7'd85;
          Imm_RF_1<=0;
          RA_RF_1<=0;
          RB_RF_1<=0;
          RC_RF_1<=0;
          RT_RF_1<=0;
          ///////////////////
          PC_RF_2<=0;
          unit_RF_2<=3'd8;
          latency_RF_2<=3'd1;
          control_RF_2<=7'd85;
          Imm_RF_2<=0;
          RA_RF_2<=0;
          RB_RF_2<=0;
          RC_RF_2<=0;
          RT_RF_2<=0;    
  end
  else if(Install_Dep_pipe1 == 1 || WAW_Install_flag == 1) begin
          PC_RF_1<=32'd0;
          unit_RF_1<=3'd8;
          latency_RF_1<=3'd1;
          control_RF_1<=7'd85;
          Imm_RF_1<=16'd0;
          RA_RF_1<=7'd0;
          RB_RF_1<=7'd0;
          RC_RF_1<=7'd0;
          RT_RF_1<=7'd0;
        ///////////////////
          PC_RF_2<=PC_Dep_2;
          unit_RF_2<=unit_Dep_2;
          latency_RF_2<=latency_Dep_2;
          control_RF_2<=control_Dep_2;
          Imm_RF_2<=Imm_Dep_2;
          RA_RF_2<=RA_Dep_2;
          RB_RF_2<=RB_Dep_2;
          RC_RF_2<=RC_Dep_2;
          RT_RF_2<=RT_Dep_2;  
  end 
  else if(Install_Dep_pipe2 == 1 || WAW_Install_flag == 2) begin
          PC_RF_1<=PC_Dep_1;
          unit_RF_1<=unit_Dep_1;
          latency_RF_1<=latency_Dep_1;
          control_RF_1<=control_Dep_1;
          Imm_RF_1<=Imm_Dep_1;
          RA_RF_1<=RA_Dep_1;
          RB_RF_1<=RB_Dep_1;
          RC_RF_1<=RC_Dep_1;
          RT_RF_1<=RT_Dep_1;
        ///////////////////
          PC_RF_2<=32'd0;
          unit_RF_2<=3'd8;
          latency_RF_2<=3'd1;
          control_RF_2<=7'd85;
          Imm_RF_2<=16'd0;
          RA_RF_2<=7'd0;
          RB_RF_2<=7'd0;
          RC_RF_2<=7'd0;
          RT_RF_2<=7'd0;  
  end
  else begin
          PC_RF_1<=PC_Dep_1;
          unit_RF_1<=unit_Dep_1;
          latency_RF_1<=latency_Dep_1;
          control_RF_1<=control_Dep_1;
          Imm_RF_1<=Imm_Dep_1;
          RA_RF_1<=RA_Dep_1;
          RB_RF_1<=RB_Dep_1;
          RC_RF_1<=RC_Dep_1;
          RT_RF_1<=RT_Dep_1;
          ///////////////////
          PC_RF_2<=PC_Dep_2;
          unit_RF_2<=unit_Dep_2;
          latency_RF_2<=latency_Dep_2;
          control_RF_2<=control_Dep_2;
          Imm_RF_2<=Imm_Dep_2;
          RA_RF_2<=RA_Dep_2;
          RB_RF_2<=RB_Dep_2;
          RC_RF_2<=RC_Dep_2;
          RT_RF_2<=RT_Dep_2;    
  end 
end


//================================================================================//
//							Register Fetch Stage			     	        	                  
Register register_RF (clk,reset, wr_en_wrba_1,wr_en_wrba_2, result_level7_pip1, result_level7_pip2,
                          RA_RF_1, RB_RF_1,RC_RF_1, RA_RF_2,RB_RF_2, RC_RF_2,RT_addr_level7_1,RT_addr_level7_2,
                          RA_value_temp_1,RB_value_temp_1,RC_value_temp_1,RA_value_temp_2,RB_value_temp_2,RC_value_temp_2,data_test_r2, data_test_r3,data_test_r4);


hazard_RF hazard_RF_RA_pip1(clk,result_level2_pip1, result_level3_pip1, result_level4_pip1, result_level5_pip1, result_level6_pip1, result_level7_pip1,
result_level2_pip2, result_level3_pip2, result_level4_pip2, result_level5_pip2, result_level6_pip2, result_level7_pip2,
RA_value_1,forward_sig_RA1,RA_value_temp_1);
hazard_RF hazard_RF_RB_pip1(clk,result_level2_pip1, result_level3_pip1, result_level4_pip1, result_level5_pip1, result_level6_pip1, result_level7_pip1,
result_level2_pip2, result_level3_pip2, result_level4_pip2, result_level5_pip2, result_level6_pip2, result_level7_pip2,
RB_value_1,forward_sig_RB1,RB_value_temp_1);
hazard_RF hazard_RF_RC_pip1(clk,result_level2_pip1, result_level3_pip1, result_level4_pip1, result_level5_pip1, result_level6_pip1, result_level7_pip1,
result_level2_pip2, result_level3_pip2, result_level4_pip2, result_level5_pip2, result_level6_pip2, result_level7_pip2,
RC_value_1,forward_sig_RC1,RC_value_temp_1);
hazard_RF hazard_RF_RA_pip2(clk,result_level2_pip1, result_level3_pip1, result_level4_pip1, result_level5_pip1, result_level6_pip1, result_level7_pip1,
result_level2_pip2, result_level3_pip2, result_level4_pip2, result_level5_pip2, result_level6_pip2, result_level7_pip2,
RA_value_2,forward_sig_RA2,RA_value_temp_2);
hazard_RF hazard_RF_RB_pip2(clk,result_level2_pip1, result_level3_pip1, result_level4_pip1, result_level5_pip1, result_level6_pip1, result_level7_pip1,
result_level2_pip2, result_level3_pip2, result_level4_pip2, result_level5_pip2, result_level6_pip2, result_level7_pip2,
RB_value_2,forward_sig_RB2,RB_value_temp_2);
hazard_RF hazard_RF_RC_pip2(clk,result_level2_pip1, result_level3_pip1, result_level4_pip1, result_level5_pip1, result_level6_pip1, result_level7_pip1,
result_level2_pip2, result_level3_pip2, result_level4_pip2, result_level5_pip2, result_level6_pip2, result_level7_pip2,
RC_value_2,forward_sig_RC2,RC_value_temp_2);

//==============================================================================//
//					            Register Fetch -> Calculation(level1)    
assign Flush_RF = branch_level4_1;                           
always_ff @(posedge clk) begin  //RF->Calculation
  if(Flush_RF == 1) begin
    PC_level1_1<=0;
    unit_level1_1<=3'd8;
    latency_level1_1<=3'd1;
    control_level1_1<=7'd85;
    Imm_level1_1<=0;
    RA_value_level1_1<=0;
    RB_value_level1_1<=0;
    RC_value_level1_1<=0;
    RC_LS_level1<= 0; //The value of RC will be used in load operation.
    RT_addr_level1_1<=0;
    ///////////////////
    PC_level1_2<=0;
    unit_level1_2<=3'd8;
    latency_level1_2<=3'd1;
    control_level1_2<=7'd85;
    Imm_level1_2<=0;
    RA_value_level1_2<=0;
    RB_value_level1_2<=0;
    RC_value_level1_2<=0;
    RC_LS_level2<= 0; //The value of RC will be used in load operation, which is different with the SPU cell;
    RT_addr_level1_2<=0; 
  end
  else begin
    PC_level1_1<=PC_RF_1;
    unit_level1_1<=unit_RF_1;
    latency_level1_1<=latency_RF_1;
    Imm_level1_1<=Imm_RF_1;
    control_level1_1<=control_RF_1;
    RA_value_level1_1<=RA_value_1;
    RB_value_level1_1<=RB_value_1;
    RC_value_level1_1<=RC_value_1;
    RC_LS_level1<=RC_value_1;
    RT_addr_level1_1 <= RT_RF_1;
    /////////////////////////////
    PC_level1_2<=PC_RF_2;
    unit_level1_2<=unit_RF_2;
    latency_level1_2<=latency_RF_2;
    Imm_level1_2<=Imm_RF_2;
    control_level1_2<=control_RF_2;
    RA_value_level1_2<=RA_value_2;
    RB_value_level1_2<=RB_value_2;
    RC_value_level1_2<=RC_value_2;
    RT_addr_level1_2 <= RT_RF_2;
  end
end

//=================================================================================//
//							Calculation Stage	   		     	        	         
//                                                                 level1
	Ins_Cal Level1_Cal_pipe1(.control_level(control_level1_1), .RA_value_level(RA_value_level1_1), .RB_value_level(RB_value_level1_1), 
						.RC_value_level(RC_value_level1_1), .Imm(Imm_level1_1), .result(result_level1_pip1), .PC_Cal(PC_level1_1),.PC_result(PC_result_level1_1), .branch_flag(branch_level1_1));
	Ins_Cal Level1_Cal_pipe2(.control_level(control_level1_2), .RA_value_level(RA_value_level1_2), .RB_value_level(RB_value_level1_2), 
						.RC_value_level(RC_value_level1_2), .Imm(Imm_level1_2), .result(result_level1_pip2), .PC_Cal(PC_level1_2),.PC_result(PC_result_level1_2), .branch_flag(branch_level1_2));

 //module Ins_Cal (control_level,RA_value_level,RB_value_level,RC_value_level,Imm,result,PC_Cal,PC_result,branch_flag);

//=================================================================================//
//							Six delay Stage	   		
/*------------------------------------------------------------------------------
--  			level1 to level 2
------------------------------------------------------------------------------*/
assign Flush_leve11 = branch_level4_1;     	        	             
always_ff @(posedge clk) begin  //level1->level2
  if(Flush_leve11 == 1) begin
  ///////////////////////////////////
  /////pipe1
  PC_level2_1<=32'd0;
  unit_level2_1<= 3'd8;
  latency_level2_1<=3'd1;
  control_level2_1<=7'd85;
  RT_addr_level2_1 <= 7'd0;
  result_level2_pip1 <= 128'd0;
  RC_LS_level2 <= 128'd0;
  PC_result_level2_1 <= 32'd0;
  branch_level2_1 <= 0;
  //////////////////////////////////////////
  /////pipe2
  PC_level2_2<=32'd0;
  unit_level2_2<= 3'd8;
  latency_level2_2<= 3'd1;
  control_level2_2<=7'd85;
  RT_addr_level2_2 <= 7'd0;
  result_level2_pip2 <= 128'd0;
  PC_result_level2_2 <= 32'd0;
  branch_level2_2 <= 0;
  end
  else begin
    ///////////////////////////////////
    /////pipe1
    PC_level2_1<=PC_level1_1;
    unit_level2_1<= unit_level1_1;
    latency_level2_1<=latency_level1_1;
    control_level2_1<=control_level1_1;
    RT_addr_level2_1 <= RT_addr_level1_1;
    result_level2_pip1 <= result_level1_pip1;
    RC_LS_level2 <= RC_LS_level1;
    PC_result_level2_1 <= PC_result_level1_1;
    branch_level2_1 <=  branch_level1_1;
    //////////////////////////////////////////
    /////pipe2
    PC_level2_2<=PC_level1_2;
    unit_level2_2<= unit_level1_2;
    latency_level2_2<=latency_level1_2;
    control_level2_2<=control_level1_2;
    RT_addr_level2_2 <= RT_addr_level1_2;
    result_level2_pip2 <= result_level1_pip2;
    PC_result_level2_2<= PC_result_level1_2;
    branch_level2_2 <=  branch_level1_2;
  end
end

/*------------------------------------------------------------------------------
--  		level2 to level3
------------------------------------------------------------------------------*/
assign Flush_level2 = branch_level4_1;

always_ff @(posedge clk) begin  //level2->level3
  if(Flush_level2 == 1)begin
  ///////////////////////////////////
  /////pipe1
  PC_level3_1<=32'd0;
  unit_level3_1<= 3'd8;
  latency_level3_1<=3'd1;
  control_level3_1<=7'd85;
  RT_addr_level3_1 <= 7'd0;
  result_level3_pip1 <= 128'd0;
  RC_LS_level3 <= 128'd0;
  PC_result_level3_1 <= 32'd0;
  branch_level3_1 <= 0;
  //////////////////////////////////////////
  /////pipe2
  PC_level2_2<=32'd0;
  unit_level2_2<= 3'd8;
  latency_level3_2<= 3'd1;
  control_level3_2<=7'd85;
  RT_addr_level3_2 <= 7'd0;
  result_level3_pip2 <= 128'd0;
  PC_result_level3_1 <= 32'd0;
  branch_level3_1 <= 0;
  end // if(Flush_level2 == 1)
  else begin
    /////////////////////////////////////
    ///pipe1 
    PC_level3_1<=PC_level2_1;
    unit_level3_1<= unit_level2_1;
    latency_level3_1<= latency_level2_1;
    control_level3_1<=control_level2_1;
    RT_addr_level3_1 <= RT_addr_level2_1;
    result_level3_pip1 <= result_level2_pip1;
    RC_LS_level3 <= RC_LS_level2;
    PC_result_level3_1 <= PC_result_level2_1;
    branch_level3_1 <=  branch_level2_1;
    //////////////////////////////////////////
    /////pipe2
    PC_level3_2<=PC_level2_2;
    unit_level3_2<= unit_level2_2;
    latency_level3_2<= latency_level2_2;
    control_level3_2<=control_level2_2;
    RT_addr_level3_2 <= RT_addr_level2_2;
    result_level3_pip2 <= result_level2_pip2;
    PC_result_level3_2 <= PC_result_level2_2;
    branch_level3_2 <=  branch_level2_2;
  end
end

//*------------------------------------------------------------------------------
//-- 				 level3  to level4
//------------------------------------------------------------------------------*/
assign Flush_level3 = branch_level4_1;

always_ff @(posedge clk) begin  //level3->level4
  if(Flush_level3 == 1)begin
  ///////////////////////////////////
  /////pipe1
  PC_level4_1<=32'd0;
  unit_level4_1<= 3'd8;
  latency_level4_1<=3'd1;
  control_level4_1<=7'd85;
  RT_addr_level4_1 <= 7'd0;
  result_level4_pip1 <= 128'd0;
  RC_LS_level4 <= 128'd0;
  PC_result_level4_1 <= 32'd0;
  branch_level4_1 <= 0;
  //////////////////////////////////////////
  /////pipe2
  PC_level4_2<=32'd0;
  unit_level4_2<= 3'd8;
  latency_level4_2<= 3'd1;
  control_level4_2<=7'd85;
  RT_addr_level4_2 <= 7'd0;
  result_level4_pip2 <= 128'd0;
  PC_result_level4_2 <= 32'd0;
  branch_level4_2 <= 0;
 end 
 else begin
    /////////////////////////////////////
    ///pipe1
    PC_level4_1<=PC_level3_1;
    unit_level4_1<= unit_level3_1;
    latency_level4_1<= latency_level3_1;
    control_level4_1<=control_level3_1;
    RT_addr_level4_1 <= RT_addr_level3_1;
    result_level4_pip1 <= result_level3_pip1;
    RC_LS_level4 <= RC_LS_level3;
    PC_result_level4_1 <= PC_result_level3_1;
    branch_level4_1 <=  branch_level3_1;
    //////////////////////////////////////////
    /////pipe2
    PC_level4_2<=PC_level3_2;
    unit_level4_2<= unit_level3_2;
    latency_level4_2<= latency_level3_2;
    control_level4_2<=control_level3_2;
    RT_addr_level4_2 <= RT_addr_level3_2;
    result_level4_pip2 <= result_level3_pip2;
    PC_result_level4_2 <= PC_result_level3_2;
    branch_level4_2 <=  branch_level3_2;
  end
end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//*------------------------------------------------------------------------------
//--                      level 4 to level 5                 l
//------------------------------------------------------------------------------*/
//After level4, branch operation can be forwarded. Thus it's unnecesary to flush anything in the SPU
assign Flush_level4 = branch_level4_1;

always_ff @(posedge clk) begin  //level4->level5
  if(Flush_level4 == 1 ) begin
    /////////////////////////////////////
    ///pipe1
    //In any situation, transmit the branch operation as usual
    PC_level5_1<=PC_level4_1;
    unit_level5_1<= unit_level4_1;
    latency_level5_1<=latency_level4_1;
    control_level5_1<=control_level4_1;
    RT_addr_level5_1 <= RT_addr_level4_1;
    result_level5_pip1 <= result_level4_pip1;
    RC_LS_level5 <= RC_LS_level4;
  //////////////////////////////////////////
  /////pipe2
  //The non-branch instruction is the leading one and doesn't need to be flushed 
   if(PC_level4_1 > PC_level4_2) begin 
    PC_level5_2<=PC_level4_2;
    unit_level5_2<= unit_level4_2;
    latency_level5_2<=latency_level4_2;
    control_level5_2<=control_level4_2;
    RT_addr_level5_2 <= RT_addr_level4_2;
    result_level5_pip2 <= result_level4_pip2;
    end
    else begin //flush the even pipe
    PC_level5_2<=32'd0;
    unit_level5_2<= 3'd8;
    latency_level5_2<= 3'd1;
    control_level5_2<=7'd85;
    RT_addr_level5_2 <= 7'd0;
    result_level5_pip2 <= 128'd0;
    end
  end
  else begin
    /////////////////////////////////////
    ///pipe1
    PC_level5_1<=PC_level4_1;
    unit_level5_1<= unit_level4_1;
    latency_level5_1<=latency_level4_1;
    control_level5_1<=control_level4_1;
    RT_addr_level5_1 <= RT_addr_level4_1;
    result_level5_pip1 <= result_level4_pip1;
    RC_LS_level5 <= RC_LS_level4;
    //////////////////////////////////////////
    /////pipe2
    PC_level5_2<=PC_level4_2;
    unit_level5_2<= unit_level4_2;
    latency_level5_2<=latency_level4_2;
    control_level5_2<=control_level4_2;
    RT_addr_level5_2 <= RT_addr_level4_2;
    result_level5_pip2 <= result_level4_pip2;
  end
end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////
always_ff @(posedge clk) begin  //level5->level6
    /////////////////////////////////////
    ///pipe1
    PC_level6_1<=PC_level5_1;
    unit_level6_1<= unit_level5_1;
    latency_level6_1<= latency_level5_1;
    control_level6_1<=control_level5_1;
    RT_addr_level6_1 <= RT_addr_level5_1;
    result_level6_pip1 <= result_level5_pip1; 
    	//load instruction can be forwarded in the level 6, the result is gotten after the level5
    if (control_level5_1==7'd1||control_level5_1==7'd2||control_level5_1==7'd3||control_level5_1==7'd4)
    result_level6_pip1 <= Data_LS;    
    else
    result_level6_pip1 <= result_level5_pip1; 
    RC_LS_level6 <= RC_LS_level5;
    //////////////////////////////////////////
    /////pipe2
    PC_level6_2<=PC_level5_2;
    unit_level6_2<= unit_level5_2;
    latency_level6_2<= latency_level5_2;
    control_level6_2<=control_level5_2;
    RT_addr_level6_2 <= RT_addr_level5_2;
    result_level6_pip2 <= result_level5_pip2;
end

//=================================================================================//
//                                                       Local Store
//The store will be finished in the level7
assign wr_en_LS = ((control_level6_1==7'd5||control_level6_1==7'd6||control_level6_1==7'd7||control_level6_1==7'd8) && RC_LS_level6 != 0);

Memory Memory_LS (clk, RC_LS_level6, Data_LS, result_level5_pip1, result_level6_pip1, wr_en_LS, data_test2, Mem_to_ILB, control_level5_1,PC_temp);
//Memory Memory_LS (clk, RC_LS_level6, Data_LS, result_level5_pip1, result_level6_pip1, wr_en_LS, data_test2);
//Memory(clk,             data_in,     data_out,   l_addr,                 s_addr,          wr_en,   data_test2)

//==================================================================================
always_ff @(posedge clk) begin  //level6->level7
    /////////////////////////////////////
    ///pipe1
    PC_level7_1<=PC_level6_1;
    unit_level7_1<= unit_level6_1;
    latency_level7_1<= latency_level6_1;
    control_level7_1<=control_level6_1;
    RT_addr_level7_1 <= RT_addr_level6_1;
    result_level7_pip1 <= result_level6_pip1;
    //////////////////////////////////////////
    /////pipe2
    PC_level7_2<=PC_level6_2;
    unit_level7_2<= unit_level6_2;
    latency_level7_2<= latency_level6_2;
    control_level7_2<=control_level6_2;
    RT_addr_level7_2 <= RT_addr_level6_2;
    result_level7_pip2 <= result_level6_pip2;
    //*******************************
    //something needs to be added here. If the instruction is store a value
    //then the value need to be stored into the memery.
end

//==============================================================================================//
// 									Write Back												    
//==============================================================================================//
always_comb begin
   if (result_level7_pip1!=0 &&( control_level7_1 !=7'd5||control_level7_1 !=7'd6||control_level7_1 !=7'd7||control_level7_1 !=7'd8))
     wr_en_wrba_1 =1;
   else
     wr_en_wrba_1 =0;

   if (result_level7_pip2!=0)
     wr_en_wrba_2 =1;
   else
     wr_en_wrba_2 =0;
end
endmodule



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                          Data Memory                                                            //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Description: This memory has two instructions output ports, one data out port and one data input  /////////////////
//				port.The read has no enable signal, but writing has an enable signal. And it is                    //
//				available for store instruction.						                                           //						  
//latency    :	Writing into and reading from memory is one clock cycle later.					                   //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Memory(clk, data_in, data_out, l_addr, s_addr, wr_en, data_test2, data_to_ILB, control_miss, PC_miss); 
  input clk,wr_en; 
  input [0:127]data_in;
  input [0:127] l_addr,s_addr;  //load address and store address
  input [0:6]control_miss;
  input [0:31]PC_miss;      //The address of instruction with byte offset
  logic [0:31]PC_load_Ins;  //The address of instruction with 4 bytes offset
  output logic [0:127]data_out;  //port for data 
  output logic [0:127]data_test2;
  output logic [0:1023]data_to_ILB;
  
    //The data memory,each line is 8 bits. In some degree
    //the data memory is different with instruction in this code
  logic [0:511][0:7] mem;
    //each line of the mem2 store one instruction. The size of memory is
    //much bigger than the size of cache by increase the first parameter of mem2
     logic [0:31] mem2 [0:255];
    //The port to obeserve the information in data memory
    //It will be only used for observation, don't change it
  assign data_test2 = {mem[32'd48],mem[32'd48+32'd1],mem[32'd48+32'd2],mem[32'd48+32'd3],
           mem[32'd48+32'd4],mem[32'd48+32'd5],mem[32'd48+32'd6],mem[32'd48+32'd7],
           mem[32'd48+32'd8],mem[32'd48+32'd9],mem[32'd48+32'd10],mem[32'd48+32'd11],
           mem[32'd48+32'd12],mem[32'd48+32'd13],mem[32'd48+32'd14],mem[32'd48+32'd15]};

    //shift the PC_miss, that's because the PC_miss is byte aligment
    //PC_load_Ins is 4 bytes aligment
  assign PC_load_Ins = {2'b0,PC_miss[0:29]};

    //The memory initialization by reading instructions from
    //"encode.txt" file. Each line of this file is 32 bits
    //which is compatiable with the structural of the instruction memory
    initial $readmemb("encode",mem2);

    //Write data in to the data memory
   always_ff @(posedge clk) begin
     if (wr_en) begin
       mem[s_addr]<=data_in[0:7];
       mem[s_addr+32'd1]<=data_in[8:15];
       mem[s_addr+32'd2]<=data_in[16:23];
       mem[s_addr+32'd3]<=data_in[24:31];
       mem[s_addr+32'd4]<=data_in[32:39];
       mem[s_addr+32'd5]<=data_in[40:47];
       mem[s_addr+32'd6]<=data_in[48:55];
       mem[s_addr+32'd7]<=data_in[56:63];
       mem[s_addr+32'd8]<=data_in[64:71];
       mem[s_addr+32'd9]<=data_in[72:79];
       mem[s_addr+32'd10]<=data_in[80:87];
       mem[s_addr+32'd11]<=data_in[88:95];
       mem[s_addr+32'd12]<=data_in[96:103];
       mem[s_addr+32'd13]<=data_in[104:111]; 
       mem[s_addr+32'd14]<=data_in[112:119];
       mem[s_addr+32'd15]<=data_in[120:127];
     end
   end

    //read data from the data memory
   always_comb begin 
   data_out <= {mem[l_addr],mem[l_addr+32'd1],mem[l_addr+32'd2],mem[l_addr+32'd3],
                mem[l_addr+32'd4],mem[l_addr+32'd5],mem[l_addr+32'd6],mem[l_addr+32'd7],
                mem[l_addr+32'd8],mem[l_addr+32'd9],mem[l_addr+32'd10],mem[l_addr+32'd11],
                mem[l_addr+32'd12],mem[l_addr+32'd13],mem[l_addr+32'd14],mem[l_addr+32'd15]};

     //each time load 32 x 32 byte instructions from instruction memory
     //to cache
   if (control_miss==7'd0)
   begin
    data_to_ILB<={mem2[PC_miss+32'd0],mem2[PC_miss+32'd1],mem2[PC_miss+32'd2],mem2[PC_miss+32'd3],  
    mem2[PC_miss+32'd4],mem2[PC_miss+32'd5],mem2[PC_miss+32'd6],mem2[PC_miss+32'd7], 
    mem2[PC_miss+32'd8],mem2[PC_miss+32'd9],mem2[PC_miss+32'd10],mem2[PC_miss+32'd11],  
    mem2[PC_miss+32'd12],mem2[PC_miss+32'd13],mem2[PC_miss+32'd14],mem2[PC_miss+32'd15],  
    mem2[PC_miss+32'd16],mem2[PC_miss+32'd17],mem2[PC_miss+32'd18],mem2[PC_miss+32'd19], 
    mem2[PC_miss+32'd20],mem2[PC_miss+32'd21],mem2[PC_miss+32'd22],mem2[PC_miss+32'd23],  
    mem2[PC_miss+32'd24],mem2[PC_miss+32'd25],mem2[PC_miss+32'd26],mem2[PC_miss+32'd27],  
    mem2[PC_miss+32'd28],mem2[PC_miss+32'd29],mem2[PC_miss+32'd30],mem2[PC_miss+32'd31]} ;
   end
   else  begin
   data_to_ILB<=1024'dx;
   end
   end

  
endmodule


///////////////////////////////////////////////////////////////////////////////////////////////////////
//                                          Resigster Memory                                         //
///////////////////////////////////////////////////////////////////////////////////////////////////////
//Description: This memory has two instructions output ports, one data out port and one data input   //
//				port.The read has no enable signal, but writing has an enable signal.				 // 
//                              And it is                                                            //
//				available for store instruction.                                     				 //
//latency    :	Reading from memory is asynchronous. Writing is one clock cycle later. 	             //
///////////////////////////////////////////////////////////////////////////////////////////////////////
module Register(clk,reset,wr_en_1,wr_en_2,data_in_1,data_in_2,
                r_addr_RA1,r_addr_RB1,r_addr_RC1,r_addr_RA2,r_addr_RB2,r_addr_RC2,w_addr_1,w_addr_2,
                data_out_RA1,data_out_RB1,data_out_RC1,data_out_RA2,data_out_RB2,data_out_RC2,data_test_r2, data_test_r3,data_test_r4);

  input clk,reset;
  input wr_en_1,wr_en_2;
  input [0:127]data_in_1,data_in_2;
  input [0:6] r_addr_RA1,r_addr_RB1,r_addr_RC1,r_addr_RA2,r_addr_RB2,r_addr_RC2,w_addr_1,w_addr_2;
  output logic [0:127]data_out_RA1,data_out_RB1,data_out_RC1,data_out_RA2,data_out_RB2,data_out_RC2;
  
  logic [0:127][0:127] mem;
   
  output logic [0:127]data_test_r2, data_test_r3, data_test_r4;
  
   assign data_out_RA1 = mem[r_addr_RA1];
   assign data_out_RB1 = mem[r_addr_RB1];
   assign data_out_RC1 = mem[r_addr_RC1];
   assign data_out_RA2 = mem[r_addr_RA2];
   assign data_out_RB2 = mem[r_addr_RB2];
   assign data_out_RC2 = mem[r_addr_RC2];
   assign data_test_r2 = mem[7'd2];
   assign data_test_r3 = mem[7'd3];
   assign data_test_r4 = mem[7'd4];

   always_ff @(posedge clk) begin    
   if (reset)begin
    mem<=0;
 //  mem[7'd7]<=127'd0;
   end
   else
     begin
     if (wr_en_1) 
       mem[w_addr_1]<=data_in_1;
     if (wr_en_2)
       mem[w_addr_2]<=data_in_2;
     end
   end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                ILB                                            //
///////////////////////////////////////////////////////////////////////////////////////////////////////
//Description: This is a cache(memory) that get 32 instructions from memory and issue two instrctions// 
//	        at a time.	                                                                             //
//								                                                                     //		   
//**At this version, we assume the instructions have already been fetched into ILB from local memory //
//                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////
module ILB(clk, data_out, PC_ILB_Rd, data_from_mem, cache_miss);
  input clk;
  input [0:31] PC_ILB_Rd;
  input [0:1023]data_from_mem;
  //input [0:127]data_in;
  //input [0:31] l_addr,s_addr, PC_addr;  //load address and store address
  output logic [0:63]data_out;  //port for data 
  output logic cache_miss;
  logic [0:511][0:7] mem; 
  logic [0:31] PC;


   always_ff @(posedge clk) begin
   if (cache_miss==1'b1)
   begin
      {mem[PC+32'd0],mem[PC+32'd1],mem[PC+32'd2],mem[PC+32'd3]}<=data_from_mem[0:31];
      {mem[PC+32'd4],mem[PC+32'd5],mem[PC+32'd6],mem[PC+32'd7]}<=data_from_mem[32:63];
      {mem[PC+32'd8],mem[PC+32'd9],mem[PC+32'd10],mem[PC+32'd11]}<=data_from_mem[64:95];
      {mem[PC+32'd12],mem[PC+32'd13],mem[PC+32'd14],mem[PC+32'd15]}<=data_from_mem[96:127];
      {mem[PC+32'd16],mem[PC+32'd17],mem[PC+32'd18],mem[PC+32'd19]}<=data_from_mem[128:159];
      {mem[PC+32'd20],mem[PC+32'd21],mem[PC+32'd22],mem[PC+32'd23]}<=data_from_mem[160:191];
      {mem[PC+32'd24],mem[PC+32'd25],mem[PC+32'd26],mem[PC+32'd27]}<=data_from_mem[192:223];
      {mem[PC+32'd28],mem[PC+32'd29],mem[PC+32'd30],mem[PC+32'd31]}<=data_from_mem[224:255];
      {mem[PC+32'd32],mem[PC+32'd33],mem[PC+32'd34],mem[PC+32'd35]}<=data_from_mem[256:287];
      {mem[PC+32'd36],mem[PC+32'd37],mem[PC+32'd38],mem[PC+32'd39]}<=data_from_mem[288:319];
      {mem[PC+32'd40],mem[PC+32'd41],mem[PC+32'd42],mem[PC+32'd43]}<=data_from_mem[320:351];
      {mem[PC+32'd44],mem[PC+32'd45],mem[PC+32'd46],mem[PC+32'd47]}<=data_from_mem[352:383];
      {mem[PC+32'd48],mem[PC+32'd49],mem[PC+32'd50],mem[PC+32'd51]}<=data_from_mem[384:415];
      {mem[PC+32'd52],mem[PC+32'd53],mem[PC+32'd54],mem[PC+32'd55]}<=data_from_mem[416:447];
      {mem[PC+32'd56],mem[PC+32'd57],mem[PC+32'd58],mem[PC+32'd59]}<=data_from_mem[448:479];
      {mem[PC+32'd60],mem[PC+32'd61],mem[PC+32'd62],mem[PC+32'd63]}<=data_from_mem[480:511];
      {mem[PC+32'd64],mem[PC+32'd65],mem[PC+32'd66],mem[PC+32'd67]}<=data_from_mem[512:543];
      {mem[PC+32'd68],mem[PC+32'd69],mem[PC+32'd70],mem[PC+32'd71]}<=data_from_mem[544:575];
      {mem[PC+32'd72],mem[PC+32'd73],mem[PC+32'd74],mem[PC+32'd75]}<=data_from_mem[576:607];
      {mem[PC+32'd76],mem[PC+32'd77],mem[PC+32'd78],mem[PC+32'd79]}<=data_from_mem[608:639];
      {mem[PC+32'd80],mem[PC+32'd81],mem[PC+32'd82],mem[PC+32'd83]}<=data_from_mem[640:671];
      {mem[PC+32'd84],mem[PC+32'd85],mem[PC+32'd86],mem[PC+32'd87]}<=data_from_mem[672:703];
      {mem[PC+32'd88],mem[PC+32'd89],mem[PC+32'd90],mem[PC+32'd91]}<=data_from_mem[704:735];
      {mem[PC+32'd92],mem[PC+32'd93],mem[PC+32'd94],mem[PC+32'd95]}<=data_from_mem[736:767];
      {mem[PC+32'd96],mem[PC+32'd97],mem[PC+32'd98],mem[PC+32'd99]}<=data_from_mem[768:799];
      {mem[PC+32'd100],mem[PC+32'd101],mem[PC+32'd102],mem[PC+32'd103]}<=data_from_mem[800:831];
      {mem[PC+32'd104],mem[PC+32'd105],mem[PC+32'd106],mem[PC+32'd107]}<=data_from_mem[832:863];
      {mem[PC+32'd108],mem[PC+32'd109],mem[PC+32'd110],mem[PC+32'd111]}<=data_from_mem[864:895];
      {mem[PC+32'd112],mem[PC+32'd113],mem[PC+32'd114],mem[PC+32'd115]}<=data_from_mem[896:927];
      {mem[PC+32'd116],mem[PC+32'd117],mem[PC+32'd118],mem[PC+32'd119]}<=data_from_mem[928:959];
      {mem[PC+32'd120],mem[PC+32'd121],mem[PC+32'd122],mem[PC+32'd123]}<=data_from_mem[960:991];
      {mem[PC+32'd124],mem[PC+32'd125],mem[PC+32'd126],mem[PC+32'd127]}<=data_from_mem[992:1023];
      end
   end
  

 
    /*always_comb begin 
      if (fetch_en==1)begin
      {mem[0],mem[1],mem[2],mem[3]}<=32'b00011100_0001000000_0000000_0000010;
      {mem[4],mem[5],mem[6],mem[7]}<=32'b00000000_00000000_00000000_00000000;
      {mem[8],mem[9],mem[10],mem[11]}<=32'b00000000000_0000000_0000000_0000000;
      {mem[12],mem[13],mem[14],mem[15]}<=32'b00000000_00000000_00000000_00000000;
      {mem[16],mem[17],mem[18],mem[19]}<=32'b00000000_00000000_00000000_00000000;
      {mem[20],mem[21],mem[22],mem[23]}<=32'b00000000_00000000_00000000_00000000;
      {mem[24],mem[25],mem[26],mem[27]}<=32'b00000000_00000000_00000000_00000000;
      {mem[28],mem[29],mem[30],mem[31]}<=32'b00000000_00000000_00000000_00000000;
      {mem[32],mem[33],mem[34],mem[35]}<=32'b00000000_00000000_00000000_00000000;
      {mem[36],mem[37],mem[38],mem[39]}<=32'b00000000_00000000_00000000_00000000;
      {mem[40],mem[41],mem[42],mem[43]}<=32'b00000000_00000000_00000000_00000000;
      {mem[44],mem[45],mem[46],mem[47]}<=32'b00000000_0000000000_0000000_0000000;
      {mem[48],mem[49],mem[50],mem[51]}<=32'b00000000_00000000_00000000_00000000;
      {mem[52],mem[53],mem[54],mem[55]}<=32'b00000000_00000000_00000000_00000000;
      {mem[56],mem[57],mem[58],mem[59]}<=32'b00000000_00000000_00000000_00000000;
      {mem[60],mem[61],mem[62],mem[63]}<=32'b00000000_00000000_00000000_00000000;
      {mem[64],mem[65],mem[66],mem[67]}<=32'b00000000_00000000_00000000_00000000;
      {mem[68],mem[69],mem[70],mem[71]}<=32'b01010100101_0000000_0000010_0000100;
      {mem[72],mem[73],mem[74],mem[75]}<=32'b00000000_00000000_00000000_00000000;
      {mem[76],mem[77],mem[78],mem[79]}<=32'b00000000_00000000_00000000_00000000;
      end
    end*/
   
    always_comb begin

    if (PC_ILB_Rd>32'd511)
    PC<=PC_ILB_Rd%32'd511;
    else 
    PC<=PC_ILB_Rd & 32'hffffff80;

    end

    always_comb begin
    if (({mem[PC],mem[PC+32'd1],mem[PC+32'd2],mem[PC+32'd3]}===32'dx)||({mem[PC+32'd4],mem[PC+32'd5],mem[PC+32'd6],mem[PC+32'd7]}===32'dx)) begin
    data_out <= {11'd2,21'd0,32'd0};
    cache_miss <= 1'b1;
    end 
    else begin
    data_out <= { mem[PC],mem[PC+32'd1],mem[PC+32'd2],mem[PC+32'd3],mem[PC+32'd4],mem[PC+32'd5],mem[PC+32'd6],mem[PC+32'd7]};
    cache_miss <=1'b0;
    end
    end

endmodule

module tb_405();
logic clk,reset;;
logic [0:31]PC, PC_Fe_1,PC_Fe_2,PC_level7_1,PC_level7_2, PC_Dec_1, PC_Dec_2, PC_Dep_1, PC_Dep_2, PC_RF_1, PC_RF_2,PC_level1_1, PC_level1_2,
      PC_level2_1, PC_level2_2, PC_level3_1, PC_level3_2, PC_level4_1, PC_level4_2,
      PC_level5_1, PC_level5_2, PC_level6_1, PC_level6_2;

logic [0:127]data_test_r2, data_test_r3,data_test_r4,data_test2;
logic [0:127] RC_LS_level6;
logic [0:127] RC_value_1,RC_value_temp_1, result_level6_pip1, result_level7_pip1,Data_LS, result_level1_pip1, result_level1_pip2;
logic [0:15] Imm_level1_2;
logic [0:6] control_level1_2, control_level1_1;
logic [0:127] RA_value_level1_2,RB_value_level1_2,RC_value_level1_2;
logic [0:127] RA_value_level1_1,RB_value_level1_1,RC_value_level1_1;
logic [0:1] pipe_Dec_1, pipe_Dec_2;
logic [0:31] instruction_Dec_1,instruction_Dec_2, instruction_Fe_1,instruction_Fe_2;
logic Dep_Install_Initial, Install_Dep_pipe1, Install_Dep_pipe2;

logic [0:31] PC_result_level1_1, PC_result_level4_1;
logic branch_level1_1, branch_level4_1;

      Cell_SPU DUT(.clk(clk), .reset(reset), .PC(PC), .PC_Fe_1(PC_Fe_1), .PC_Fe_2(PC_Fe_2), .data_test_r2(data_test_r2), .data_test_r3(data_test_r3), .data_test_r4(data_test_r4), .data_test2(data_test2), .RC_LS_level6(RC_LS_level6),
      	.RC_value_1(RC_value_1), .RC_value_temp_1(RC_value_temp_1), .result_level6_pip1(result_level6_pip1), .PC_level7_1(PC_level7_1), .PC_level7_2(PC_level7_2),
      	 .result_level7_pip1(result_level7_pip1), .Data_LS(Data_LS), .result_level1_pip1(result_level1_pip1), .result_level1_pip2(result_level1_pip2),
         .Imm_level1_2(Imm_level1_2), .control_level1_2(control_level1_2), .RA_value_level1_2(RA_value_level1_2), .RB_value_level1_2(RB_value_level1_2), .RC_value_level1_2(RC_value_level1_2),
         .control_level1_1(control_level1_1), .RA_value_level1_1(RA_value_level1_1), .RB_value_level1_1(RB_value_level1_1), .RC_value_level1_1(RC_value_level1_1),
         .PC_Dec_1(PC_Dec_1), .PC_Dec_2(PC_Dec_2), .PC_Dep_1(PC_Dep_1), .PC_Dep_2(PC_Dep_2), .PC_RF_1(PC_RF_1), .PC_RF_2(PC_RF_2), .PC_level1_1(PC_level1_1), .PC_level1_2(PC_level1_2),
         .PC_level2_1(PC_level2_1), .PC_level2_2(PC_level2_2), .PC_level3_1(PC_level3_1), .PC_level3_2(PC_level3_2), .PC_level4_1(PC_level4_1), .PC_level4_2(PC_level4_2),
         .PC_level5_1(PC_level5_1), .PC_level5_2(PC_level5_2), .PC_level6_1(PC_level6_1), .PC_level6_2(PC_level6_2), .pipe_Dec_1(pipe_Dec_1), .pipe_Dec_2(pipe_Dec_2),
         .instruction_Dec_1(instruction_Dec_1), .instruction_Dec_2(instruction_Dec_2), 
         .instruction_Fe_1(instruction_Fe_1), .instruction_Fe_2(instruction_Fe_2),
         .Dep_Install_Initial(Dep_Install_Initial), .Install_Dep_pipe1(Install_Dep_pipe1), .Install_Dep_pipe2(Install_Dep_pipe2),
         .PC_result_level1_1(PC_result_level1_1), .PC_result_level4_1(PC_result_level4_1), .branch_level1_1(branch_level1_1), .branch_level4_1(branch_level4_1));
   initial clk = 0;
   always #5 clk = ~clk;

   initial begin

      // Before first clock edge, initialize     
      reset = 1;

      @(posedge clk);
      #1; // After 1 posedge
      reset = 0;
     end

endmodule


//////////////////////////////////////////////////////////////////////////
//********************* Decode Stage ***************************//
//////////////////////////////////////////////////////////////////////////
//Author： Xiao & Barry                                         //
//unit: unit ID.                                                //
//    0-LocalStore 1-SimpleFixed1 2-SinglePrecision1            //
//    3-Byte  4-SimpleFixed2  5-Permute 6-SinglePrecision2      //
//    7-Branch  8-Stop                                          //
//Pipe:                                                         //
//    0-OddPipe 1-EvenPipe 3-BothInTwoPipe                      //
//latency: The cycles that results can be forwarded             //
//RA,RB,RC: The address of source register. They will be used to//
//  check data hazard in dependece stage and calculate in detail./
//RT:  The address of denstination register. The result will be //
//  stored in RT in write back stage.                           //
//Imm: The immediate value. In "Brach Indirect" instrctution,   //
//  it also be used to store two flags.                         //
//////////////////////////////////////////////////////////////////////////
module decode_mod(instruction,unit,pipe,latency,control,Imm,RA,RB,RC,RT);
  input [0:31] instruction;

  logic [0:10] instruction_first;
  //The signal is used to check in dependence stage.
  output logic [0:2] unit, latency;
  output logic [0:1] pipe;
  output logic [0:6] RA, RB, RC, RT, control; // RA, RB, RC is the source address. RT is the denstination address.
  output logic [0:15] Imm; 


assign instruction_first = instruction[0:10];
always_comb begin
casez(instruction_first)
      11'b00000000010://Cache miss
      begin 
        unit =3'd0;
        pipe =2'd0;
        latency =3'd1;
        control =7'd0;
        Imm = 0;
        RA = 0;
        RB = 0;
        RC = 0;
        RT = 0;          
      end
      11'b001100001??: //Load Quadword(a-form)
        begin
          unit =3'd0;
          pipe =2'd0;
          latency =3'd6;
          control =7'd3;
          Imm = instruction[9:24];
          RA = 0;
          RB = 0;
          RC = 0;
          RT = instruction[25:31]; 
        end
      11'b001000001??: //Store Quadword (a-form)
        begin
          unit =3'd0;
          pipe =2'd0;
          latency =3'd6;
          control =7'd7;
          Imm = instruction[9:24];
          RA = 0;
          RB = 0;
          RC = instruction[25:31];
          RT = 0;     
        end
       11'b00011000000: //Add word
        begin
          unit = 3'd1;
          pipe = 2'd1;
          latency =3'd2;
          control =7'd11;
          Imm = 0;
          RA = instruction[18:24];
          RB = instruction[11:17];
          RC = 0;
          RT = instruction[25:31]; 
        end
       11'b00011100???: //Add word Imm
        begin
          unit = 3'd1;
          pipe = 2'd1;
          latency =3'd2;
          control =7'd12;
          Imm = instruction[8:17];
          RA = instruction[18:24];
          RB = 0;
          RC = 0;
          RT = instruction[25:31];    
        end
       11'b01110101???: //Multiply Unsigned Imm
        begin
          unit = 3'd2;
          pipe = 2'd1;
          latency =3'd7;
          control =7'd19;
          Imm = instruction[8:17];
          RA = instruction[18:24];
          RB = 0;
          RC = 0;
          RT = instruction[25:31];    
        end
       11'b01010100101: //Count Leading Zeros
        begin
          unit = 3'd3;
          pipe = 2'd1;
          latency =3'd2;
          control =7'd21;
          Imm = 0;
          RA = instruction[18:24];
          RB = 0;
          RC = 0;
          RT = instruction[25:31];    
        end
      11'b00001000001: //Or
        begin
          unit = 3'd1;
          pipe = 2'd1;
          latency =3'd2;
          control =7'd37;
          Imm = 0;
          RA = instruction[18:24];
          RB = instruction[11:17];
          RC = 0;
          RT = instruction[25:31];   
        end
      11'b00001011000: //Rotate word 
        begin
          unit = 3'd4;
          pipe = 2'd1;
          latency =3'd4;
          control =7'd45;
          Imm = 0;
          RA = instruction[18:24];
          RB = instruction[11:17];
          RC = 0;
          RT = instruction[25:31];  
        end
      11'b00001111000: //Rotate Word Imm
        begin
          unit = 3'd4;
          pipe = 2'd1;
          latency =3'd4;
          control =7'd46;
          Imm = {9'b0,instruction[11:17]};
          RA = instruction[18:24];
          RB = 0;
          RC = 0;
          RT = instruction[25:31];  
        end
      11'b01011000100: //Double Floating Add
        begin
          unit = 3'd2;
          pipe = 2'd1;
          latency =3'd6;
          control =7'd51;
          Imm = 0;
          RA = instruction[18:24];
          RB = instruction[11:18];
          RC = 0;
          RT = instruction[25:31];  
        end
      11'b01101011111: //Double Floating Multiply
        begin
          unit = 3'd2;
          pipe = 2'd1;
          latency =3'd6;
          control =7'd53;
          Imm = 0;
          RA = instruction[18:24];
          RB = instruction[11:17];
          RC = 0;
          RT = instruction[25:31];  
        end
      11'b01111000000: //Compare Equal Word
        begin
          unit = 3'd1;
          pipe = 2'd1;
          latency =3'd2;
          control =7'd67;
          Imm = 0;
          RA = instruction[18:24];
          RB = instruction[11:17];
          RC = 0;
          RT = instruction[25:31];  
        end
      11'b01111100???: //Compare Equal Word Imm
        begin
          unit = 3'd1;
          pipe = 2'd1;
          latency =3'd2;
          control =7'd68;
          Imm = {6'b0,instruction[8:17]};
          RA = instruction[18:24];
          RB = 0;
          RC = 0;
          RT = instruction[25:31];  
        end
      11'b01001100???: ///Compare Greater Than Word Imm
        begin
          unit = 3'd1;
          pipe = 2'd1;
          latency =3'd2;
          control =7'd74;
          Imm = {6'b0,instruction[8:17]};
          RA = instruction[18:24];
          RB = 0;
          RC = 0;
          RT = instruction[25:31];  
        end
      11'b00110101000:///Branch Indirect
        begin
          unit = 3'd7;
          pipe = 2'd0;
          latency =3'd4;
          control =7'd77;
          Imm = {14'b0,instruction[12:13]}; //In this immidiate register, it stores two flags for interrupt and put them in the least significant bits.
          RA = instruction[18:24];
          RB = 0;
          RC = 0;
          RT = 0;  
        end
      11'b001000010??: ///Branch If Not Zero Word
        begin
          unit = 3'd7;
          pipe = 2'd0;
          latency =3'd4;
          control =7'd79;
          Imm = instruction[9:24];
          RA = instruction[25:31];
          RB = 0;
          RC = 0;
          RT = 0;  
        end
      11'b00000000000: ///No Operation Execute
        begin
          unit = 3'd8;
          pipe = 2'd3;
          latency =3'd1;
          control =7'd85;
          Imm = 0;
          RA = 0;
          RB = 0;
          RC = 0;
          RT = 0;  
        end
       default:  //If the input instruction is invalid, all the bits in the outputs are X.
       begin
          unit = 3'bx;
          pipe = 2'bx;
          latency =3'bx;
          control =7'bx;
          Imm = 16'bx;
          RA = 7'bx;
          RB = 7'bx;
          RC = 7'bX;
          RT = 7'bx;  
        end
  endcase
end
endmodule
  
//////////////////////////////////////////////////////////////////
//********************* Decode Stage ***************************//
//////////////////////////////////////////////////////////////////
//Author： Xiao & Barry                                         //
//Latency:  All the logics are combinational logic without laten//
//      -cy.                        							//
//LSLR:   The LIB is 128 KB, thus the limit is 32'h0000007F.    //
//                                 								//
//Comments: All the branche instructions that condition register//
//      is RT are substitude by RA_value_level here.    		// 
//      This program is not synthesisable.           		    //
//      There are some latches in the program. However, taki//
//      ng account the progam is not synthesiable, this isn'//
//      t important.                     //
//////////////////////////////////////////////////////////////////
module Ins_Cal (control_level,RA_value_level,RB_value_level,RC_value_level,Imm,result,PC_Cal,PC_result,branch_flag);
  input unsigned [0:127] RA_value_level,RB_value_level,RC_value_level; // RA, RB, RC is the source value.
  input unsigned [0:6] control_level;  //Each instruction has unique control signal, the suffix means the level stage.
  input unsigned [0:15] Imm;           //The immediate value. Also some flags has been included in Imm.
  input unsigned [0:31] PC_Cal;		   //The input PC value, which will be used for branch operation

  output logic branch_flag; //The flag used for branch, which will be used for flushing.
  output logic unsigned [0:31] PC_result;  //The value of PC after compution
  output logic unsigned [0:127] result;   //This is the tempory register that store the results. It will be pass through six levels.And be 

  logic unsigned[0:32] Carry_Generate_temp1;
  logic unsigned[0:32] Carry_Generate_temp2;
  logic unsigned[0:32] Carry_Generate_temp3;
  logic unsigned[0:32] Carry_Generate_temp4;

  logic unsigned[0:15] Average_Bytes_temp1;
  logic unsigned[0:15] Average_Bytes_temp2;
  logic unsigned[0:15] Average_Bytes_temp3;
  logic unsigned[0:15] Average_Bytes_temp4;
  logic unsigned[0:15] Average_Bytes_temp5;
  logic unsigned[0:15] Average_Bytes_temp6;
  logic unsigned[0:15] Average_Bytes_temp7;
  logic unsigned[0:15] Average_Bytes_temp8;
  logic unsigned[0:15] Average_Bytes_temp9;
  logic unsigned[0:15] Average_Bytes_temp10;
  logic unsigned[0:15] Average_Bytes_temp11;
  logic unsigned[0:15] Average_Bytes_temp12;
  logic unsigned[0:15] Average_Bytes_temp13;
  logic unsigned[0:15] Average_Bytes_temp14;
  logic unsigned[0:15] Average_Bytes_temp15;
  logic unsigned[0:15] Average_Bytes_temp16;

  logic unsigned[0:15] Imm_unsigned_16bits;
  logic signed[0:15] Imm_signed_16bits;
  logic signed[0:15] signed_RA_value_level_temp1_16bits;
  logic signed[0:15] signed_RA_value_level_temp2_16bits;
  logic signed[0:15] signed_RA_value_level_temp3_16bits;
  logic signed[0:15] signed_RA_value_level_temp4_16bits;
  logic signed[0:15] signed_RB_value_level_temp1_16bits;
  logic signed[0:15] signed_RB_value_level_temp2_16bits;
  logic signed[0:15] signed_RB_value_level_temp3_16bits;
  logic signed[0:15] signed_RB_value_level_temp4_16bits;
  logic signed[0:15] signed_RC_value_level_temp1_16bits;
  logic signed[0:15] signed_RC_value_level_temp2_16bits;
  logic signed[0:15] signed_RC_value_level_temp3_16bits;
  logic signed[0:15] signed_RC_value_level_temp4_16bits;

  assign Imm_unsigned_16bits = {{6{Imm[6]}},Imm[6:15]};
  assign Imm_signed_16bits = {{6{Imm[6]}},Imm[6:15]};

  assign signed_RA_value_level_temp1_16bits = RA_value_level[16:31];
  assign signed_RA_value_level_temp2_16bits = RA_value_level[48:63];
  assign signed_RA_value_level_temp3_16bits = RA_value_level[80:95];
  assign signed_RA_value_level_temp4_16bits = RA_value_level[112:127];
  assign signed_RB_value_level_temp1_16bits = RB_value_level[16:31];
  assign signed_RB_value_level_temp2_16bits = RB_value_level[48:63];
  assign signed_RB_value_level_temp3_16bits = RB_value_level[80:95];
  assign signed_RB_value_level_temp4_16bits = RB_value_level[112:127];
  assign signed_RC_value_level_temp1_16bits = RC_value_level[16:31];
  assign signed_RC_value_level_temp2_16bits = RC_value_level[48:63];
  assign signed_RC_value_level_temp3_16bits = RC_value_level[80:95];
  assign signed_RC_value_level_temp4_16bits = RC_value_level[112:127];
  
  real RA_float;  //double precesion floating
  real RB_float;  //double precesion floating
  real RC_float;  //double precesion floating
  real result_float; //double precesion floating
  logic [0:63] result_float_con;
  //********************1*****
  //Instruction about PC is possible for more variable.
always_comb begin
  case(control_level)
     7'd0://Cache miss
      begin 
      	result[0:31] = 0;
      end
     7'd3: //Load Quadword(a-form)
      begin 
        result[96:127] = ({{14{Imm[0]}},{Imm[0:15],2'b00}}) & 32'hFFFFFFF0;
        result[0:95] = {96'd0};
        branch_flag = 0;
        //result[32:127] = 96'b0; 
      end
     7'd7: //Store Quadword (a-form)
      begin  
    	// result[0:31] = ({{14{Imm[0]}},{Imm[0:15],2'b00}}) & 32'hFFFFFFF0;
     	  result[96:127] = ({{14{Imm[0]}},{Imm[0:15],2'b00}}) & 32'hFFFFFFF0;
        branch_flag = 0; 
      end
      7'd11: //Add word
        begin
          result[0:31] = RA_value_level[0:31] + RB_value_level[0:31];
          result[32:63] = RA_value_level[32:63] + RB_value_level[32:63];
          result[64:95] = RA_value_level[64:95] + RB_value_level[64:95];
          result[96:127] = RA_value_level[96:127] + RB_value_level[96:127];
          branch_flag = 0;
        end
      7'd12: //Add word Imm
        begin
          result[0:31] = RA_value_level[0:31] + {{22{Imm[6]}},Imm[6:15]};
          result[32:63] = RA_value_level[32:63] + {{22{Imm[6]}},Imm[6:15]};
          result[64:95] = RA_value_level[64:95] + {{22{Imm[6]}},Imm[6:15]};
          result[96:127] = RA_value_level[96:127] + {{22{Imm[6]}},Imm[6:15]};
          branch_flag = 0;
        end 
      7'd19: //Multiply Unsigned Imm
        begin
          result[0:31] = RA_value_level[16:31] * Imm_unsigned_16bits;
          result[32:63] = RA_value_level[48:63] * Imm_unsigned_16bits;
          result[64:95] = RA_value_level[80:95] * Imm_unsigned_16bits;
          result[96:127] = RA_value_level[112:127] * Imm_unsigned_16bits;
        end
     7'd21: //Count Leading Zeros
      begin
        result[0:31] = zero_count(RA_value_level[0:31]);
        result[32:63] = zero_count(RA_value_level[32:63]);
        result[64:95] = zero_count(RA_value_level[64:95]);
        result[96:127] = zero_count(RA_value_level[96:127]);
        PC_result = 32'bX;
        branch_flag = 0;
      end
     7'd37: //Or
      begin
          result[0:31] = RA_value_level[0:31] | RB_value_level[0:31];
          result[32:63] = RA_value_level[32:63] | RB_value_level[32:63];
          result[64:95] = RA_value_level[64:95] | RB_value_level[64:95];
          result[96:127] = RA_value_level[96:127] | RB_value_level[96:127];
          branch_flag = 0;
      end
     7'd45: //Rotate word 
      begin
        result[0:31] = (RA_value_level[0:31] << RB_value_level[27:31]) | (RA_value_level[0:31] >> (32- RB_value_level[27:31]));
        result[32:63] = (RA_value_level[32:63] << RB_value_level[59:63]) | (RA_value_level[32:63] >> (32- RB_value_level[59:63]));
        result[64:95] = (RA_value_level[64:95] << RB_value_level[91:95]) | (RA_value_level[64:95] >> (32- RB_value_level[91:95]));
        result[96:127] = (RA_value_level[96:127] << RB_value_level[123:127]) | (RA_value_level[96:127] >> (32- RB_value_level[123:127]));
        PC_result = 32'bX;  
        branch_flag = 0;
      end
     7'd46: //Rotate Word Imm
      begin
        result[0:31] = (RA_value_level[0:31] << Imm[11:15]) | (RA_value_level[0:31] >> (32- Imm[11:15]));
        result[32:63] = (RA_value_level[32:63] << Imm[11:15]) | (RA_value_level[32:63] >> (32- Imm[11:15]));
        result[64:95] = (RA_value_level[64:95] << Imm[11:15]) | (RA_value_level[64:95] >> (32- Imm[11:15]));
        result[96:127] = (RA_value_level[96:127] << Imm[11:15]) | (RA_value_level[96:127] >> (32- Imm[11:15]));
        PC_result = 32'bX;  
        branch_flag = 0;
      end
     7'd51: //Double Floating Add
      begin  
        RA_float = $bitstoreal(RA_value_level[0:63]);
        RB_float = $bitstoreal(RB_value_level[0:63]);
        result_float = RA_float + RB_float;
        result_float_con = $realtobits(result_float);
        result ={result_float_con, 64'b0};
        PC_result = 32'bX; 
        branch_flag = 0; 
      end
     7'd53: //Double Floating Multiply
      begin  
        RA_float = $bitstoreal(RA_value_level[0:63]);
        RB_float = $bitstoreal(RB_value_level[0:63]);
        result_float = RA_float * RB_float;
        result_float_con = $realtobits(result_float);
        PC_result = 32'bX;  
        branch_flag = 0;
      end
     7'd67: //Compare Equal Word
      begin 
        result[0:31] = (RA_value_level[0:31] == RB_value_level[0:31]) ? 36'hFFFFFFFF : 36'h00000000;
        result[32:63] = (RA_value_level[32:63] == RB_value_level[32:63]) ? 36'hFFFFFFFF : 36'h00000000;
        result[64:95] = (RA_value_level[64:95] == RB_value_level[64:95]) ? 36'hFFFFFFFF : 36'h00000000;
        result[96:127] = (RA_value_level[96:127] == RB_value_level[96:127]) ? 36'hFFFFFFFF : 36'h00000000;
        branch_flag = 0;
      end
     7'd68: //Compare Equal Word Imm
      begin
        result[0:31] = (RA_value_level[0:31] == {{22{Imm[6]}},Imm[6:15]}) ? 36'hFFFFFFFF : 36'h00000000;
        result[32:63] = (RA_value_level[32:63] == {{22{Imm[6]}},Imm[6:15]}) ? 36'hFFFFFFFF : 36'h00000000;
        result[64:95] = (RA_value_level[64:95] == {{22{Imm[6]}},Imm[6:15]}) ? 36'hFFFFFFFF : 36'h00000000;
        result[96:127] = (RA_value_level[96:127] == {{22{Imm[6]}},Imm[6:15]}) ? 36'hFFFFFFFF : 36'h00000000;
        branch_flag = 0;
      end
     7'd74:///Compare Greater Than Word Imm
      begin
        result[0:31] = (RA_value_level[0:31] > {{22{Imm[6]}},Imm[6:15]}) ? 32'hFFFFFFFF : 32'h00000000;
        result[32:63] = (RA_value_level[32:63] > {{22{Imm[6]}},Imm[6:15]}) ? 32'hFFFFFFFF : 32'h00000000;
        result[64:95] = (RA_value_level[64:95] > {{22{Imm[6]}},Imm[6:15]}) ? 32'hFFFFFFFF : 32'h00000000;
        result[96:127] = (RA_value_level[96:127] > {{22{Imm[6]}},Imm[6:15]}) ? 32'hFFFFFFFF : 32'h00000000;
        branch_flag = 0;
      end
     7'd77:///Branch Indirect
      begin  
        PC_result = RA_value_level[0:31] & 32'hFFFFFFFC;
        branch_flag = 1;
      end
     7'd79:///Branch If Not Zero Word
      begin  
        if(RA_value_level[0:31] != 0) begin
         PC_result = (PC_Cal + {{14{Imm[0]}},Imm[0:15],2'b0}) & 32'hFFFFFFFC; 
          branch_flag = 1;
        end
        else begin
          PC_result = (PC_Cal + 4); 
          branch_flag = 1;
        end
      end
     7'd85:///No Operation Execute
      begin  
        result = 128'b0;
        PC_result = 0;
        branch_flag = 0;
      end
     default:
     begin
      result = 128'bX;
      PC_result = 32'bX;
      branch_flag = 0;
     end
    endcase // control_level
end

  //////////////////////////////////////////////////////
  ///function to count zero in word. It inputs one word
  ///Zero_count will automatic increase until find bit 
  ///1;
    function logic[0:31] zero_count(input logic [0:31] a);
      int i;
      begin 
      zero_count = 32'b0;
      i = 0;
      while(a[i] == 0)
        begin
          zero_count = zero_count + 32'd1;
          i++;
        end
      end
  endfunction

  //////////////////////////////////////////////////////
  ///function to count one in bytes. It inputs one byte
  ///One_count will automatic increase if it finds bit 
  ///1;
    function logic[0:7] one_count(input logic [0:7] a);
      int i;
      begin 
      one_count = 8'b0;
      i = 0;
      while(i <8)
        begin
          one_count = one_count + {7'b0,a[i]};
          i ++;
        end
      end
  endfunction
endmodule

/*------------------------------------------------------------------------------
--  						Hazard RF function
------------------------------------------------------------------------------*/
module hazard_RF (clk, result_level2_pip1, result_level3_pip1, result_level4_pip1, result_level5_pip1, result_level6_pip1, result_level7_pip1,
result_level2_pip2, result_level3_pip2, result_level4_pip2, result_level5_pip2, result_level6_pip2, result_level7_pip2,
value_return,forward_sig_demo,value_demo);
input clk;
input [0:3] forward_sig_demo;
logic [0:3] forward_delay;
input [0:127] value_demo;
input [0:127] result_level2_pip1, result_level3_pip1, result_level4_pip1, result_level5_pip1, result_level6_pip1, result_level7_pip1;
input [0:127] result_level2_pip2, result_level3_pip2, result_level4_pip2, result_level5_pip2, result_level6_pip2, result_level7_pip2;
output logic [0:127] value_return;

	//The forward signal comes from dependence stage.
	//Thus one cycle later. An delay siganl is needed.
	always_ff @(posedge clk) begin
		if(forward_sig_demo == 0) begin
			 forward_delay<= 0;
		end 
		else begin
			forward_delay <= forward_sig_demo;
		end
	end

  always_comb begin
      case(forward_delay)
          0:
            value_return = value_demo;
          2:
            value_return = result_level2_pip1;
          3:
            value_return = result_level3_pip1;
          4:
            value_return = result_level4_pip1;
          5:
            value_return = result_level5_pip1;
          6:
            value_return = result_level6_pip1;
          7:
            value_return = result_level7_pip1;
          8:
            value_return = result_level2_pip2;
          9:
            value_return = result_level3_pip2;
          10:
            value_return = result_level4_pip2;
          11:
            value_return = result_level5_pip2;
          12:
            value_return = result_level6_pip2;
          13:
            value_return = result_level7_pip2;
          default:
            value_return = 128'bx;
      endcase 
  end
endmodule

//////////////////////////////////////////////////////////////////////////
//********************* Data  Hazard ***************************//
//////////////////////////////////////////////////////////////////////////
//Author： Xiao & Barry                                         //
//Description:  In this subroutine, progam compare the source re//
//  gister address with the afterwards denstination address step//
//  by step. Two signals are output.             			  //
//Backward sig: Used for stages before dependence stage. If it  //
//  equals 1, stall instruction must be added. In this program, //
//  its control signal is 85                  			  //
//forward sig : Used for value forward. If its value isn't zero //
//  Some value can be forwarded. The different value shows which//
//  stages can get the value.              		        //
//////////////////////////////////////////////////////////////////////////
module data_hazard(normal_source_addr, control_Ins,RT_RF_1,RT_addr_level1_1,RT_addr_level1_2,RT_addr_level1_3,RT_addr_level1_4,RT_addr_level1_5,RT_addr_level1_6,
  RT_RF_2,RT_addr_level2_1,RT_addr_level2_2,RT_addr_level2_3,RT_addr_level2_4,RT_addr_level2_5,RT_addr_level2_6,
  latency_level1_1,latency_level1_2,latency_level1_3,latency_level1_4,latency_level1_5,latency_level1_6,
  latency_level2_1,latency_level2_2,latency_level2_3,latency_level2_4,latency_level2_5,latency_level2_6,
  PC_pipe1, PC_pipe2, RT_Dep_input, forward_sig,Install_flag_Dep, Install_Dep_Ins, store_check_flag);

  input [0:6] normal_source_addr;
  input [0:6] RT_RF_1,RT_addr_level1_1,RT_addr_level1_2,RT_addr_level1_3,RT_addr_level1_4,RT_addr_level1_5,RT_addr_level1_6;
  input [0:6] RT_RF_2,RT_addr_level2_1,RT_addr_level2_2,RT_addr_level2_3,RT_addr_level2_4,RT_addr_level2_5,RT_addr_level2_6;
  input [0:2] latency_level1_1,latency_level1_2,latency_level1_3,latency_level1_4,latency_level1_5,latency_level1_6;
  input [0:2] latency_level2_1,latency_level2_2,latency_level2_3,latency_level2_4,latency_level2_5,latency_level2_6;
  input [0:6] RT_Dep_input; //The address of the other instruction
  input [0:31] PC_pipe1, PC_pipe2; //Two PC for compare, PC_pip2 is the PC of the instrcution and PC_pip2 is the PC of the other instrcution

  input store_check_flag; //show store instruction in the pipeline
  input[0:6] control_Ins; //The control number of the input instruction 
  
//This signal is used for Register Fetch.
//If forward_sig = 0 and Install_flag = 1 at the same time, that means
//forward has been found, but the result hasn't been prepared and this instruction in the
//dependence stage needs to install to wait for the result. If Install_falg = 0 at the same
//time, it shows no forward relation has been found.
  output logic [0:3] forward_sig;

//This signal is used for stage before dependence and shows the relation between this instruction
//and the instruction after dependence stage.
  logic Install_flag;

//This signal is used only for store and load instruction.And only the input insturction is load
// and the later instruction has store Install_flag_ls needs to be set.
  logic Install_flag_ls; 

//The output install signal which is the combine of two install signals
  output logic Install_flag_Dep;

//This signal shows the relation between the two instructins in the dependence stage.
  output logic Install_Dep_Ins;

/*------------------------------------------------------------------------------
--  //==function for store and load check
------------------------------------------------------------------------------*/

always_comb begin
	if((control_Ins==7'd1||control_Ins==7'd2||control_Ins==7'd3||control_Ins==7'd4) && store_check_flag == 1) begin
	Install_flag_ls = 1;
	end
	else begin
	Install_flag_ls = 0;
	end
end

//==function to check relation between input instruction and later instruction 
always_comb begin
  //Whenever the same denstination address in Register Fetch stage, the nop is needed
  if(normal_source_addr == RT_RF_1 && normal_source_addr != 0) begin
    forward_sig = 4'd0;
    Install_flag = 1;
  end
  else if(normal_source_addr == RT_RF_2 && normal_source_addr != 0) begin
    forward_sig = 4'd0;
    Install_flag = 1;
  end
  // get value from level1_2
  else if(normal_source_addr == RT_addr_level1_1 && normal_source_addr != 0)begin 
    if(latency_level1_1 == 2) begin
      forward_sig = 4'd2;// get value from level1_2
      Install_flag = 0;
    end
    else begin
    forward_sig = 4'd0;
    Install_flag = 1;
    end
  end
  else if(normal_source_addr == RT_addr_level2_1 && normal_source_addr != 0)begin 
    if(latency_level2_1 == 2) begin// get value from level2_2
      forward_sig = 4'd8;
      Install_flag = 0;
    end
    else begin
    forward_sig = 4'd0;
    Install_flag = 1;
    end
  end
  else if(normal_source_addr == RT_addr_level1_2 && normal_source_addr != 0)begin 
    if(latency_level1_2 <= 3) begin
      forward_sig = 4'd3;// get value from level1_3
      Install_flag = 0;
    end
    else begin
    forward_sig = 4'd0;
    Install_flag = 1;
    end
  end
  else if(normal_source_addr == RT_addr_level2_2 && normal_source_addr != 0)begin 
    if(latency_level2_2 <= 3) begin// get value from level2_3
      forward_sig = 4'd9;
      Install_flag = 0;
    end
    else begin    
    forward_sig = 4'd0;
    Install_flag = 1;
    end
  end
  else if(normal_source_addr == RT_addr_level1_3 && normal_source_addr != 0)begin 
    if(latency_level1_3 <= 4) begin
      forward_sig = 4'd4;// get value from level1_4
      Install_flag = 0;
    end
    else begin
    forward_sig = 4'd0;
    Install_flag = 1;
    end
  end
  else if(normal_source_addr == RT_addr_level2_3 && normal_source_addr != 0)begin 
    if(latency_level2_3 <= 4) begin// get value from level2_4
      forward_sig = 4'd10;
      Install_flag = 0;
    end
    else begin
    forward_sig = 4'd0;
    Install_flag = 1;
    end
  end
  else if(normal_source_addr == RT_addr_level1_4 && normal_source_addr != 0)begin 
    if(latency_level1_4 <= 5) begin
      forward_sig = 4'd5;// get value from level1_5
      Install_flag = 0;
    end
    else begin
    forward_sig = 4'd0;
    Install_flag = 1;
    end
  end
  else if(normal_source_addr == RT_addr_level2_4 && normal_source_addr != 0)begin 
    if(latency_level2_4 <= 5) begin// get value from level2_5
      forward_sig = 4'd11;
      Install_flag = 0;
    end
    else begin
    forward_sig = 4'd0;
    Install_flag = 1;
    end
  end
  else if(normal_source_addr == RT_addr_level1_5 && normal_source_addr != 0)begin 
    if(latency_level1_5 <= 6) begin
      forward_sig = 4'd6;// get value from level1_6
      Install_flag = 0;
    end
    else begin
    forward_sig = 4'd0;
    Install_flag = 1;
    end
  end
  else if(normal_source_addr == RT_addr_level2_5 && normal_source_addr != 0)begin 
    if(latency_level2_5 <= 6) begin// get value from level2_6
      forward_sig = 4'd12;
      Install_flag = 0;
    end
    else begin
    forward_sig = 4'd0;
    Install_flag = 1;
    end
  end
  else if(normal_source_addr == RT_addr_level1_6 && normal_source_addr != 0)begin 
    if(latency_level1_6 <= 7) begin
      forward_sig = 4'd7;// get value from level1_7
      Install_flag = 0;
    end
    else begin
    forward_sig = 4'd0;
    Install_flag = 1;
    end
  end
  else if(normal_source_addr == RT_addr_level2_6 && normal_source_addr != 0)begin 
    if(latency_level2_6 <= 7) begin// get value from level2_7
      forward_sig = 4'd13;
      Install_flag = 0;
    end
    else begin
    forward_sig = 4'd0;
    Install_flag = 1;
    end
  end
  else begin
    forward_sig = 4'd0;
    Install_flag = 0;
  end
end

//If the two instruction has dependence between each other, install the later instruction
//Notes :The PC_pipe2 and PC_pipe1 don't means the even instruction and odd instruction.
//	    PC_pipe1 means the input instruction and PC_pipe2 denotes another instruction in the depen
//	     -dence stage.
  always_comb begin
    if( (normal_source_addr == RT_Dep_input) && (normal_source_addr) != 0 && (PC_pipe2 < PC_pipe1))begin
        Install_Dep_Ins = 1;
    end // if(normal_source_addr = RT_Dep_input && normal_source_addr != 0)
    else 
      Install_Dep_Ins = 0;
  end

 // assign Install_flag_Dep = (Install_flag || Install_Dep_Ins);
assign Install_flag_Dep = Install_flag || Install_flag_ls;
endmodule

//////////////////////////////////////////////////////////////////////////
//*********************** Store_check***************************//
//////////////////////////////////////////////////////////////////////////
//In order to avoid data hazard, check store insturctions in the 
//stages after dependence 
//\return: store_check_flag is set when store instruction is found 
//	     in the later stage.
module store_check(store_check_flag, control_RF_1, control_RF_2,control_level1_1, control_level1_2,control_level2_1, control_level2_2,
 control_level3_1, control_level3_2,control_level4_1, control_level4_2,control_level5_1, control_level5_2,control_level6_1, control_level6_2);
  input[0:6] control_RF_1, control_RF_2,control_level1_1, control_level1_2,control_level2_1, control_level2_2;
  input[0:6] control_level3_1, control_level3_2,control_level4_1, control_level4_2,control_level5_1, control_level5_2,control_level6_1, control_level6_2;

  output logic store_check_flag;
  logic RF1_flag, RF2_flag, level11_1flag, level1_2flag, level2_1flag, level2_2flag, level3_1flag, level3_2flag,level4_1flag, level4_2flag, level5_1flag, level5_2flag;
 
  assign RF1_flag = (control_RF_1==7'd5||control_RF_1==7'd6||control_RF_1==7'd7||control_RF_1==7'd8) ? 1 : 0;
  assign RF2_flag = (control_RF_2==7'd5||control_RF_2==7'd6||control_RF_2==7'd7||control_RF_2==7'd8) ? 1 : 0; 
  assign level11_1flag = (control_level1_1==7'd5||control_level1_1==7'd6||control_level1_1==7'd7||control_level1_1==7'd8) ? 1 : 0;
  assign level1_2flag = (control_level1_2==7'd5||control_level1_2==7'd6||control_level1_2==7'd7||control_level1_2==7'd8) ? 1 : 0;
  assign level12_1flag = (control_level2_1==7'd5||control_level2_1==7'd6||control_level2_1==7'd7||control_level2_1==7'd8) ? 1 : 0;
  assign level2_2flag = (control_level2_2==7'd5||control_level2_2==7'd6||control_level2_2==7'd7||control_level2_2==7'd8) ? 1 : 0;
  assign level3_1flag = (control_level3_1==7'd5||control_level3_1==7'd6||control_level3_1==7'd7||control_level3_1==7'd8) ? 1 : 0;
  assign level3_2flag = (control_level3_2==7'd5||control_level3_2==7'd6||control_level3_2==7'd7||control_level3_2==7'd8) ? 1 : 0;
  assign level4_1flag = (control_level4_1==7'd5||control_level4_1==7'd6||control_level4_1==7'd7||control_level4_1==7'd8) ? 1 : 0;
  assign level4_2flag = (control_level4_2==7'd5||control_level4_2==7'd6||control_level4_2==7'd7||control_level4_2==7'd8) ? 1 : 0;
  assign level5_1flag = (control_level5_1==7'd5||control_level5_1==7'd6||control_level5_1==7'd7||control_level5_1==7'd8) ? 1 : 0;
  assign level5_2flag = (control_level5_2==7'd5||control_level5_2==7'd6||control_level5_2==7'd7||control_level5_2==7'd8) ? 1 : 0;


  assign store_check_flag = (RF1_flag || RF2_flag || level11_1flag || level1_2flag || level2_1flag || level2_2flag || level3_1flag || level3_2flag ||level4_1flag || level4_2flag || level5_1flag || level5_2flag);
endmodule

/*------------------------------------------------------------------------------
--      						 WRW hazard fucntion
------------------------------------------------------------------------------*/
//Description:	This module is used to check WRW hazard. If WAW hazard is found, 
//				install one instruction
//\return:	WAW_Install_flag has three value. 0 shows no hazard found, 1 means install
//			instruction in pipe1, 2 means install instruction in pipe2.
module WAW_hazard (WAW_Install_flag, RT_Dep_1, RT_Dep_2, PC_Dep_1, PC_Dep_2);
output logic [0:1] WAW_Install_flag;
input [0:6] RT_Dep_1, RT_Dep_2;
input [0:31] PC_Dep_1, PC_Dep_2;
always_comb begin
	if(RT_Dep_1 == RT_Dep_2 && RT_Dep_1 != 32'd0) begin
		if(PC_Dep_1 > PC_Dep_2)
			WAW_Install_flag = 1;
		else 
			WAW_Install_flag = 2;
	end // if(RT_Dep_1 == RT_Dep_2 && RT_Dep_1 != 32'd0)
	else
		WAW_Install_flag = 0;
end // always_combend
endmodule
