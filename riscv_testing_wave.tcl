vcd dumpports /riscv_testbench/dut/* -file riscv_dumpports.vcd
vcd dumpports /riscv_testbench/misr1/* -file riscv_misr1.vcd
vcd dumpports /riscv_testbench/misr2/* -file riscv_misr2.vcd
vcd dumpports /riscv_testbench/controller/* -file riscv_controller.vcd
run 16020000 ns
quit
