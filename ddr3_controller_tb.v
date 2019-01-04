`timescale 1ns/1ps

// `define sg107
// `define x16
`define PERIOD 250
module ddr3_controller_tb;
 `include "1024Mb_ddr3_parameters.vh"
    /*AUTOREGINPUT*/
    // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
    reg			clk;			// To controller of ddr3_controller.v
    reg			clk_90;			// To controller of ddr3_controller.v
    reg			rst;			// To controller of ddr3_controller.v
    // End of automatics
    /*AUTOWIRE*/
    // Beginning of automatic wires (for undeclared instantiated-module outputs)
    wire [13:0]		ADDR;			// From controller of ddr3_controller.v
    wire [2:0]		BA;			// From controller of ddr3_controller.v
    wire		CAS_N;			// From controller of ddr3_controller.v
    wire		CK;			// From controller of ddr3_controller.v
    wire		CKE;			// From controller of ddr3_controller.v
    wire		CK_N;			// From controller of ddr3_controller.v
    wire		CS_N;			// From controller of ddr3_controller.v
    wire [DM_BITS-1:0]	DM_TDQS;		// To/From controller of ddr3_controller.v, ...
    wire [DQ_BITS-1:0]	DQ;			// To/From controller of ddr3_controller.v, ...
    wire [DQS_BITS-1:0]	DQS;			// To/From controller of ddr3_controller.v, ...
    wire [DQS_BITS-1:0]	DQS_N;			// To/From controller of ddr3_controller.v, ...
    wire		ODT;			// From controller of ddr3_controller.v
    wire		RAS_N;			// From controller of ddr3_controller.v
    wire		RST_N;			// From controller of ddr3_controller.v
    wire [DQS_BITS-1:0]	TDQS_N;			// From mem of ddr3.v
    wire		WE_N;			// From controller of ddr3_controller.v
    // End of automatics

    
    ddr3_controller controller(/*AUTOINST*/
			       // Outputs
			       .RST_N		(RST_N),
			       .CK		(CK),
			       .CK_N		(CK_N),
			       .CKE		(CKE),
			       .CS_N		(CS_N),
			       .RAS_N		(RAS_N),
			       .CAS_N		(CAS_N),
			       .WE_N		(WE_N),
			       .BA		(BA[2:0]),
			       .ADDR		(ADDR[13:0]),
			       .ODT		(ODT),
			       // Inouts
			       .DM_TDQS		(DM_TDQS[1:0]),
			       .DQ		(DQ[15:0]),
			       .DQS		(DQS[1:0]),
			       .DQS_N		(DQS_N[1:0]),
			       // Inputs
			       .TDQS_N		(TDQS_N[DQS_BITS-1:0]),
			       .clk		(clk),
			       .clk_90		(clk_90),
			       .rst		(rst));

    ddr3 mem(
	     // Outputs
	     .tdqs_n			(TDQS_N[DQS_BITS-1:0]),
	     // Inouts
	     .dm_tdqs			(DM_TDQS[DM_BITS-1:0]),
	     .dq			(DQ[DQ_BITS-1:0]),
	     .dqs			(DQS[DQS_BITS-1:0]),
	     .dqs_n			(DQS_N[DQS_BITS-1:0]),
	     // Inputs
	     .rst_n			(RST_N),
	     .ck			(CK),
	     .ck_n			(CK_N),
	     .cke			(CKE),
	     .cs_n			(CS_N),
	     .ras_n			(RAS_N),
	     .cas_n			(CAS_N),
	     .we_n			(WE_N),
	     .ba			(BA[BA_BITS-1:0]),
	     .addr			(ADDR[ADDR_BITS-1:0]),
	     .odt			(ODT)
	     /*AUTOINST*/);


    initial begin
	$dumpfile("dump.vcd");
	$dumpvars;
	clk = 0;
	rst = 1;

	#10 rst = 0;
	#5000 $finish;
    end
    always #1.25 clk = ~clk;
    always @(clk)
      #0.063 clk_90 <= clk;
      
	  
	

endmodule // ddr3_controller_tb

      
