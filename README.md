# Caravel User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

| :exclamation: Important Note            |
|-----------------------------------------|


## Project description and development: https://github.com/openpowerfoundation/toy-sram

This project is a test site for a custom 10T array cell design.  It is built as a 32x32 2R1W regfile and includes Wishbone and scan I/O access.


### Sim

* should build and sim; z on outs an x on ins
* looks like VexRisc is stuck waiting for ack for ifetch=100002C0; jump to main

```
100002c0 <main>:
```
* appears some gpio's are used by flash??? don't see any comments anywhere.  core now running...

```
make verify-toysram_scan-rtl

iverilog -Ttyp -DFUNCTIONAL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
      -f/data/projects/toy-sram-mpw7/mgmt_core_wrapper/verilog/includes/includes.rtl.caravel \
      -f/data/projects/toy-sram-mpw7/verilog/includes/includes.rtl.caravel_user_project \
      -I/data/projects/toy-sram-mpw7/caravel/verilog/../../verilog/rtl/site \
      -o toysram_scan.vvp toysram_scan_tb.v
/data/projects/toy-sram-mpw7/caravel/verilog/rtl/caravel.v:258: warning: input port clock is coerced to inout.
/data/projects/toy-sram-mpw7/verilog/rtl/site/toysram_site.v:272: warning: Port 6 (cfg_dat) of test_ra_sdr_32x32 expects 16 bits, got 32.
/data/projects/toy-sram-mpw7/verilog/rtl/site/toysram_site.v:272:        : Pruning 16 high bits of the expression.
vvp  toysram_scan.vvp
Reading toysram_scan.hex
toysram_scan.hex loaded into memory
Memory 5 bytes = 0x6f 0x00 0x00 0x0b 0x13
FST info: dumpfile toysram_scan.vcd opened for output.
MPRJ-IO state = zzzzzzzzz

Monitor: Timeout, Test Mega-Project IO Ports (RTL) Failed

toysram_scan_tb.v:81: $finish called at 624987500 (1ps)
mv toysram_scan.vcd RTL-toysram_scan.vcd
/foss/tools/riscv-gnu-toolchain-rv32i/217e7f3debe424d61374d31e33a091a630535937/bin/riscv32-unknown-linux-gnu-objdump -d -S toysram_scan.elf > toysram_scan.lst
rm toysram_scan.elf toysram_scan.vvp
```

Refer to [README](docs/source/index.rst) for this sample project documentation.
