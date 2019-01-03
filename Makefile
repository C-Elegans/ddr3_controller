VFLAGS=-Dsg107 -Dx16 -Dden1024Mb -g2005-sv
dump.vcd: tb
	vvp tb
tb: ddr3_controller_tb.v ddr3_controller.v ddr3.v
	iverilog $(VFLAGS) -o $@ $^
