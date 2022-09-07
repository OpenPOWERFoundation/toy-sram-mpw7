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

* appears some gpio's are used by flash??? don't see any comments anywhere - bit 3?.  core now running...
* and scan in/out somehow works!

```
make verify-toysram_scan-rtl
...
[00000004] Test Enable is inactive.
[00000080] Releasing reset.
[00002000] ...tick...
[00004000] ...tick...
[00006000] ...tick...
[00008000] ...tick...
[00010000] ...tick...
[00012000] ...tick...
[00014000] ...tick...
[00015000] Setting Test Enable.
[00015000] Test Enable is active.
[00015003] Writing scan reg: 0123456789abcdeffedcba9876543210
[00015007] Scanning in...
[00016000] ...tick...
[00016031] Scan complete.
[00016035] Scanning out...
[00017059] Scan complete.
[00017059] Read scan reg: 0123456789abcdeffedcba9876543210
[00017100] Test Enable is inactive.

[00017139] You has opulence.

```

Refer to [README](docs/source/index.rst) for this sample project documentation.
