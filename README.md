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
[00017059] Scan good.

[00017063] Writing scan reg: ff6e5d4c3b2a19080091a2b3c4d5e6f7
[00017067] Scanning in...
[00018000] ...tick...
[00018091] Scan complete.
[00018095] Scanning out...
[00019119] Scan complete.
[00019119] Read scan reg: ff6e5d4c3b2a19080091a2b3c4d5e6f7
[00019119] Scan good.

[00019123] Writing scan reg: 0048d159e26af37bffb72ea61d950c84
[00019127] Scanning in...
[00020000] ...tick...
[00020151] Scan complete.
[00020155] Scanning out...
[00021179] Scan complete.
[00021179] Read scan reg: 0048d159e26af37bffb72ea61d950c84
[00021179] Scan good.

[00021183] Writing scan reg: ffdb97530eca8642002468acf13579bd
[00021187] Scanning in...
[00022000] ...tick...
[00022211] Scan complete.
[00022215] Scanning out...
[00023239] Scan complete.
[00023239] Read scan reg: ffdb97530eca8642002468acf13579bd
[00023239] Scan good.

[00023243] Writing scan reg: 00123456789abcdeffedcba987654321
[00023247] Scanning in...
[00024000] ...tick...
[00024271] Scan complete.
[00024275] Scanning out...
[00025299] Scan complete.
[00025299] Read scan reg: 00123456789abcdeffedcba987654321
[00025299] Scan good.

[00025303] Writing scan reg: 7ff6e5d4c3b2a19080091a2b3c4d5e6f
[00025307] Scanning in...
[00026000] ...tick...
[00026331] Scan complete.
[00026335] Scanning out...
[00027359] Scan complete.
[00027359] Read scan reg: 7ff6e5d4c3b2a19080091a2b3c4d5e6f
[00027359] Scan good.

[00027363] Writing scan reg: 40048d159e26af37bffb72ea61d950c8
[00027367] Scanning in...
[00028000] ...tick...
[00028391] Scan complete.
[00028395] Scanning out...
[00029419] Scan complete.
[00029419] Read scan reg: 40048d159e26af37bffb72ea61d950c8
[00029419] Scan good.

[00029423] Writing scan reg: dffdb97530eca8642002468acf13579b
[00029427] Scanning in...
[00030000] ...tick...
[00030451] Scan complete.
[00030455] Scanning out...
[00031479] Scan complete.
[00031479] Read scan reg: dffdb97530eca8642002468acf13579b
[00031479] Scan good.

[00031483] Writing scan reg: 100123456789abcdeffedcba98765432
[00031487] Scanning in...
[00032000] ...tick...
[00032511] Scan complete.
[00032515] Scanning out...
[00033539] Scan complete.
[00033539] Read scan reg: 100123456789abcdeffedcba98765432
[00033539] Scan good.

[00033543] Writing scan reg: f7ff6e5d4c3b2a19080091a2b3c4d5e6
[00033547] Scanning in...
[00034000] ...tick...
[00034571] Scan complete.
[00034575] Scanning out...
[00035599] Scan complete.
[00035599] Read scan reg: f7ff6e5d4c3b2a19080091a2b3c4d5e6
[00035599] Scan good.

[00035644] Test Enable is inactive.

[00035683] You has opulence.

```

Refer to [README](docs/source/index.rst) for this sample project documentation.
