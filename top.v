module top(/*AUTOARG*/
    // Outputs
    RST_N, CK, CK_N, CKE, CS_N, RAS_N, CAS_N, WE_N, BA, ADDR, ODT,
    // Inouts
    DM_TDQS, DQ, DQS, DQS_N,
    // Inputs
    clk_100, rst, TDQS_N
    );
`include "1024Mb_ddr3_parameters.vh"
    input clk_100;
    input rst;

    input [DQS_BITS-1:0] TDQS_N;

    inout [1:0] 	 DM_TDQS;
    inout [15:0] 	 DQ;
    inout [1:0] 	 DQS;
    inout [1:0] 	 DQS_N;

    output 		 RST_N;
    output 		 CK, CK_N;
    output 		 CKE;
    output 		 CS_N, RAS_N, CAS_N, WE_N;
    output [2:0] 	 BA;
    output [13:0] 	 ADDR;
    output 		 ODT;
    
    wire 		 clk;
    assign clk_90 = clk;

    pll pll(
	    // Outputs
	    .clko			(clk),
	    // Inputs
	    .clki			(clk_100));
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


endmodule // top
