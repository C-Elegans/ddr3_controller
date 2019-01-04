VFLAGS=-Dsg107 -Dx16 -Dden1024Mb -g2005-sv -DSIM
dump.vcd: tb
	vvp tb
tb: ddr3_controller_tb.v ddr3_controller.v ddr3.v
	iverilog $(VFLAGS) -o $@ $^


top.json: top.v ddr3_controller.v pll.v
	yosys -p 'read_verilog -Dsg107 -Dx16 -Dden1024Mb $^; synth_ecp5 -json $@ -top top' 

%_out.config: %.json
	nextpnr-ecp5 --json $< --basecfg /usr/local/share/trellis/misc/basecfgs/empty_lfe5um5g-45f.config --textcfg $@ --um5g-45k --package CABGA381 --freq 300
