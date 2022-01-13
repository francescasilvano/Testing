#!/bin/sh
# Move to the run directory
mkdir -p run
cd run

# Build the files
vlog ../../techlib/NangateOpenCellLibrary.v
vlog ../riscv_core_scan.v
vlog ../lfsr.v
vlog ../misr.v
vcom -2008 -suppress 1141 ../bist_controller.vhd
vcom -2008 -suppress 1141 ../phase_shifter.vhd
vcom -2008 -suppress 1141 ../basic_testbench.vhd

# Invoke QuestaSim shell and run the TCL script
vsim -c -novopt work.riscv_testbench -t 1ns -do ../riscv_testing_wave.tcl -wlf risc_sim.wlf





