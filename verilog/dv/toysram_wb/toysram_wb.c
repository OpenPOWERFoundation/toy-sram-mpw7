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
// MISC
#define PIN_RUNMODE 31
#define PIN_ERROR   30
#define PIN_USER_0  29
#define PIN_USER_1  28

// current mgmt core restricts slave offsets to < 0x00100000!!!
#define SLAVE_ADDR 0x30000000

#define CTL_ADDR 0x00000000
#define CFG0_OFFSET 0x00000000   // 0:write 4:set 8:rst C:toggle

#define RA0_ADDR 0x00080000
#define BIST_OFFSET 0x0000F000
#define CFG_OFFSET 0x0000E000

#define WRITE 0
#define SET 1
#define RESET 2
#define TOGGLE 3
void writeCfg0(unsigned int v, unsigned int mode);

void writeCfg0(unsigned int v, unsigned int mode) {
   unsigned int addr = SLAVE_ADDR + CTL_ADDR + CFG0_OFFSET + mode*4;
   (*(volatile uint32_t*)(addr)) = v;
}

void main() {

   unsigned int i, addr, data, rangeLo, rangeHi;
   bool ok = true;

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

	reg_mprj_io_8 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;     // test_enable
	reg_mprj_io_9 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;     // scan_clk
	reg_mprj_io_10 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // scan_di
	reg_mprj_io_11 = GPIO_MODE_USER_STD_OUTPUT;            // scan_do
	reg_mprj_io_12 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_clk
	reg_mprj_io_13 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_rst
	reg_mprj_io_14 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_r0_enb
	reg_mprj_io_15 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_r1_enb
	reg_mprj_io_16 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_w0_enb
	reg_mprj_io_28 = GPIO_MODE_USER_STD_OUTPUT;            // u0
	reg_mprj_io_29 = GPIO_MODE_USER_STD_OUTPUT;            // u1
	reg_mprj_io_30 = GPIO_MODE_USER_STD_OUTPUT;            // error
	reg_mprj_io_31 = GPIO_MODE_USER_STD_OUTPUT;            // run

   // *******************************************************************************
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);

   // *******************************************************************************
   // try some array testing until it barfs

   reg_wb_enable = 1;                  // enable user->mgmt wb access

   writeCfg0(0x80000001, WRITE);       // set run, rd wait=1

   addr = SLAVE_ADDR + RA0_ADDR;
   data = 0x00000000;

   // array addresses are 6:2 to avoid byte wonkiness for alignment/bus

   rangeLo = 0;
   rangeHi = 31;

   writeCfg0(0x10000000, SET);         // set u=1

   // write all
   for (i = rangeLo; i <= rangeHi; i++) {
      (*(volatile uint32_t*)(addr + i*4)) = data + i + 1;
   }

   writeCfg0(0x30000000, TOGGLE);      // set u=2

   // read all
   for (i = rangeLo; i <= rangeHi; i++) {
      if (*(volatile uint32_t*)(addr + i*4) != data + i + 1) {
         ok = false;
         break;
      }
   }

   if (ok) {
      writeCfg0(0x10000000, SET);      // set u=3
      data = 0x00FFFFFF;

      // write, read same
      for (i = rangeLo; i <= rangeHi; i++) {
         (*(volatile uint32_t*)(addr + i*4)) = (data + i + 1) << 24;
         if (*(volatile uint32_t*)(addr + i*4) != ((data + i + 1) << 24)) {
            ok = false;
            break;
         }
      }
   }

   if (ok) {
      writeCfg0(0x80000000, RESET);    // you has opulence
   } else {
      writeCfg0(0x40000000, SET);      // you are worthless and weak!
   }

}

