/*
 * SPDX-FileCopyrightText: 2020 Efabless Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 */

/*
   Set up toysram site I/O.
*/

// This include is relative to $CARAVEL_PATH (see Makefile)
#include <defs.h>
#include <stub.c>

void main() {

   unsigned int i, addr, data;

	/*
	IO Control Registers
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 3-bits | 1-bit | 1-bit | 1-bit  | 1-bit  | 1-bit | 1-bit   | 1-bit   | 1-bit | 1-bit | 1-bit   |

	Output: 0000_0110_0000_1110  (0x1808) = GPIO_MODE_USER_STD_OUTPUT
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 110    | 0     | 0     | 0      | 0      | 0     | 0       | 1       | 0     | 0     | 0       |


	Input: 0000_0001_0000_1111 (0x0402) = GPIO_MODE_USER_STD_INPUT_NOPULL
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 001    | 0     | 0     | 0      | 0      | 0     | 0       | 0       | 0     | 1     | 0       |

	*/

	/* Set up the housekeeping SPI to be connected internally so	*/
	/* that external pin changes don't affect it.			*/

	// reg_spi_enable = 1;
	// reg_spimaster_cs = 0x10001;
	// reg_spimaster_control = 0x0801;

	// reg_spimaster_control = 0xa002;	// Enable, prescaler = 2,
                                       // connect to housekeeping SPI

	// Connect the housekeeping SPI to the SPI master
	// so that the CSB line is not left floating.  This allows
	// all of the GPIO pins to be used for user functions.


   // *******************************************************************************
	// Configure I/Os

#define PIN_TE 8
// Scan
#define PIN_SCAN_CLK 9
#define PIN_SCAN_IN 10
#define PIN_SCAN_OUT 11
// RA0
#define PIN_RA0_CLK 12
#define PIN_RA0_RST 13
#define PIN_RA0_R0_EN 14
#define PIN_RA0_R1_EN 15
#define PIN_RA0_W0_EN 16

	reg_mprj_io_8 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;     // test_enable
	reg_mprj_io_9 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;     // scan_clk
	reg_mprj_io_10 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // scan_di
	reg_mprj_io_11 = GPIO_MODE_USER_STD_OUTPUT;            // scan_do
	reg_mprj_io_12 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_clk
	reg_mprj_io_13 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_rst
	reg_mprj_io_14 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_r0_enb
	reg_mprj_io_15 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_r1_enb
	reg_mprj_io_16 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_w0_enb

   // *******************************************************************************
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);

   // *******************************************************************************
   // do some array testing until it barfs

   // how does vrv talk to io?  gpio? mprj_io?? need output enable??
   // run light, error

   reg_wb_enable = -1;
   // why aren't the addr space values constants????
   // #define reg_mprj_slave (*(volatile uint32_t*)0x30000000)
   /*
   parameter CFG_ADDR =  'h00000000,
   parameter CTL_ADDR =  'h00010000,
   parameter RA0_ADDR =  'h00080000
   */
   addr = 0x30000000 + 0x00080000;
   data = 0x00000000;

   // array addresses are 6:2 to avoid byte wonkiness
   // write,read same
   for (i = 0; i < 32; i++) {
      (*(volatile uint32_t*)(addr + i*4)) = data + i + 1;
      if (*(volatile uint32_t*)(addr + i*4) != data + i + 1) {
         while(true) {}
      }
   }

   for (i = 0; i < 32; i++) {
      if (*(volatile uint32_t*)(addr + i*4) != data + i + 1) {
         while(true) {}
      }
   }

}

