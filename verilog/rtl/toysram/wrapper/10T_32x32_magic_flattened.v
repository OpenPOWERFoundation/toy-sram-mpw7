/*
grep *.lef to find what the osuboys did to the i/o's!  and what is this array????

  PIN RBL1_0
  PIN RBL0_0
  PIN RBL1_1
  PIN RBL0_1
  PIN RBL1_2
  PIN RBL0_2
  PIN RBL1_3
  PIN RBL0_3
  PIN RBL1_4
  PIN RBL0_4
  PIN RBL1_5
  PIN RBL0_5
  PIN RBL1_6
  PIN RBL0_6
  PIN RBL1_7
  PIN RBL0_7
  PIN RBL1_8
  PIN RBL0_8
  PIN RBL1_9
  PIN RBL0_9
  PIN RBL1_10
  PIN RBL0_10
  PIN RBL1_11
  PIN RBL0_11
  PIN RBL1_12
  PIN RBL0_12
  PIN RBL1_13
  PIN RBL0_13
  PIN RBL1_14
  PIN RBL0_14
  PIN RBL1_15
  PIN RBL0_15
  PIN RWL_0
  PIN RWL_1
  PIN RWL_2
  PIN RWL_3
  PIN RWL_4
  PIN RWL_5
  PIN RWL_6
  PIN RWL_7
  PIN RWL_8
  PIN RWL_9
  PIN RWL_10
  PIN RWL_11
  PIN RWL_12
  PIN RWL_13
  PIN RWL_14
  PIN RWL_15
  PIN RWL_16
  PIN RWL_17
  PIN RWL_18
  PIN RWL_19
  PIN RWL_20
  PIN RWL_21
  PIN RWL_22
  PIN RWL_23
  PIN RWL_24
  PIN RWL_25
  PIN RWL_26
  PIN RWL_27
  PIN RWL_28
  PIN RWL_29
  PIN RWL_30
  PIN RWL_31
  PIN RBL1_16
  PIN RBL0_16
  PIN RBL1_17
  PIN RBL0_17
  PIN RBL1_18
  PIN RBL0_18
  PIN RBL1_19
  PIN RBL0_19
  PIN RBL1_20
  PIN RBL0_20
  PIN RBL1_21
  PIN RBL0_21
  PIN RBL1_22
  PIN RBL0_22
  PIN RBL1_23
  PIN RBL0_23
  PIN RBL1_24
  PIN RBL0_24
  PIN RBL1_25
  PIN RBL0_25
  PIN RBL1_26
  PIN RBL0_26
  PIN RBL1_27
  PIN RBL0_27
  PIN RBL1_28
  PIN RBL0_28
  PIN RBL1_29
  PIN RBL0_29
  PIN RBL1_30
  PIN RBL0_30
  PIN RBL1_31
  PIN RBL0_31
  PIN WBL_16
  PIN WBLb_16
  PIN WBL_17
  PIN WBLb_17
  PIN WBL_18
  PIN WBLb_18
  PIN WBL_19
  PIN WBLb_19
  PIN WBL_20
  PIN WBLb_20
  PIN WBL_21
  PIN WBLb_21
  PIN WBL_22
  PIN WBLb_22
  PIN WBL_23
  PIN WBLb_23
  PIN WBL_8
  PIN WBLb_8
  PIN WBL_9
  PIN WBLb_9
  PIN WBL_10
  PIN WBLb_10
  PIN WBL_11
  PIN WBLb_11
  PIN WBL_12
  PIN WBLb_12
  PIN WBL_13
  PIN WBLb_13
  PIN WBL_14
  PIN WBLb_14
  PIN WBL_15
  PIN WBLb_15
  PIN VDD
  PIN GND

*/

module \10T_32x32_magic_flattened (
   input VDD, GND,
   //output [31:0] RBL0,
   //output RBL0_0,    // [ERROR DRT-0073] No access point for ra_0.genblk1.ra/RBL0_0.
   //output [31:0] RBL1,
   //output RBL1_31,  // [ERROR DRT-0073] No access point for ra_0.genblk1.ra/RBL1_0.
   //input  [31:0] RWL,
   //input  RWL_0,
   //input  [23:8] WBL,
   //input  WBL_0,
   //input  [23:8] WBLb
   //input  WBLb_0
// wtf bad port name not an error until vsc check
//  and need an output or it gets synth'd away!!!!!!
   input clk,
   output [31:0] rd_dat_0
);
endmodule
