// --------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------
// Copyright (c) 2010 by Lattice Semiconductor Corporation
// --------------------------------------------------------------------
//
//
//                     Lattice Semiconductor Corporation
//                     5555 NE Moore Court
//                     Hillsboro, OR 97214
//                     U.S.A.
//
//                     TEL: 1-800-Lattice  (USA and Canada)
//                          1-408-826-6000 (other locations)
//
//                     web: http://www.latticesemi.com/
//                     email: techsupport@latticesemi.com
//
// --------------------------------------------------------------------
//
// Simulation Library File for SEDGA in ECP5U/M
//
`resetall
`timescale 1 ns / 1 ps

`celldefine

module SEDGA (SEDENABLE, SEDSTART, SEDFRCERR, SEDCLKOUT, SEDDONE, SEDINPROG, SEDERR);

input	SEDENABLE, SEDSTART, SEDFRCERR; 
output	SEDCLKOUT, SEDDONE, SEDINPROG, SEDERR;

parameter SED_CLK_FREQ = "2.4";   // 2.4, 4.8, 9.7, 19.4, 38.8, 77.5, 155.0
parameter CHECKALWAYS  = "DISABLED";
parameter DEV_DENSITY  = "85KUM"; // 25KUM, 45KU, 45KUM, 85KUM

reg      SEDCLKOUTB, start, done, inprog, err;
reg      clkout_i;
wire     clkout;
wire reset; 
reg cs,ns; 
integer  count, sed_count;
integer  i;
reg [63:0] sed_clk_frequency;
real     clk_freq;
realtime osc_half_clk;

parameter IDLE = 1'b0;  
parameter START = 1'b1; 

//initialization
initial begin
	SEDCLKOUTB = 1'b0;
	start = 1'b0;
	done = 1'b0;
	inprog = 1'b0;
	err = 1'b0;
    count = 0;
end

//clk gen
initial begin
	sed_clk_frequency = SED_CLK_FREQ;
    clkout_i = 0;
	//i = $sscanf(SED_CLK_FREQ, "%f", clk_freq);
	i = $sscanf(sed_clk_frequency, "%f", clk_freq);
	osc_half_clk = (500 / clk_freq);
	forever begin
		#osc_half_clk clkout_i = ~clkout_i;
	end
end

//time count for sed according to device density
initial begin

	if((DEV_DENSITY == "25KUM")|| (DEV_DENSITY == "25KU"))begin
		sed_count = 559588;   // (Total Fuse_count)/8 => 4476704/8
	end
	else if((DEV_DENSITY == "45KUM")||(DEV_DENSITY == "45KU")) begin
		sed_count = 1001453;   // 8011620/8
	end
	else if((DEV_DENSITY == "85KUM")||(DEV_DENSITY == "85KU")) begin
		sed_count = 1887748;   // 15101984/8
	end
	end // initial begin

assign clkout = clkout_i;

assign reset = SEDENABLE ? 1'b0 : 1'b1;

//clk output
always @(SEDENABLE or clkout) begin
	if(SEDENABLE == 1'b1) begin
		SEDCLKOUTB = clkout;
	end
	else begin
		SEDCLKOUTB = 1'b0;
	end
end

reg sed_start_dly;
wire sed_start_pulse; 
assign sed_start_pulse = SEDSTART & ~sed_start_dly & SEDENABLE;  //generating a pulse for start logic 

always @(posedge clkout)       // logic for generating a pulse
begin 
	sed_start_dly <= SEDSTART; 
end

//Start sequence FSM
always @(posedge clkout or posedge reset) begin     //current block
	if(reset)
		cs <= IDLE; 
	else 
		cs <= ns; 
	end

always @(cs or sed_start_pulse or done) begin	// next state block
	case(cs)
	IDLE:	begin 
		if (sed_start_pulse == 1'b1)
		ns = START; 
		else 
		ns = IDLE; 
		end 

	START:	begin 
		if (done == 1'b0)
		ns = START; 
		else 
		ns = IDLE; 
		end

       default: ns = IDLE;
		   
	endcase 
end

always @ (cs) begin 			// output block
	case (cs)
	IDLE:	start = 1'b0; 
	START:	start = 1'b1; 
        default: start = 1'b0; 
	endcase
end

//inprog signal trigger
always @(posedge clkout or posedge reset) begin
	if(reset) 
	inprog <= 1'b0;
	else 
		begin
		if(start == 1'b1)
			inprog <= 1'b1;
		else	
			inprog <= 1'b0;
		end
end

//err output
always @(SEDFRCERR or SEDENABLE or done) begin
	if(SEDFRCERR == 1'b1 && SEDENABLE == 1'b1 && done == 1'b1) begin
		err = #10 1'b1;
	end
	else if(SEDFRCERR == 1'b0 || SEDENABLE == 1'b0) begin
		err = 1'b0;
	end
	else;//err <= err;
end

//internal count when doing sed
always @(posedge clkout or posedge reset) begin
	if (reset)
		count <= 0; 
	else
	begin
		if(start == 1'b1) begin
			if(count < sed_count)
			count <= count + 1;
			else 
			count <= 0;  
		end
		else
			count <= 0;
	end
end

//sed finish trigger
always @(posedge clkout or posedge reset) begin
	if (reset)
		done = 1'b0; 
	else 
	begin 
		if(count == sed_count)
		done <= 1'b1;
		else 
		done <= 1'b0;
	end
end

//buffer err, done, inprog, SEDCLKOUTB before sending out
buf (SEDERR, err);
buf (SEDDONE, done);
buf (SEDINPROG, inprog);
buf (SEDCLKOUT, SEDCLKOUTB);

endmodule  

`endcelldefine



