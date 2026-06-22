# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# defaults
SIM ?= icarus
FST ?= -fst # Use more efficient FST format
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src
PDK ?= gf180mcuD
PDK_SIM_ROOT ?= $(abspath $(PWD)/../../../pdk_shim)
AS_SCL_VERILOG ?= $(PDK_SIM_ROOT)/$(PDK)/libs.ref/gf180mcu_as_sc_mcu7t3v3/verilog/gf180mcu_as_sc_mcu7t3v3.v
GATE_NETLIST ?= $(PWD)/../runs/wokwi/final/pnl/tt_um_detronyx_arith_lab.pnl.v
PROJECT_SOURCES = detronyx_pdk_maskrom_recip8_256x8.behav.sv detronyx_umul8_comb.sv simd_add8_sparse_v2.v detronyx_add8_sparse_core.sv detronyx_recip8_div8_core.sv project.v
COMPILE_ARGS += -g2012

ifneq ($(GATES),yes)

# RTL simulation:
SIM_BUILD				= sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

else

# Gate level simulation:
SIM_BUILD				= sim_build/gl
COMPILE_ARGS    += -DGL_TEST
COMPILE_ARGS    += -DFUNCTIONAL
COMPILE_ARGS    += -DUSE_POWER_PINS
COMPILE_ARGS    += -DSIM
COMPILE_ARGS    += -DUNIT_DELAY=\#1
VERILOG_SOURCES += $(AS_SCL_VERILOG)
VERILOG_SOURCES += $(PWD)/gf180mcu_as_sc_mcu7t3v3_sim_extra.v

VERILOG_SOURCES += $(GATE_NETLIST)

endif

# Allow sharing configuration between design and testbench via `include`:
COMPILE_ARGS 		+= -I$(SRC_DIR)

# Include the testbench sources:
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tb

# List test modules to run, separated by commas and without the .py suffix:
COCOTB_TEST_MODULES = test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
