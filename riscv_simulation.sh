#!/bin/sh
# Move to the run directory
mkdir -p run
cd run

# Build the files
vlog ../../techlib/NangateOpenCellLibrary.v
vlog ../riscv_core_scan.v
vlog ../lfsr.v
vcom -2008 -suppress 1141 ../scanchain_input_rom.vhd
vcom -2008 -suppress 1141 ../testbench.vhd

# Invoke QuestaSim shell and run the TCL script
vsim -c -novopt work.riscv_testbench -t 1ns -do ../riscv_testing_wave.tcl -wlf risc_sim.wlf





