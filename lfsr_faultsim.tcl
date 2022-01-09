read_netlist hw_assignment/syn/techlib/NangateOpenCellLibrary.v -format verilog -library -insensitive
read_netlist hw_assignment/syn/output/riscv_core_scan.v -format verilog -master -insensitive

run_build_model riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800

run_drc hw_assignment/syn/output/riscv_core_scan.spf

set_patterns -external riscv_dumpports.vcd.fixed -sensitive -strobe_period {100 ns} -strobe_offset {40 ns} -vcd_clock auto

set_faults -model stuck

add_faults -all

run_fault_sim

set_faults -fault_coverage

set_faults -fault_coverage
report_summaries
report_faults -profile

