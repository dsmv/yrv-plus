# Compile script for the ExaNIC V5P Ultrascale+ NIC FDK.

#set output_prefix "calc_moex_curr"


set project_name "yrv_mcu"
puts $project_name

# 







append synth_args ""




create_project -in_memory -part xc7z020clg400-1



read_verilog -sv -verbose ../../src/src/yrv/yrv_mcu.v

set_property top yrv_mcu [current_fileset]
set_property source_mgmt_mode All [current_project]
update_compile_order -fileset sources_1

eval synth_design -help


eval synth_design -top yrv_mcu \
    -verilog_define BOOT_FROM_AUX_UART \
    -verilog_define CLK_FREQUENCY=50000000 \
    -include_dirs ../../src/src/yrv \
    -directive Default \
    -flatten_hierarchy none    \
    -keep_equivalent_registers  \
    -fsm_extraction one_hot     \
    -resource_sharing off       \
    -no_lc                      \
    -shreg_min_size 5           \
    -mode out_of_context        \
    $synth_args

write_checkpoint -force "${project_name}_post_synth.dcp"
write_edif -force "../${project_name}.edn"

##
### Now that synthesis has completed, we can add a debug core and connect
### signals we're interested in, if required. Leave debug_clk unset or set
### to 'none' if you don't want to add a debug core.
##if {[string toupper $debug_clk] != "NONE"} {
##    source "debug.tcl"
##}

#close_project

