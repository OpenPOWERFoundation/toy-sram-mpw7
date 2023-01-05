# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

# mgmt-core: https://github.com/efabless/caravel_mgmt_soc_litex/blob/main/openlane/mgmt_core/config.tcl

set ::env(PDK) $::env(PDK)
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) toysram_16x12

# ---------------------------------------------------------------------------------------------
# Core

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/wrapper/wrapper_16x12.v \
   "
# ---------------------------------------------------------------------------------------------
# Macros

# empty modules (specifying I/O)
set ::env(VERILOG_FILES_BLACKBOX) "$script_dir/../../verilog/rtl/wrapper/wrapper_custom_16x12.v"

# custom 16x12 subarray
set ::env(EXTRA_LEFS) "$script_dir/../../macros/10T_16x12_2r1w_magic_flattened.lef"
set ::env(EXTRA_GDS_FILES) "$script_dir/../../macros/10T_16x12_2r1w_magic_flattened.gds"
#set ::env(EXTRA_LIBS) [glob $::env(DESIGN_DIR)/../../macros/DFFRAM/lib/*.lib]

# instantiated macro names
#set ::env(FP_PDN_MACRO_HOOKS) "\
#	RegFilePlugin_regFile.gpr.rf 	vccd1 vssd1 \
#	IBusCachedPlugin_cache 	vccd1 vssd1 \
#   dataCache_1_ vccd1 vssd1 \
#   "

# placement coords for all macros
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

# ---------------------------------------------------------------------------------------------

set ::env(DESIGN_IS_CORE) 0

set ::env(CLOCK_PORT) ""
#set ::env(CLOCK_PORT) "clk"
#set ::env(CLOCK_NET) "clk"
#set ::env(CLOCK_PERIOD) "10"

set ::env(DIE_AREA) "0 0 200 200"

#wtf add this
#set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

# Maximum layer used for routing is metal 4.
# This is because this macro will be inserted in a top level (user_project_wrapper)
# where the PDN is planned on metal 5. So, to avoid having shorts between routes
# in this macro and the top level metal 5 stripes, we have to restrict routes to metal4.
#
set ::env(RT_MAX_LAYER) {met4}

# You can draw more power domains if you need to
set ::env(VDD_NETS) [list {VDD}]
set ::env(GND_NETS) [list {GND}]

set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(RUN_CVC) 1

## Synthesis
#set ::env(SYNTH_STRATEGY) {DELAY 4}
#set ::env(SYNTH_MAX_FANOUT) 16
#set ::env(STA_REPORT_POWER) 0

## Floorplan

# Floor plan tuning
#set ::env(FP_TAP_HORIZONTAL_HALO) 40
#set ::env(FP_PDN_HORIZONTAL_HALO) 40
#set ::env(FP_TAP_VERTICAL_HALO) 10
#set ::env(FP_PDN_VERTICAL_HALO) 10

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(FP_SIZING) absolute
#

## PDN
#set ::env(FP_PDN_CORE_RING) 1
#set ::env(FP_PDN_VPITCH) 50
#set ::env(FP_PDN_HPITCH) 130

#set ::env(FP_PDN_VWIDTH) 1.6
#set ::env(FP_PDN_CORE_RING_VWIDTH) 1.6

## CTS
#set ::env(CTS_CLK_BUFFER_LIST) "sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_16"
#set ::env(CTS_SINK_CLUSTERING_MAX_DIAMETER) 50
#set ::env(CTS_SINK_CLUSTERING_SIZE) 20
#set ::env(CTS_DISABLE_POST_PROCESSING) 1
#set ::env(CTS_SINK_CLUSTERING_MAX_DIAMETER) 200
#set ::env(CTS_DISTANCE_BETWEEN_BUFFERS) 1000

## Placement
#set ::env(PL_BASIC_PLACEMENT) 0
#set ::env(PL_TARGET_DENSITY) 0.50

#set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
#set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0

#set ::env(FP_CORE_UTIL) 30
#set ::env(CELL_PAD) 2

#set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) "0.3"
#set ::env(PL_RESIZER_MAX_SLEW_MARGIN) 2
#set ::env(PL_RESIZER_MAX_CAP_MARGIN) 2

## Routing
#set ::env(GLB_RT_ALLOW_CONGESTION) 0
#set ::env(GLB_RT_OVERFLOW_ITERS) 1000
#set ::env(GLB_RT_ADJUSTMENT) 0.2

#set ::env(GLB_RT_MINLAYER) 2
#set ::env(GLB_RT_MAXLAYER) 6

#set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) 0.15
#set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 0
#set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) 0.3
