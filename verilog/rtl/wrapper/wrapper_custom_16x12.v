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

//module toysram_custom_16x12 (
module c_10T_16x12_2r1w_magic_flattened (

   inout  VDD,
   inout  GND,
   input  RWL0_0,
   input  RWL0_1,
   input  RWL0_2,
   input  RWL0_3,
   input  RWL0_4,
   input  RWL0_5,
   input  RWL0_6,
   input  RWL0_7,
   input  RWL0_8,
   input  RWL0_9,
   input  RWL0_10,
   input  RWL0_11,
   input  RWL0_12,
   input  RWL0_13,
   input  RWL0_14,
   input  RWL0_15,
   input  RWL1_0,
   input  RWL1_1,
   input  RWL1_2,
   input  RWL1_3,
   input  RWL1_4,
   input  RWL1_5,
   input  RWL1_6,
   input  RWL1_7,
   input  RWL1_8,
   input  RWL1_9,
   input  RWL1_10,
   input  RWL1_11,
   input  RWL1_12,
   input  RWL1_13,
   input  RWL1_14,
   input  RWL1_15,
   input  WWL_0,
   input  WWL_1,
   input  WWL_2,
   input  WWL_3,
   input  WWL_4,
   input  WWL_5,
   input  WWL_6,
   input  WWL_7,
   input  WWL_8,
   input  WWL_9,
   input  WWL_10,
   input  WWL_11,
   input  WWL_12,
   input  WWL_13,
   input  WWL_14,
   input  WWL_15,
   output RBL0_0,
   output RBL0_1,
   output RBL0_2,
   output RBL0_3,
   output RBL0_4,
   output RBL0_5,
   output RBL0_6,
   output RBL0_7,
   output RBL0_8,
   output RBL0_9,
   output RBL0_10,
   output RBL0_11,
   output RBL1_0,
   output RBL1_1,
   output RBL1_2,
   output RBL1_3,
   output RBL1_4,
   output RBL1_5,
   output RBL1_6,
   output RBL1_7,
   output RBL1_8,
   output RBL1_9,
   output RBL1_10,
   output RBL1_11,
   input  WBL_0,
   input  WBLb_0,
   input  WBL_1,
   input  WBLb_1,
   input  WBL_2,
   input  WBLb_2,
   input  WBL_3,
   input  WBLb_3,
   input  WBL_4,
   input  WBLb_4,
   input  WBL_5,
   input  WBLb_5,
   input  WBL_6,
   input  WBLb_6,
   input  WBL_7,
   input  WBLb_7,
   input  WBL_8,
   input  WBLb_8,
   input  WBL_9,
   input  WBLb_9,
   input  WBL_10,
   input  WBLb_10,
   input  WBL_11,
   input  WBLb_11

);

endmodule
