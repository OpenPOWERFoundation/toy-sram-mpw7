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

set ::env(PDK) $::env(PDK)
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) toysram_site

# ---------------------------------------------------------------------------------------------
# Site

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/site/toysram_site.v \
	$script_dir/../../verilog/rtl/site/cfg.v \
	$script_dir/../../verilog/rtl/site/control.v \
	$script_dir/../../verilog/rtl/site/io_intf.v \
	$script_dir/../../verilog/rtl/site/misc.v \
	$script_dir/../../verilog/rtl/site/wb_slave.v \
	$script_dir/../../verilog/rtl/array/test_ra_sdr_32x32.v \
	$script_dir/../../verilog/rtl/array/ra_bist_sdr_32x32.v \
	$script_dir/../../verilog/rtl/array/ra_cfg_sdr.v \
	$script_dir/../../verilog/rtl/array/ra_delay.v \
	$script_dir/../../verilog/rtl/array/ra_lcb_sdr.v \
	$script_dir/../../verilog/rtl/array/ra_2r1w_32x32_sdr.v \
	$script_dir/../../verilog/rtl/array/address_clock_sdr_2r1w_32.v \
	$script_dir/../../verilog/rtl/array/predecode_sdr_32.v \
	$script_dir/../../verilog/rtl/array/regfile_2r1w_32x32.v \
   "

# ---------------------------------------------------------------------------------------------
# Macros (array)
#

#wtf how to set this in shell? actually should parse grep/cut it:
# grep "\b`define RA_SELECT"
#    also change RA_SELECT in toysram.vh
set ::env(RA_SELECT) 2

if {![info exists ::env(RA_SELECT)] || ($::env(RA_SELECT) == 0) } {

   puts "Generating simulation version..."

} elseif {$::env(RA_SELECT) == 1} {

   puts "Generating DFFRAM version..."

   # empty modules (specifying I/O)
   set ::env(VERILOG_FILES_BLACKBOX) "\
	   $script_dir/../../verilog/rtl/DFFRAM/wrapper/DFFRF_2R1W.v \
      "
   # generated lef, gds, lib
   set ::env(EXTRA_LEFS) [glob $::env(DESIGN_DIR)/../../macros/DFFRAM/lef/*.lef]
   set ::env(EXTRA_GDS_FILES) [glob $::env(DESIGN_DIR)/../../macros/DFFRAM/gds/*.gds]
   #set ::env(EXTRA_LIBS) [glob $::env(DESIGN_DIR)/../../macros/DFFRAM/lib/*.lib]

   # instantiated macro names
   #set ::env(FP_PDN_MACRO_HOOKS) "\
	#   ra_0.ra.array0.genblk1.mem vccd1 vssd1
   #   "
   # placement coords for all macros
   #set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

}  elseif {$::env(RA_SELECT) == 2} {

   puts "Generating toysram array version..."

   # empty modules (specifying I/O)
   set ::env(VERILOG_FILES_BLACKBOX) "\
	   $script_dir/../../verilog/rtl/toysram/wrapper/10T_32x32_magic_flattened.v \
      "
   # generated lef, gds, lib
   set ::env(EXTRA_LEFS) [glob $::env(DESIGN_DIR)/../../macros/toysram/lef/*.lef]
   set ::env(EXTRA_GDS_FILES) [glob $::env(DESIGN_DIR)/../../macros/toysram/gds/*.gds]
   #set ::env(EXTRA_LIBS) [glob $::env(DESIGN_DIR)/../../macros/toysram/lib/*.lib]

   # instantiated macro names
   #set ::env(FP_PDN_MACRO_HOOKS) "\
	#  ra_0.genblk1.ra vccd1 vssd1 \
   #   "
   # placement coords for all macros
   set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

}  elseif {$::env(RA_SELECT) == 3} {

   puts "Generating toysram bare array version..."

   # empty modules (specifying I/O)
   set ::env(VERILOG_FILES_BLACKBOX) "\
	   $script_dir/../../verilog/rtl/toysram/wrapper/10T_32x32_magic.v \
      "
   # generated lef, gds, lib
   set ::env(EXTRA_LEFS) [glob $::env(DESIGN_DIR)/../../macros/toysram/lef/*.lef]
   set ::env(EXTRA_GDS_FILES) [glob $::env(DESIGN_DIR)/../../macros/toysram/gds/*.gds]
   #set ::env(EXTRA_LIBS) [glob $::env(DESIGN_DIR)/../../macros/toysram/lib/*.lib]

   # instantiated macro names
   #set ::env(FP_PDN_MACRO_HOOKS) "\
	#  ra_0.ra.array0.genblk1.mem vccd1 vssd1
   #   "
   # placement coords for all macros
   #set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

} else {

   puts "Bad RA_SELECT value."
   exit -1
}


# ---------------------------------------------------------------------------------------------

set ::env(DESIGN_IS_CORE) 0

set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_NET) "wb_clk_i"
set ::env(CLOCK_PERIOD) "10"

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 1500 1500"

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(PL_BASIC_PLACEMENT) 0
set ::env(PL_TARGET_DENSITY) 0.50

# Maximum layer used for routing is metal 4.
# This is because this macro will be inserted in a top level (user_project_wrapper)
# where the PDN is planned on metal 5. So, to avoid having shorts between routes
# in this macro and the top level metal 5 stripes, we have to restrict routes to metal4.
#
set ::env(RT_MAX_LAYER) {met4}

# You can draw more power domains if you need to
set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]

set ::env(DIODE_INSERTION_STRATEGY) 4
# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1
