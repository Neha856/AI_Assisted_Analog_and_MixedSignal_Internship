# User config
set ::env(DESIGN_NAME) design_mux

# Change if needed RTL verilog file
set ::env(VERILOG_FILES) [glob ../verilog/design_mux.v]
 #for macro verilog 
set ::env(VERILOG_FILES_BLACKBOX) [glob ../verilog/AMUX2_3V.v]
# for macro lef
set ::env(EXTRA_LEFS) [glob ../LEF/AMUX2_3V.lef] 
# Timing libraries
set ::env(EXTRA_LIBS) [glob ../LIB/AMUX2_3V.lib]
set ::env(LIB_SYNTH) [glob ../LIB/sky130_fd_sc_hd__tt_025C_1v80.lib]
set ::env(LIB_FASTEST) $::env(LIB_SYNTH)
set ::env(LIB_SLOWEST) $::env(LIB_SYNTH)
set ::env(LIB_TYPICAL) $::env(LIB_SYNTH)



# Fill this
set ::env(CLOCK_PERIOD) "10"
set ::env(CLOCK_PORT) "select" 
# low for small designs
set ::env(FP_CORE_UTIL) 20
# optimized value
set ::env(PL_TARGET_DENSITY) 0.4 
#for small designs
set ::env(FP_PDN_VOFFSET) 4
set ::env(FP_PDN_VPITCH) 15
set ::env(FP_PDN_HOFFSET) 4
set ::env(FP_PDN_HPITCH) 15

 


set filename $::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/$::env(PDK)_$::env(PDK_VARIANT)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}


