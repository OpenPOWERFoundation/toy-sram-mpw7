// © IBM Corp. 2022
// Licensed under the Apache License, Version 2.0 (the "License"), as modified by the terms below; you may not use the files in this
// repository except in compliance with the License as modified.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Modified Terms:
//
//   1)	For the purpose of the patent license granted to you in Section 3 of the License, the "Work" hereby includes implementations of
//   the work of authorship in physical form.
//
// Unless required by applicable law or agreed to in writing, the reference design distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language
// governing permissions and limitations under the License.
//
// Brief explanation of modifications:
//
// Modification 1: This modification extends the patent license to an implementation of the Work in physical form – i.e.,
// it unambiguously permits a user to make and use the physical chip.

// Wrapper for real 16x12 toysram subarray
// custom_16x12: non-vector ins/outs
// toysram_16x12: vector ins/outs
// Array cells only; does not include read eval circuit.

`timescale 1 ps / 1 ps

module toysram_16x12 (

   inout             VDD,
   inout             GND,
   input  [0:15]     RWL0,
   input  [0:15]     RWL1,
   input  [0:15]     WWL,
   output [0:11]     RBL0,
   output [0:11]     RBL1,
   input  [0:11]     WBL,
   input  [0:11]     WBLb

);

//toysram_custom_16x12 ra (
c_10T_16x12_2r1w_magic_flattened ra (

   .VDD(VDD),
   .GND(GND),
   .RWL0_0(RWL0[0]),
   .RWL0_1(RWL0[1]),
   .RWL0_2(RWL0[2]),
   .RWL0_3(RWL0[3]),
   .RWL0_4(RWL0[4]),
   .RWL0_5(RWL0[5]),
   .RWL0_6(RWL0[6]),
   .RWL0_7(RWL0[7]),
   .RWL0_8(RWL0[8]),
   .RWL0_9(RWL0[9]),
   .RWL0_10(RWL0[10]),
   .RWL0_11(RWL0[11]),
   .RWL0_12(RWL0[12]),
   .RWL0_13(RWL0[13]),
   .RWL0_14(RWL0[14]),
   .RWL0_15(RWL0[15]),
   .RWL1_0(RWL1[0]),
   .RWL1_1(RWL1[1]),
   .RWL1_2(RWL1[2]),
   .RWL1_3(RWL1[3]),
   .RWL1_4(RWL1[4]),
   .RWL1_5(RWL1[5]),
   .RWL1_6(RWL1[6]),
   .RWL1_7(RWL1[7]),
   .RWL1_8(RWL1[8]),
   .RWL1_9(RWL1[9]),
   .RWL1_10(RWL1[10]),
   .RWL1_11(RWL1[11]),
   .RWL1_12(RWL1[12]),
   .RWL1_13(RWL1[13]),
   .RWL1_14(RWL1[14]),
   .RWL1_15(RWL1[15]),
   .WWL_0(RWL0[0]),
   .WWL_1(RWL0[1]),
   .WWL_2(RWL0[2]),
   .WWL_3(RWL0[3]),
   .WWL_4(RWL0[4]),
   .WWL_5(RWL0[5]),
   .WWL_6(RWL0[6]),
   .WWL_7(RWL0[7]),
   .WWL_8(RWL0[8]),
   .WWL_9(RWL0[9]),
   .WWL_10(RWL0[10]),
   .WWL_11(RWL0[11]),
   .WWL_12(RWL0[12]),
   .WWL_13(RWL0[13]),
   .WWL_14(RWL0[14]),
   .WWL_15(RWL0[15]),
   .RBL0_0(RBL0[0]),
   .RBL0_1(RBL0[1]),
   .RBL0_2(RBL0[2]),
   .RBL0_3(RBL0[3]),
   .RBL0_4(RBL0[4]),
   .RBL0_5(RBL0[5]),
   .RBL0_6(RBL0[6]),
   .RBL0_7(RBL0[7]),
   .RBL0_8(RBL0[8]),
   .RBL0_9(RBL0[9]),
   .RBL0_10(RBL0[10]),
   .RBL0_11(RBL0[11]),
   .RBL1_0(RBL1[0]),
   .RBL1_1(RBL1[1]),
   .RBL1_2(RBL1[2]),
   .RBL1_3(RBL1[3]),
   .RBL1_4(RBL1[4]),
   .RBL1_5(RBL1[5]),
   .RBL1_6(RBL1[6]),
   .RBL1_7(RBL1[7]),
   .RBL1_8(RBL1[8]),
   .RBL1_9(RBL1[9]),
   .RBL1_10(RBL1[10]),
   .RBL1_11(RBL1[11]),
   .WBL_0(WBL[0]),
   .WBL_1(WBL[1]),
   .WBL_2(WBL[2]),
   .WBL_3(WBL[3]),
   .WBL_4(WBL[4]),
   .WBL_5(WBL[5]),
   .WBL_6(WBL[6]),
   .WBL_7(WBL[7]),
   .WBL_8(WBL[8]),
   .WBL_9(WBL[9]),
   .WBL_10(WBL[10]),
   .WBL_11(WBL[11]),
   .WBLb_0(WBLb[0]),
   .WBLb_1(WBLb[1]),
   .WBLb_2(WBLb[2]),
   .WBLb_3(WBLb[3]),
   .WBLb_4(WBLb[4]),
   .WBLb_5(WBLb[5]),
   .WBLb_6(WBLb[6]),
   .WBLb_7(WBLb[7]),
   .WBLb_8(WBLb[8]),
   .WBLb_9(WBLb[9]),
   .WBLb_10(WBLb[10]),
   .WBLb_11(WBLb[11])

);

endmodule