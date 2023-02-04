# toysram 16x12 subarray test

## Current (WWL fix)

* copy custom files

```
cp ~/projects/toysram-osu/magic/abstract/10T_16x12_2r1w_top.lef macros/10T_16x12_2r1w_magic_flattened.lef
```

* ***edit .lef to add "c_" to module name references so it doesn't start with number (think i needed to, so verilog module name matches)***

```
cp ~/projects/toysram-osu/magic/abstract/GDS/10T_16x12_2r1w_magic_flattened.gds macros
```

* run flow - diff error earlier in flow; may have to update setup files to change placement?

```
make toysram_16x12
...
[STEP 8]
[INFO]: Running Global Placement...
[STEP 9]
[INFO]: Running Placement Resizer Design Optimizations...
[ERROR]: during executing openroad script /openlane/scripts/openroad/resizer.tcl
[ERROR]: Exit code: 1
[ERROR]: full log: ../data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/logs/placement/9-resizer.log
[ERROR]: Last 10 lines:
[INFO DPL-0021] HPWL before           14519.2 u
[INFO DPL-0022] HPWL after            14469.4 u
[INFO DPL-0023] HPWL delta               -0.3 %
[WARNING DPL-0005] Overlap check failed (1).
 ra overlaps TAP_180
[WARNING DPL-0006] Site aligned check failed (1).
 ra
[ERROR DPL-0033] detailed placement checks failed.
DPL-0033
child process exited abnormally
```

* ***warnings in floorplanning!***
* openlane/toysram_16x12/runs/wtf/logs/floorplan/3-initial_fp.log

```
[INFO ODB-0222] Reading LEF file: /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/tmp/merged.unpadded.nom.lef
[WARNING ODB-0186] macro c_10T_16x12_2r1w_magic_flattened references unknown site 12T
[INFO ODB-0223]     Created 13 technology layers
[INFO ODB-0224]     Created 25 technology vias
[INFO ODB-0225]     Created 442 library cells
[INFO ODB-0226] Finished LEF file:  /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/tmp/merged.unpadded.nom.lef
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_0 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_1 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_10 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_11 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_12 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_13 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_14 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_15 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_2 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_3 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_4 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_5 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_6 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_7 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_8 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port RWL0_9 not found.
```

* now RWL0 missing; RWL1 exists

```
grep RWL macros/*.lef
  PIN RWL1_0
  END RWL1_0
  PIN RWL1_1
  END RWL1_1
  PIN RWL1_10
  END RWL1_10
  PIN RWL1_11
  END RWL1_11
  PIN RWL1_12
  END RWL1_12
  PIN RWL1_13
  END RWL1_13
  PIN RWL1_14
  END RWL1_14
  PIN RWL1_15
  END RWL1_15
  PIN RWL1_2
  END RWL1_2
  PIN RWL1_3
  END RWL1_3
  PIN RWL1_4
  END RWL1_4
  PIN RWL1_5
  END RWL1_5
  PIN RWL1_6
  END RWL1_6
  PIN RWL1_7
  END RWL1_7
  PIN RWL1_8
  END RWL1_8
  PIN RWL1_9
  END RWL1_9
```




## Old

* with 'new' .lef (after git pull) - getting syntax error - fixed; line 5266 should be PORT
* seems to get same messages as original run below...

* getting a warning for missing ports (WWL) during floorplanning - think this is real problem (no WWL in .lef)
* getting a detailed routing error for bit line (no access point); not sure about that one - layer related?

### Setup to build subarray as macro

```
setup_openlane # proc to set up PDK_ROOT, etc.
```

* copy custom files

```
cp ~/projects/toysram-osu/magic/New_16x12_flat/10T_16x12_2r1w_magic_flattened.lef macros
```

* ***edit .lef to add "c_" to module name references so it doesn't start with number (think i needed to, so verilog module name matches)***

```
cp ~/projects/toysram-osu/magic/New_16x12_flat/10T_16x12_2r1w_magic_flattened.gds macros
```

* add wrapper_16x12.v (top with vectors and custom instantiation) and wrapper_custom_16x12.v (empty module matching custom i/o names) to verilog/rtl/wrapper/

* set up openlane/toysram_16x12 files: config.tcl, macro.cfg, pin_order.cfg to use verilog and custom macro files

```
make toysram_16x12
...
[STEP 22]
[INFO]: Running Detailed Routing...
[ERROR]: during executing openroad script /openlane/scripts/openroad/droute.tcl
[ERROR]: Exit code: 1
[ERROR]: full log: ../data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/logs/routing/22-detailed.log
[ERROR]: Last 10 lines:
[WARNING DRT-6000] Macro pin has more than 1 polygon
[WARNING DRT-6000] Macro pin has more than 1 polygon
[WARNING DRT-6000] Macro pin has more than 1 polygon
[WARNING DRT-6000] Macro pin has more than 1 polygon
[WARNING DRT-6000] Macro pin has more than 1 polygon
[WARNING DRT-6000] Macro pin has more than 1 polygon
[WARNING DRT-6000] Macro pin has more than 1 polygon
[ERROR DRT-0073] No access point for ra/RBL0_0.
Error: droute.tcl, 46 DRT-0073
child process exited abnormally
```

* ***warnings in floorplanning!***
* openlane/toysram_16x12/runs/wtf/logs/floorplan/3-initial_fp.log
* ```grep WWL macros/10T_16x12_2r1w_magic_flattened.lef``` finds nothing

```
OpenROAD 0b8b7ae255f8fbbbefa57d443949b84e73eed757
This program is licensed under the BSD-3 license. See the LICENSE file for details.
Components of this program may be licensed under more restrictive licenses which must be honored.
[INFO ODB-0222] Reading LEF file: /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/tmp/merged.unpadded.nom.lef
[INFO ODB-0223]     Created 13 technology layers
[INFO ODB-0224]     Created 25 technology vias
[INFO ODB-0225]     Created 442 library cells
[INFO ODB-0226] Finished LEF file:  /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/tmp/merged.unpadded.nom.lef
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_0 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_1 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_10 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_11 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_12 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_13 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_14 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_15 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_2 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_3 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_4 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_5 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_6 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_7 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_8 not found.
[WARNING STA-0201] /data/projects/toy-sram-mpw7/openlane/toysram_16x12/runs/wtf/results/synthesis/toysram_16x12.v line 13, instance ra port WWL_9 not found.
```

* openlane/toysram_16x12/runs/wtf/logs/routing/22-detailed.log

```
...
[ERROR DRT-0073] No access point for ra/RBL0_0.
Error: droute.tcl, 46 DRT-0073
```

* is this a real error?  or caused by renaming lef? or i have setup somthing wrong???

```
grep RBL0_0 macros/10T_16x12_2r1w_magic_flattened.lef
  PIN RBL0_0
  END RBL0_0
```

* in .lef:
```
  PIN RBL0_0
    DIRECTION OUTPUT ;
    USE SIGNAL ;
    ANTENNADIFFAREA 0.722400 ;
    PORT
      LAYER li1 ;
        RECT 2.650 20.405 2.725 20.615 ;
        RECT 2.650 19.055 2.725 19.265 ;
        RECT 2.650 17.705 2.725 17.915 ;
        RECT 2.650 16.355 2.725 16.565 ;
        RECT 2.650 15.005 2.725 15.215 ;
        RECT 2.650 13.655 2.725 13.865 ;
        RECT 2.650 12.305 2.725 12.515 ;
        RECT 2.650 10.955 2.725 11.165 ;
        RECT 2.650 9.605 2.725 9.815 ;
        RECT 2.650 8.255 2.725 8.465 ;
        RECT 2.650 6.905 2.725 7.115 ;
        RECT 2.650 5.555 2.725 5.765 ;
        RECT 2.650 4.205 2.725 4.415 ;
        RECT 2.650 2.855 2.725 3.065 ;
        RECT 2.650 1.505 2.725 1.715 ;
        RECT 2.650 0.155 2.725 0.365 ;
    END
  END RBL0_0
```

* in a DFFRAM .lef; seems similar except for layer

```
  PIN Do0[0]
    DIRECTION OUTPUT TRISTATE ;
    USE SIGNAL ;
    PORT
      LAYER met2 ;
        RECT 6.070 98.640 6.350 100.640 ;
    END
  END Do0[0]
```

# Caravel User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

| :exclamation: Important Note            |
|-----------------------------------------|


## Project description and development: https://github.com/openpowerfoundation/toy-sram

This project is a test site for a custom 10T array cell design.  It is built as a 32x32 2R1W regfile and includes Wishbone and scan I/O access.

### Notes

* https://docs.google.com/document/d/1Y7LuP_0dJ_vmD8G_Twc6qc97fj7aW5pRV5nAjN2oOUk/edit#heading=h.hdj6ymredbfl

### To Do

* add TE output from control; hold wb_slaave (at least) in reset when active
* test reading cfg0; add some status bits to it (te, ?)

### Sim

* test scan and array I/O and procedures

```
make verify-toysram_scan-rtl
...
[00000004] Test Enable is inactive.
[00000080] Releasing reset.
[00002500] ...tick...
[00005000] ...tick...
[00007500] ...tick...
[00010000] ...tick...
[00012500] ...tick...
[00015000] ...tick...
[00015000] Setting Test Enable.
[00015000] Test Enable is active.
[00015003] Writing scan reg: 0123456789abcdeffedcba9876543210
[00015007] Scanning in...
[00016031] Scan complete.
[00016035] Scanning out...
[00017059] Scan complete.
[00017059] Read scan reg: 0123456789abcdeffedcba9876543210
[00017059] Scan good.

[00017063] Resetting array.
[00017107] Array cmds: R0[0], R1[1], W0[0]=08675309
[00017111] Writing scan reg: 07fffffff87fffffffc010cea613babe
[00017111] R0[00]=ffffffff  R1[01]=ffffffff  W0[0]=08675309
[00017115] Scanning in...
[00017500] ...tick...
[00018139] Scan complete.
[00018139] R0_EN=1, R1_EN=1, W0_EN=1
[00018143] Clocking array (set up input regs)...
[00018151] Clocking array (clock array)...
[00018159] R0_EN=1, R1_EN=1, W0_EN=0
[00018167] Scanning out...
[00019191] Scan complete.
[00019191] Read scan reg: 0000000000400000000010cea613babe
[00019191] R0[00]=00000000  R1[01]=00000000 W0[0]=08675309
[00019195] Scanning in (restore)...
[00020000] ...tick...
[00020219] Scan complete.
[00020219] Clocking array...
[00020231] Scanning out nondestructively...
[00021255] Scan complete.
[00021255] Read scan reg: 0000000000400000000010cea613babe
[00021255] R0[00]=00000000  R1[01]=00000000 W0[0]=08675309
[00021259] Scanning out...
[00022283] Scan complete.
[00022283] Read scan reg: 0000000000400000000010cea613babe
[00022283] R0[00]=00000000  R1[01]=00000000 W0[0]=08675309
[00022283] Nondestructive scan good.

[00022291] Scanning in (restore)...
[00022500] ...tick...
[00023315] Scan complete.
[00023315] Clocking array...
[00023327] Scanning out nondestructively...
[00024351] Scan complete.
[00024351] Read scan reg: 00433a9848400000000010cea613babe
[00024351] R0[00]=08675309  R1[01]=00000000 W0[0]=08675309
[00024351] R0 good.

[00024392] Test Enable is inactive.

[00024431] You has opulence.
```



* run VexRiscv code to write/read the array (monitor I/O for run/error/status bits)

```
make verify-toysram_wb-rtl
...
[00000004] User=Z
[00000004] Test Enable is inactive.
[00000080] Releasing reset.
[00000080] Reset is inactive.
[00005000] ...tick...
[00010000] ...tick...
[00015000] ...tick...
[00017278] User=0
[00017278] Error is inactive.
[00017278] RunMode is active.
[00020000] ...tick...
[00025000] ...tick...
[00026955] User=1
[00030000] ...tick...
[00035000] ...tick...
[00040000] ...tick...
[00045000] ...tick...
[00050000] ...tick...
[00055000] ...tick...
[00060000] ...tick...
[00065000] ...tick...
[00070000] ...tick...
[00075000] ...tick...
[00080000] ...tick...
[00085000] ...tick...
[00090000] ...tick...
[00095000] ...tick...
[00100000] ...tick...
[00105000] ...tick...
[00110000] ...tick...
[00112862] User=2
[00115000] ...tick...
[00120000] ...tick...
[00125000] ...tick...
[00130000] ...tick...
[00135000] ...tick...
[00140000] ...tick...
[00145000] ...tick...
[00150000] ...tick...
[00155000] ...tick...
[00160000] ...tick...
[00165000] ...tick...
[00170000] ...tick...
[00175000] ...tick...
[00180000] ...tick...
[00185000] ...tick...
[00190000] ...tick...
[00195000] ...tick...
[00200000] ...tick...
[00201404] User=3
[00205000] ...tick...
[00210000] ...tick...
[00215000] ...tick...
[00220000] ...tick...
[00225000] ...tick...
[00230000] ...tick...
[00235000] ...tick...
[00240000] ...tick...
[00245000] ...tick...
[00250000] ...tick...
[00255000] ...tick...
[00260000] ...tick...
[00265000] ...tick...
[00270000] ...tick...
[00275000] ...tick...
[00280000] ...tick...
[00285000] ...tick...
[00290000] ...tick...
[00295000] ...tick...
[00300000] ...tick...
[00305000] ...tick...
[00310000] ...tick...
[00315000] ...tick...
[00320000] ...tick...
[00325000] ...tick...
[00330000] ...tick...
[00335000] ...tick...
[00340000] ...tick...
[00345000] ...tick...
[00350000] ...tick...
[00355000] ...tick...
[00360000] ...tick...
[00365000] ...tick...
[00370000] ...tick...
[00375000] ...tick...
[00380000] ...tick...
[00385000] ...tick...
[00387857] RunMode is inactive.

[00387857] You has opulence.


```

Refer to [README](docs/source/index.rst) for this sample project documentation.
