`define verilator3 // to force to use sim friendly components
`include "j68_cpu/rtl/j68_alu.v"
`include "j68_cpu/rtl/j68_flags.v"
`include "j68_cpu/rtl/j68_test.v"
`include "j68_cpu/rtl/j68_loop.v"
`include "j68_cpu/rtl/j68_addsub_32.v"
`include "j68_cpu/rtl/j68_decode.v"
`include "j68_cpu/rtl/j68_decode_rom.v"
`include "j68_cpu/rtl/j68_mem_io.v"
`include "j68_cpu/rtl/j68_dpram_2048x20.v"
`include "j68_cpu/rtl/cpu_j68.v"
`undef verilator3
