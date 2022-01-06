vcd dumpports /riscv_testbench/dut/* -file riscv_dumpports.vcd
vcd dumpports /riscv_testbench/rom_mem/* -file rom_memory.vcd
run 1000000 ns
quit
