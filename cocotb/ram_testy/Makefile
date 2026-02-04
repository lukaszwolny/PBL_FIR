TOPLEVEL = ram
MODULE   = test_ram

VERILOG_SOURCES = \
  $(PWD)/../../src/ram.sv

SIM = icarus
IVERILOG_ARGS = -g2012

IVERILOG_ARGS += -DCOCOTB_SIM

# export COCOTB_SIM_WAVEFORM=vcd
export COCOTB_SIM_VCD=1

include $(shell cocotb-config --makefiles)/Makefile.sim
