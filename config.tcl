# User config
set ::env(DESIGN_NAME) core

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# Fill this
set ::env(CLOCK_PERIOD) 30
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_TREE_SYNTH) 1
set ::env(PL_TARGET_DENSITY) 0.55
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"
#set ::env(SYNTH_STRATEGY) "DELAY 0"
set ::env(SYNTH_MAX_FANOUT) 3
#set ::env(SYNTH_DRIVING_CELL) "sky130_fd_sc_hd__inv_16"

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}

