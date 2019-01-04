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
    output [13:0] 	 ADDR;
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

    assign ADDR = addr;
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
	    
	end
	current_state <= next_state;
    end
    always @(*) begin
	if(rst)
	  next_state = RESET;
	else begin
	    RST_N = 1;       
	    CKE = 1;
	    ctr_reset = 0;
	    cmd = CMD_NOP;
	    addr = 0;
	    ba = 0;
	    cs_n = 0;
	    case(current_state)
	      RESET: begin
		  RST_N = 0;
		  CKE = 0;
		  if(counter == 200) begin
		      next_state = INIT_1;
		      ctr_reset = 1;
		  end
	      end
	      INIT_1: begin
		  CKE = 0;
		  if (counter == 500) begin
		      next_state = INIT_2;
		      ctr_reset = 1;
		  end
	      end
	      INIT_2: begin
		  if(counter == TXPR/`TCK_PERIOD) begin
		      next_state = INIT_3;
		      ctr_reset = 1;
		      cmd = CMD_MRS;
		      /* CWL = 5 */
		      addr = 14'b000000000000000;
		      ba = 3'b010;
		  end
	      end
	      INIT_3: begin
		  if(counter == 4) begin
		      next_state = INIT_4;
		      ctr_reset = 1;
		      cmd = CMD_MRS;
		      addr = 14'b0;
		      ba = 3'b011;
		  end
	      end
	      INIT_4: begin
		  if(counter == 4) begin
		      next_state = INIT_5;
		      ctr_reset = 1;
		      cmd = CMD_MRS;
		      addr = 14'b00000000000000;
		      ba = 3'b001;
		  end
	      end
	      INIT_5: begin
		  if(counter == 4) begin
		      next_state = INIT_6;
		      ctr_reset = 1;
		      cmd = CMD_MRS;
		      /* Write recovery = 8 (guessed)
		         DLL Reset
		         CAS Latency = 6 (needed for 400MHz)
		         Sequential Burst
		         Burst of 4
		       */
		      addr = 14'b00010100010010;
		      ba = 3'b000;
		  end
	      end
	      INIT_6: begin
		  if(counter == TMOD_TCK) begin
		      next_state = INIT_7;
		      ctr_reset = 1;
		      cmd = CMD_ZQC;
		  end
	      end
	      INIT_7: begin
		  if(counter == 512) begin
		      next_state = IDLE;
		      cmd = CMD_PRE;
		  end
	      end
	      
	      
	    endcase // case (current_state)
	end // else: !if(rst)
    end // always @ (*)
    
	
    
    
    

    /*AUTOASCIIENUM("current_state", "cur_state_ascii")*/
    // Beginning of automatic ASCII enum decoding
    reg [47:0]		cur_state_ascii;	// Decode of current_state
    always @(current_state) begin
	case ({current_state})
	  RESET:    cur_state_ascii = "reset ";
	  INIT_1:   cur_state_ascii = "init_1";
	  INIT_2:   cur_state_ascii = "init_2";
	  INIT_3:   cur_state_ascii = "init_3";
	  INIT_4:   cur_state_ascii = "init_4";
	  INIT_5:   cur_state_ascii = "init_5";
	  INIT_6:   cur_state_ascii = "init_6";
	  INIT_7:   cur_state_ascii = "init_7";
	  IDLE:     cur_state_ascii = "idle  ";
	  default:  cur_state_ascii = "%Error";
	endcase
    end
    // End of automatics
    /*AUTOASCIIENUM("cmd", "cmd_ascii")*/
    // Beginning of automatic ASCII enum decoding
    reg [55:0]		cmd_ascii;		// Decode of cmd
    always @(cmd) begin
	case ({cmd})
	  CMD_MRS:  cmd_ascii = "cmd_mrs";
	  CMD_REF:  cmd_ascii = "cmd_ref";
	  CMD_PRE:  cmd_ascii = "cmd_pre";
	  CMD_ACT:  cmd_ascii = "cmd_act";
	  CMD_WR:   cmd_ascii = "cmd_wr ";
	  CMD_RD:   cmd_ascii = "cmd_rd ";
	  CMD_NOP:  cmd_ascii = "cmd_nop";
	  CMD_ZQC:  cmd_ascii = "cmd_zqc";
	  default:  cmd_ascii = "%Error ";
	endcase
    end
    // End of automatics

endmodule // ddr3_controller

