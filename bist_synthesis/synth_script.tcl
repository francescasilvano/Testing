set TECH NangateOpenCell
set synthetic_library dw_foundation.sldb

set search_path [ join "/data/libraries/LIB065 $search_path" ]
set search_path [ join "/data/libraries/NangateOpenCellLibrary_PDKv1_3_v2010_12/fix_scan $search_path" ]
set search_path [ join "/data/libraries/pdt2002 $search_path" ]
set search_path [ join "../techlib/ $search_path" ]

source ../bin/$TECH.dc_setup_synthesis.tcl

analyze -format verilog -work work riscv_core_scan.v
analyze -format vhdl -work work bist_controller.vhd
analyze -format verilog -work work lfsr.v
analyze -format verilog -work work misr.v
analyze -format vhdl -work work multiplexer.vhd
analyze -format vhdl -work work phase_shifter.vhd
analyze -format vhdl -work work riscv_top.vhd

elaborate riscv_top -work work 

link
uniquify
check_design

set_multicycle_path 2 -setup -through [get_pins id_stage_i/registers_i/riscv_register_file_i/mem_reg*/Q]
set_multicycle_path 1 -hold  -through [get_pins id_stage_i/registers_i/riscv_register_file_i/mem_reg*/Q]

set CLOCK_SPEED 2
create_clock      [get_ports clk_i] -period $CLOCK_SPEED -name REF_CLK
set_ideal_network [get_ports clk_i]

set core_outputs [all_outputs]
set core_inputs  [remove_from_collection [all_inputs] [get_ports clk_i]]
set core_inputs  [remove_from_collection $core_inputs [get_ports rst_ni]]

set INPUT_DELAY  [expr 0.4*$CLOCK_SPEED]
set OUTPUT_DELAY [expr 0.4*$CLOCK_SPEED]

set_input_delay  $INPUT_DELAY  $core_inputs  -clock [get_clock]
set_output_delay $OUTPUT_DELAY [all_outputs] -clock [get_clock]

set_ideal_network       -no_propagate    [all_connected  [get_ports rst_ni]]
set_ideal_network       -no_propagate    [get_nets rst_ni]
set_dont_touch_network  -no_propagate    [get_ports rst_ni]
set_multicycle_path 2   -from            [get_ports   rst_ni]

compile_ultra -no_autoungroup
change_names -hierarchy -rules verilog
report_area
