`timescale 1ps/1ps
`define TCK_PERIOD 125
module ddr3_controller(/*AUTOARG*/
    // Outputs
    RST_N, CK, CK_N, CKE, CS_N, RAS_N, CAS_N, WE_N, BA, ADDR, ODT,
    data_out, controller_ready,
    // Inouts
    DM_TDQS, DQ, DQS, DQS_N,
    // Inputs
    TDQS_N, clk, rst, data_in, addr_in, wr_req, rd_req
    );
`include "1024Mb_ddr3_parameters.vh"
    /* DDR3 Signals */
    input [DQS_BITS-1:0] TDQS_N;

    inout [1:0] 	 DM_TDQS;
    inout [15:0] 	 DQ;
    inout [1:0] 	 DQS;
    inout [1:0] 	 DQS_N;

    output reg RST_N;
    output 		 CK, CK_N;
    output [0:0] CKE;
    output [0:0] CS_N;
    output 		 RAS_N, CAS_N, WE_N;
    output [2:0] 	 BA;
    output [13:0] 	 ADDR;
    output [0:0] 	 ODT;

    /* Module Signals */
    input 		 clk;
    input 		 rst;

    input [63:0] 	 data_in;
    input [23:0] 	 addr_in;
    input 		 wr_req;
    input 		 rd_req;

    output reg [63:0] 	 data_out;
    output reg		 controller_ready;

    wire 		 casn_din0, casn_din1, rasn_din0, rasn_din1, wen_din0, wen_din1;
    wire [0:0] 		 csn_din0 = 0;
    wire [0:0] 		 csn_din1 = 0;

    /*AUTOWIRE*/
    // Beginning of automatic wires (for undeclared instantiated-module outputs)
    wire		burstdet_0;		// From ddr_mem of ddr_mem.v
    wire		burstdet_1;		// From ddr_mem of ddr_mem.v
    wire [31:0]		datain_0o;		// From ddr_mem of ddr_mem.v
    wire [31:0]		datain_1o;		// From ddr_mem of ddr_mem.v
    wire		datavalid_0;		// From ddr_mem of ddr_mem.v
    wire		datavalid_1;		// From ddr_mem of ddr_mem.v
    wire [7:0]		dcntl;			// From ddr_mem of ddr_mem.v
    wire [7:0]		qwl_0;			// From ddr_mem of ddr_mem.v
    wire [7:0]		qwl_1;			// From ddr_mem of ddr_mem.v
    wire		ready;			// From ddr_mem of ddr_mem.v
    wire		sclk;			// From ddr_mem of ddr_mem.v
    // End of automatics

    /*AUTOREGINPUT*/
    // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
    reg [13:0]		addr_din0;		// To ddr_mem of ddr_mem.v
    reg [13:0]		addr_din1;		// To ddr_mem of ddr_mem.v
    reg [2:0]		ba_din0;		// To ddr_mem of ddr_mem.v
    reg [2:0]		ba_din1;		// To ddr_mem of ddr_mem.v
    reg [0:0]		cke_din0;		// To ddr_mem of ddr_mem.v
    reg [0:0]		cke_din1;		// To ddr_mem of ddr_mem.v
    reg [31:0]		dataout_0i;		// To ddr_mem of ddr_mem.v
    reg [31:0]		dataout_1i;		// To ddr_mem of ddr_mem.v
    reg [1:0]		datatri_0;		// To ddr_mem of ddr_mem.v
    reg [1:0]		datatri_1;		// To ddr_mem of ddr_mem.v
    reg [1:0]		dqso_0;			// To ddr_mem of ddr_mem.v
    reg [1:0]		dqso_1;			// To ddr_mem of ddr_mem.v
    reg [1:0]		dqstri_0;		// To ddr_mem of ddr_mem.v
    reg [1:0]		dqstri_1;		// To ddr_mem of ddr_mem.v
    reg [7:0]		dyndelay_0;		// To ddr_mem of ddr_mem.v
    reg [7:0]		dyndelay_1;		// To ddr_mem of ddr_mem.v
    reg [0:0]		odt_din0;		// To ddr_mem of ddr_mem.v
    reg [0:0]		odt_din1;		// To ddr_mem of ddr_mem.v
    reg			pause_data;		// To ddr_mem of ddr_mem.v
    reg [1:0]		read_0;			// To ddr_mem of ddr_mem.v
    reg [1:0]		read_1;			// To ddr_mem of ddr_mem.v
    reg [2:0]		readclksel_0;		// To ddr_mem of ddr_mem.v
    reg [2:0]		readclksel_1;		// To ddr_mem of ddr_mem.v
    reg			update;			// To ddr_mem of ddr_mem.v
    // End of automatics

    


    ddr_mem ddr_mem(
		    // Outputs
		    .casn		(CAS_N),
		    .rasn		(RAS_N),
		    .wen		(WE_N),
		    .addr		(ADDR[13:0]),
		    .ba			(BA[2:0]),
		    .cke		(CKE[0:0]),
		    .csn		(CS_N[0:0]),
		    .odt		(ODT[0:0]),
		    .ddrclk		({CK}),
		    // Inouts
		    .dqs_0		(DQS[0]),
		    .dqs_1		(DQS[1]),
		    .dq_0		(DQ[7:0]),
		    .dq_1		(DQ[15:8]),
		    // Inputs
		    .clkop		(clk),
		    .pll_lock		(1'b1),
		    .sync_clk		(clk),
		    .sync_reset		(~rst),
		    /*AUTOINST*/
		    // Outputs
		    .burstdet_0		(burstdet_0),
		    .burstdet_1		(burstdet_1),
		    .datavalid_0	(datavalid_0),
		    .datavalid_1	(datavalid_1),
		    .dcntl		(dcntl[7:0]),
		    .ready		(ready),
		    .sclk		(sclk),
		    .datain_0o		(datain_0o[31:0]),
		    .datain_1o		(datain_1o[31:0]),
		    .qwl_0		(qwl_0[7:0]),
		    .qwl_1		(qwl_1[7:0]),
		    // Inputs
		    .casn_din0		(casn_din0),
		    .casn_din1		(casn_din1),
		    .datatri_0		(datatri_0[1:0]),
		    .datatri_1		(datatri_1[1:0]),
		    .dqso_0		(dqso_0[1:0]),
		    .dqso_1		(dqso_1[1:0]),
		    .dqstri_0		(dqstri_0[1:0]),
		    .dqstri_1		(dqstri_1[1:0]),
		    .dyndelay_0		(dyndelay_0[7:0]),
		    .dyndelay_1		(dyndelay_1[7:0]),
		    .pause_data		(pause_data),
		    .rasn_din0		(rasn_din0),
		    .rasn_din1		(rasn_din1),
		    .read_0		(read_0[1:0]),
		    .read_1		(read_1[1:0]),
		    .readclksel_0	(readclksel_0[2:0]),
		    .readclksel_1	(readclksel_1[2:0]),
		    .update		(update),
		    .wen_din0		(wen_din0),
		    .wen_din1		(wen_din1),
		    .addr_din0		(addr_din0[13:0]),
		    .addr_din1		(addr_din1[13:0]),
		    .ba_din0		(ba_din0[2:0]),
		    .ba_din1		(ba_din1[2:0]),
		    .cke_din0		(cke_din0[0:0]),
		    .cke_din1		(cke_din1[0:0]),
		    .csn_din0		(csn_din0[0:0]),
		    .csn_din1		(csn_din1[0:0]),
		    .dataout_0i		(dataout_0i[31:0]),
		    .dataout_1i		(dataout_1i[31:0]),
		    .odt_din0		(odt_din0[0:0]),
		    .odt_din1		(odt_din1[0:0]));

    reg [5:0] //auto enum state
	      state;
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
      IDLE = 9,
      ACT_1 = 10,
      ACT_2 = 11,
      ACT_3 = 12,
      RD_1 = 13,
      RD_2 = 14,
      RD_3 = 15,
      RD_4 = 16,
      RD_5 = 17,
      RD_6 = 18,
      WR_1 = 32,
      WR_2 = 33,
      WR_3 = 34,
      WR_4 = 35,
      WR_5 = 36,
      WR_6 = 37,
      WR_7 = 38,
      PRE_1 = 48,
      PRE_2 = 49,
      PRE_3 = 50,
      PRE_4 = 51,
      PRE_5 = 52;

    reg [19:0] counter = 0;
    reg        counter_done;
    reg [2:0]  // auto enum cmd
	       cmd_0, cmd_1;

    reg [23:0] cur_addr;

    assign {rasn_din0, casn_din0, wen_din0} = cmd_0;
    assign {rasn_din1, casn_din1, wen_din1} = cmd_1;
    localparam //auto enum cmd
      CMD_MRS = 3'b000,
      CMD_REF = 3'b001,
      CMD_PRE = 3'b010,
      CMD_ACT = 3'b011,
      CMD_WR  = 3'b100,
      CMD_RD  = 3'b101,
      CMD_NOP = 3'b111,
      CMD_ZQC = 3'b110;
              
      
    assign CK_N = ~CK;
    reg [2:0]  dqs_n;
    always @(DQS)
      if(DQS === 2'bz)
	dqs_n <= 2'bz;
      else
	dqs_n <= ~DQS;
    assign DQS_N = dqs_n;
    
    always @(posedge sclk or negedge rst) begin
	if(rst == 0) begin
	    cmd_0 <= CMD_NOP;
	    cmd_1 <= CMD_NOP;
	    /*AUTORESET*/
	    // Beginning of autoreset for uninitialized flops
	    RST_N <= 1'h0;
	    addr_din0 <= 1'h0;
	    ba_din0 <= 1'h0;
	    cke_din0 <= 1'h0;
	    cke_din1 <= 1'h0;
	    controller_ready <= 1'h0;
	    counter <= 20'h0;
	    counter_done <= 1'h0;
	    dataout_0i <= 1'h0;
	    dataout_1i <= 1'h0;
	    datatri_0 <= 1'h0;
	    datatri_1 <= 1'h0;
	    dqso_0 <= 1'h0;
	    dqso_1 <= 1'h0;
	    dqstri_0 <= 1'h0;
	    dqstri_1 <= 1'h0;
	    dyndelay_0 <= 1'h0;
	    dyndelay_1 <= 1'h0;
	    pause_data <= 1'h0;
	    read_0 <= 1'h0;
	    read_1 <= 1'h0;
	    readclksel_0 <= 1'h0;
	    readclksel_1 <= 1'h0;
	    state <= 6'h0;
	    // End of automatics
	end
	else begin
	    cmd_0 <= CMD_NOP;
	    cmd_1 <= CMD_NOP;
	    read_0 <= 0;
	    read_1 <= 0;
	    readclksel_0 <= 3'b100;
	    readclksel_1 <= 3'b100;
	    dyndelay_0 <= 120;
	    dyndelay_1 <= 120;
	    dqstri_0 <= 2'b11;
	    dqstri_1 <= 2'b11;
	    datatri_0 <= 2'b11;
	    datatri_1 <= 2'b11;
	    pause_data <= 0;
	    counter <= counter - 1;
	    counter_done <= counter == 1;
	    case(state)
	      RESET: begin
		  if(ready) begin
		  counter <= 100;
		  state <= INIT_1;
		  end
	      end
	      INIT_1:
		if(counter_done) begin
		    RST_N <= 1;
		    counter <= 250;
		    state <= INIT_2;
		end
	      INIT_2:
		if(counter_done) begin
		    cke_din0 <= 1;
		    cke_din1 <= 1;
		    counter <= 30;
		    state <= INIT_3;
		end
	      INIT_3:
		if(counter_done) begin
		    cmd_0 <= CMD_MRS;
		    ba_din0 <= 2;
		    addr_din0 <= 0;
		    counter <= 3;
		    state <= INIT_4;
		end
	      INIT_4:
		if(counter_done) begin
		    cmd_0 <= CMD_MRS;
		    ba_din0 <= 3;
		    addr_din0 <= 0;
		    counter <= 3;
		    state <= INIT_5;
		end
	      INIT_5:
		if(counter_done) begin
		    cmd_0 <= CMD_MRS;
		    ba_din0 <= 1;
		    addr_din0 <= 0;
		    counter <= 3;
		    state <= INIT_6;
		end
	      INIT_6:
		if(counter_done) begin
		    cmd_0 <= CMD_MRS;
		    ba_din0 <= 0;
		    addr_din0 <= 14'b00010100010010;;
		    counter <= TMOD_TCK/2;
		    state <= INIT_7;
		end
	      INIT_7:
		if(counter_done) begin
		    cmd_0 <= CMD_ZQC;
		    state <= INIT_8;
		    counter <= 512;
		end
	      INIT_8:
		if(counter_done)
		  state <= IDLE;
	      IDLE: begin
		  controller_ready <= 1;
		  if(rd_req | wr_req) begin
		      addr_din0 <= addr_in[23:10];
		      cur_addr <= addr_in[23:0];
		      ba_din0 <= 0;
		      cmd_0 <= CMD_ACT;
		      state <= ACT_1;
		  end
	      end
	      ACT_1: 
		state <= ACT_2;
	      ACT_2:
		state <= ACT_3;
	      ACT_3: begin
		  controller_ready <= 0;
		if(rd_req)
		  state <= RD_1;
		else if(wr_req)
		  state <= WR_1;

	      end
	      
	      RD_1: begin
		  cmd_0 <= CMD_RD;
		  addr_din0 <= addr_in [9:0];
		  state <= RD_2;
	      end
	      RD_2: begin
		  state <= RD_3;
		  read_0 <= 2'b11;
		  read_1 <= 2'b11;
	      end
	      
	      RD_3: begin
		  state <= RD_4;
	      end
	      
	      RD_4:
		state <= RD_5;
	      RD_5:
		state <= RD_6;

	      WR_1: begin
		  cmd_0 <= CMD_WR;
		  addr_din0 <= addr_in[9:0];
		  state <= WR_2;
		  dataout_0i <= data_in[31:0];
		  dataout_1i <= data_in[63:32];
		  dqso_0 <= 2'b11;
		  dqso_1 <= 2'b11;
	      end
	      WR_2: begin
		  state <= WR_3;
	      end
	      WR_3: begin
		  state <= WR_4;
		  dqstri_0 <= 2'b01;
		  dqstri_1 <= 2'b01;
		  datatri_0 <= 2'b01;
		  datatri_1 <= 2'b01;
	      end
	      WR_4: begin
		  state <= WR_5;
		  dqstri_0 <= 2'b00;
		  dqstri_1 <= 2'b00;
		  datatri_0 <= 2'b10;
		  datatri_1 <= 2'b10;
	      end
	      WR_5:
		state <= WR_6;
	      WR_6:
		state <= WR_7;
	      WR_7:
		state <= PRE_1;

	      PRE_1: begin
		  cmd_0 <= CMD_PRE;
		  ba_din0 = 0;
		  addr_din0 <= cur_addr[23:10];
		  state <= PRE_2;
	      end
	      PRE_2:
		state <= PRE_3;
	      PRE_3:
		state <= IDLE;
	      
	      

	      
	      
	      
	      
		  
	      
		
	      
	      
	    endcase // case (state)
	end
    end
    
    /*AUTOASCIIENUM("state", "state_ascii")*/
    // Beginning of automatic ASCII enum decoding
    reg [47:0]		state_ascii;		// Decode of state
    always @(state) begin
	case ({state})
	  RESET:    state_ascii = "reset ";
	  INIT_1:   state_ascii = "init_1";
	  INIT_2:   state_ascii = "init_2";
	  INIT_3:   state_ascii = "init_3";
	  INIT_4:   state_ascii = "init_4";
	  INIT_5:   state_ascii = "init_5";
	  INIT_6:   state_ascii = "init_6";
	  INIT_7:   state_ascii = "init_7";
	  INIT_8:   state_ascii = "init_8";
	  IDLE:     state_ascii = "idle  ";
	  ACT_1:    state_ascii = "act_1 ";
	  ACT_2:    state_ascii = "act_2 ";
	  ACT_3:    state_ascii = "act_3 ";
	  RD_1:     state_ascii = "rd_1  ";
	  RD_2:     state_ascii = "rd_2  ";
	  RD_3:     state_ascii = "rd_3  ";
	  RD_4:     state_ascii = "rd_4  ";
	  RD_5:     state_ascii = "rd_5  ";
	  RD_6:     state_ascii = "rd_6  ";
	  WR_1:     state_ascii = "wr_1  ";
	  WR_2:     state_ascii = "wr_2  ";
	  WR_3:     state_ascii = "wr_3  ";
	  WR_4:     state_ascii = "wr_4  ";
	  WR_5:     state_ascii = "wr_5  ";
	  WR_6:     state_ascii = "wr_6  ";
	  PRE_1:    state_ascii = "pre_1 ";
	  PRE_2:    state_ascii = "pre_2 ";
	  PRE_3:    state_ascii = "pre_3 ";
	  PRE_4:    state_ascii = "pre_4 ";
	  PRE_5:    state_ascii = "pre_5 ";
	  default:  state_ascii = "%Error";
	endcase
    end
    // End of automatics

    /*AUTOASCIIENUM("cmd_0", "cmd_0_ascii")*/
    // Beginning of automatic ASCII enum decoding
    reg [55:0]		cmd_0_ascii;		// Decode of cmd_0
    always @(cmd_0) begin
	case ({cmd_0})
	  CMD_MRS:  cmd_0_ascii = "cmd_mrs";
	  CMD_REF:  cmd_0_ascii = "cmd_ref";
	  CMD_PRE:  cmd_0_ascii = "cmd_pre";
	  CMD_ACT:  cmd_0_ascii = "cmd_act";
	  CMD_WR:   cmd_0_ascii = "cmd_wr ";
	  CMD_RD:   cmd_0_ascii = "cmd_rd ";
	  CMD_NOP:  cmd_0_ascii = "cmd_nop";
	  CMD_ZQC:  cmd_0_ascii = "cmd_zqc";
	  default:  cmd_0_ascii = "%Error ";
	endcase
    end
    // End of automatics
    


    

endmodule // ddr3_controller

