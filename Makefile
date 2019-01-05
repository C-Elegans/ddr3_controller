VFLAGS=-Dsg107 -Dx16 -Dden1024Mb -g2005-sv -gspecify -DSIM -Dmixed_hdl
PRIMITIVES=BB.v CLKDIVF.v DDRDLLA.v DELAYG.v DQSBUFM.v ECLKSYNCB.v
PRIMITIVES+=IDDRX2DQA.v ODDRX2DQA.v ODDRX2DQSB.v OR2.v TSHX2DQA.V
PRIMITIVES+=TSHX2DQSA.v VLO.v OB.v ODDRX1F.v OSHX2A.v VHI.v ODDRX2F.v

FILES=ddr3_controller_tb.v ddr3_controller.v ddr3.v ddr_mem.v gsr_pur_assign.v
FILES+=$(patsubst %,primitives/%, $(PRIMITIVES))
dump.vcd: tb
	vvp tb
tb: ddr3_controller_tb.v ddr3_controller.v ddr3.v ddr_mem.v $(FILES)
	iverilog $(VFLAGS) -o $@ $^


top.json: top.v ddr3_controller.v pll.v ddr_mem.v
	yosys -p 'read_verilog -Dsg107 -Dx16 -Dden1024Mb $^; synth_ecp5 -json $@ -top top' 

%_out.config: %.json
	nextpnr-ecp5 --json $< --basecfg /usr/local/share/trellis/misc/basecfgs/empty_lfe5um5g-45f.config --textcfg $@ --um5g-45k --package CABGA381 --freq 300
