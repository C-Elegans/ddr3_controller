module ddr3_controller(/*AUTOARG*/
    // Outputs
    RST_N, CK, CK_N, CKE, CS_N, RAS_N, CAS_N, WE_N, BA, ADDR, ODT,
    // Inouts
    DM_TDQS, DQ, DQS, DQS_N,
    // Inputs
    TDQS_N, clk, rst
    );
`include "1024Mb_ddr3_parameters.vh"
    /* DDR3 Signals */
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
    output [12:0] 	 ADDR;
    output 		 ODT;

    /* Module Signals */
    input 		 clk;
    input 		 rst;


endmodule // ddr3_controller

