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
      INIT_8 = 8,
      IDLE = 9;
    reg [5:0] //auto enum state
	      state;
    initial state = RESET;
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
    reg        counter_done;
    reg        ctr_reset;
    reg [12:0] addr;
    reg [2:0]  ba;
    reg        cs_n;

    assign ADDR = addr[12:0];
    assign BA = ba;
    assign CS_N = 0;

	

    always @(posedge clk) begin
	if(rst == 1) begin
	    state <= RESET;
	    /*AUTORESET*/
	    // Beginning of autoreset for uninitialized flops
	    CKE <= 1'h0;
	    RST_N <= 1'h0;
	    addr <= 13'h0;
	    ba <= 3'h0;
	    cmd <= 3'h0;
	    counter <= 20'h0;
	    counter_done <= 1'h0;
	    // End of automatics
	end
	else begin
	    counter <= counter - 1;
	    counter_done <= counter == 1;
	    cmd <= CMD_NOP;
	    case(state)
	      RESET: begin
		  counter <= 200;
		  state <= INIT_1;
		  RST_N <= 0;
	      end
	      INIT_1:
		if(counter_done) begin
		    RST_N <= 1;
		    state <= INIT_2;
		    counter <= 500;
		end
	      INIT_2:
		if(counter_done) begin
		    CKE <= 1;
		    state <= INIT_3;
		    counter <= TXPR/10/`TCK_PERIOD;
		end
	      INIT_3:
		if(counter_done) begin
		    cmd <= CMD_MRS;
		    state <= INIT_4;
		    ba <= 2;
		    addr <= 0;
		    counter <= TMRD;
		end
	      INIT_4:
		if(counter_done) begin
		    cmd <= CMD_MRS;
		    state <= INIT_5;
		    ba <= 3;
		    addr <= 0;
		    counter <= TMRD;
		end
	      INIT_5:
		if(counter_done) begin
		    cmd <= CMD_MRS;
		    state <= INIT_6;
		    ba <= 1;
		    addr <= 0;
		    counter <= TMRD;
		end
	      INIT_6:
		if(counter_done) begin
		    cmd <= CMD_MRS;
		    state <= INIT_7;
		    ba <= 0;

		    //   Write recovery = 8 (guessed)
		    //   DLL Reset
		    //   CAS Latency = 6 (needed for 400MHz)
		    //   Sequential Burst
		    //   Burst of 4
		    addr <= 13'b00010100010010;
		    counter <= TMOD_TCK;
		end
	      INIT_7:
		if(counter_done) begin
		    cmd <= CMD_ZQC;
		    state <= INIT_8;
		    counter <= 512;
		end
	      INIT_8:
		if(counter_done)
		  state <= IDLE;
		
	      
	      
	      
	      
	      
	      
	    endcase // case (state)
	end // else: !if(rst == 1)
    end // always @ (posedge clk)
    
	  
	  
    
    
    
    
    

    /*AUTOASCIIENUM("state", "cur_state_ascii")*/
    // Beginning of automatic ASCII enum decoding
    reg [47:0]		cur_state_ascii;	// Decode of state
    always @(state) begin
	case ({state})
	  RESET:    cur_state_ascii = "reset ";
	  INIT_1:   cur_state_ascii = "init_1";
	  INIT_2:   cur_state_ascii = "init_2";
	  INIT_3:   cur_state_ascii = "init_3";
	  INIT_4:   cur_state_ascii = "init_4";
	  INIT_5:   cur_state_ascii = "init_5";
	  INIT_6:   cur_state_ascii = "init_6";
	  INIT_7:   cur_state_ascii = "init_7";
	  INIT_8:   cur_state_ascii = "init_8";
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

