`timescale 1ps/1ps
`define TCK_PERIOD 125
module ddr3_controller(/*AUTOARG*/
    // Outputs
    RST_N, CK, CK_N, CKE, CS_N, RAS_N, CAS_N, WE_N, BA, ADDR, ODT,
    // Inouts
    DM_TDQS, DQ, DQS, DQS_N,
    // Inputs
    TDQS_N, clk, clk_90, rst
    );
`include "1024Mb_ddr3_parameters.vh"
    /* DDR3 Signals */
    input [DQS_BITS-1:0] TDQS_N;

    inout [1:0] 	 DM_TDQS;
    inout [15:0] 	 DQ;
    inout [1:0] 	 DQS;
    inout [1:0] 	 DQS_N;

    output reg		 RST_N;
    output 		 CK, CK_N;
    output reg		 CKE;
    output 		 CS_N, RAS_N, CAS_N, WE_N;
    output [2:0] 	 BA;
    output [12:0] 	 ADDR;
    output 		 ODT;

    /* Module Signals */
    input 		 clk;
    input 		 clk_90;
    input 		 rst;
    assign CK = ~clk;
    assign CK_N = ~CK;

    localparam //auto enum state
      RESET = 0,
      INIT_1 = 1,
      INIT_2 = 2,
      INIT_3 = 3,
      INIT_4 = 4,
      INIT_5 = 5,
      INIT_6 = 6,
      INIT_7 = 7,
      IDLE = 8;
    reg [5:0] //auto enum state
	      current_state, next_state;
    initial current_state = RESET;
    localparam //auto enum cmd
      CMD_MRS = 3'b000,
      CMD_REF = 3'b001,
      CMD_PRE = 3'b010,
      CMD_ACT = 3'b011,
      CMD_WR  = 3'b100,
      CMD_RD  = 3'b101,
      CMD_NOP = 3'b111,
      CMD_ZQC = 3'b110;
	       
    reg [2:0] // auto enum cmd
	      cmd;
    assign {RAS_N, CAS_N, WE_N} = cmd;

    
    reg [19:0] counter;
    reg        ctr_reset;
    reg [13:0] addr;
    reg [2:0]  ba;
    reg        cs_n;

    assign ADDR = addr[12:0];
    assign BA = ba;
    assign CS_N = cs_n;

    always @(posedge clk)
      if(rst == 1)
	counter <= 0;
      else if(ctr_reset)
	counter <= 0;
      else
	counter <= counter + 1;
	

    always @(posedge clk) begin
	if(rst == 1) begin
	    current_state <= RESET;
	end
	else begin
	  current_state <= next_state;
	end
    end
    always @(*) begin
	RST_N = 1;       
	CKE = 1;
	ctr_reset = 0;
	cmd = CMD_NOP;
	addr = 0;
	ba = 0;
	cs_n = 0;
	next_state = RESET;
	case(current_state)
	  RESET: begin
	      RST_N = 0;
	      CKE = 0;
	      next_state = RESET;
	      if(counter == 200) begin
		  next_state = INIT_1;
		  ctr_reset = 1;
	      end
	  end
	  INIT_1: begin
	      CKE = 0;
	      next_state = INIT_1;
	      if (counter == 500) begin
		  next_state = INIT_2;
		  ctr_reset = 1;
	      end
	  end
	  INIT_2: begin
	      next_state = INIT_2;
	      if(counter == TXPR/`TCK_PERIOD) begin
		  next_state = INIT_3;
		  ctr_reset = 1;
		  cmd = CMD_MRS;
		  //CWL = 5 
		  addr = 14'b000000000000000;
		  ba = 3'b010;
	      end
	  end
	  INIT_3: begin
	      next_state = INIT_3;
	      if(counter == 4) begin
		  next_state = INIT_4;
		  ctr_reset = 1;
		  cmd = CMD_MRS;
		  addr = 14'b0;
		  ba = 3'b011;
	      end
	  end
	  INIT_4: begin
	      next_state = INIT_4;
	      if(counter == 4) begin
		  next_state = INIT_5;
		  ctr_reset = 1;
		  cmd = CMD_MRS;
		  addr = 14'b00000000000000;
		  ba = 3'b001;
	      end
	  end
	  INIT_5: begin
	      next_state = INIT_5;
	      if(counter == 4) begin
		  next_state = INIT_6;
		  ctr_reset = 1;
		  cmd = CMD_MRS;
		  //   Write recovery = 8 (guessed)
		  //   DLL Reset
		  //   CAS Latency = 6 (needed for 400MHz)
		  //   Sequential Burst
		  //   Burst of 4
		  
		  addr = 14'b00010100010010;
		  ba = 3'b000;
	      end
	  end
	  INIT_6: begin
	      next_state = INIT_6;
	      if(counter == 12) begin
		  next_state = INIT_7;
		  ctr_reset = 1;
		  cmd = CMD_ZQC;
	      end
	  end
	  INIT_7: begin
	      next_state = INIT_7;
	      if(counter == 512) begin
		  next_state = IDLE;
		  cmd = CMD_PRE;
	      end
	  end
	  IDLE: begin
	      next_state = IDLE;
	  end
	  
	  
	  
	endcase // case (current_state)
    end // always @ (*)
    
    
    
    
    

    /*AUTOASCIIENUM("current_state", "cur_state_ascii")*/
    /*AUTOASCIIENUM("cmd", "cmd_ascii")*/

endmodule // ddr3_controller

