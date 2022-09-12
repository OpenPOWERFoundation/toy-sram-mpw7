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
   Test VexRiscv <-> toysram site.
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
unsigned int readCfg0(void);
void fail(void);

void writeCfg0(unsigned int v, unsigned int mode) {
   unsigned int addr = SLAVE_ADDR + CTL_ADDR + CFG0_OFFSET + mode*4;
   (*(volatile uint32_t*)(addr)) = v;
}

unsigned int readCfg0(void) {
   unsigned int addr = SLAVE_ADDR + CTL_ADDR + CFG0_OFFSET;
   return *(volatile uint32_t*)(addr);
}

void fail(void) {
   writeCfg0(0x40000000, SET);      // you are worthless and weak!
   while(true) {}
}

#define R0(r) (r<<2)
#define W0(r) (r<<2)
#define R1(r) (r<<8)
#define READ_R0 (0 << 14)
#define READ_R1 (1 << 14)
#define READ_R0_R1_LO (2 << 14)
#define READ_R0_R1_HI (3 << 14)

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

   reg_wb_enable = 1;                  // enable user->mgmt wb access

   // play with cfg0

   // for automated testing, need a better way to detect fail in sim, since mistakenly turning
   //  off run mode will end sim successfully!  could have defined sequence of user bit settings to check

   data = 0xB0000001;
   writeCfg0(data, WRITE);             // set run, user=3, rd wait=1
   if (readCfg0() != data) {
      fail();
   };

   data = 0xA0000001;
   writeCfg0(0x10000000, RESET);       // reset u0
   if (readCfg0() != data) {
      fail();
   };

   data = 0x90000001;
   writeCfg0(0x30000000, TOGGLE);     // toggle u0,u1
   if (readCfg0() != data) {
      fail();
   };

   data = 0xB0000001;
   writeCfg0(0x20000000, TOGGLE);     // set u1
   if (readCfg0() != data) {
      fail();
   };

   // try special array read addressing modes
   // array can be read four ways using one or both read ports:
   //   00: R0
   //   01: R1
   //   10: R1[15:0]  || R0[15:0]
   //   11: R1[31:16] || R0[31:16]
   //
   // addr[15:0] = SEL || 0 || R1A || 0 || R0A || 00

   addr = SLAVE_ADDR + RA0_ADDR;

   writeCfg0(0x30000000, RESET);         // set u=0

   // set up some regs
   (*(volatile uint32_t*)(addr + W0(1)))  = 0xAAAA5555;
   (*(volatile uint32_t*)(addr + W0(6)))  = 0x5555AAAA;
   (*(volatile uint32_t*)(addr + W0(14))) = 0xCCCC3333;
   (*(volatile uint32_t*)(addr + W0(31))) = 0x3333CCCC;

   // read with R0
   if (*(volatile uint32_t*)(addr + READ_R0 + R0(1)) != 0xAAAA5555) {
      fail();
   }
   if (*(volatile uint32_t*)(addr + READ_R0 + R0(6)) != 0x5555AAAA) {
      fail();
   }
   if (*(volatile uint32_t*)(addr + READ_R0 + R0(14)) != 0xCCCC3333) {
      fail();
   }
   if (*(volatile uint32_t*)(addr + READ_R0 + R0(31)) != 0x3333CCCC) {
      fail();
   }

   // read with R1
   writeCfg0(0x10000000, SET);        // set u=1

   if (*(volatile uint32_t*)(addr + READ_R1 + R1(1)) != 0xAAAA5555) {
      fail();
   }
   if (*(volatile uint32_t*)(addr + READ_R1 + R1(6)) != 0x5555AAAA) {
      fail();
   }
   if (*(volatile uint32_t*)(addr + READ_R1 + R1(14)) != 0xCCCC3333) {
      fail();
   }
   if (*(volatile uint32_t*)(addr + READ_R1 + R1(31)) != 0x3333CCCC) {
      fail();
   }

   // read lo with R0/R1
   writeCfg0(0x30000000, TOGGLE);      // set u=2

   if (*(volatile uint32_t*)(addr + READ_R0_R1_LO + R1(14) + R0(1)) != 0x33335555) {
      fail();
   }
   if (*(volatile uint32_t*)(addr + READ_R0_R1_LO + R1(6) + R0(31)) != 0xAAAACCCC) {
      fail();
   }
   if (*(volatile uint32_t*)(addr + READ_R0_R1_LO + R1(1) + R0(14)) != 0x55553333) {
      fail();
   }
   if (*(volatile uint32_t*)(addr + READ_R0_R1_LO + R1(31) + R0(6)) != 0xCCCCAAAA) {
      fail();
   }

   // read hi with R0/R1
   writeCfg0(0x30000000, SET);         // set u=3

   if (*(volatile uint32_t*)(addr + READ_R0_R1_HI + R1(14) + R0(6)) != 0xCCCC5555) {
      fail();
   }
   if (*(volatile uint32_t*)(addr + READ_R0_R1_HI + R1(31) + R0(1)) != 0x3333AAAA) {
      fail();
   }
   if (*(volatile uint32_t*)(addr + READ_R0_R1_HI + R1(6) + R0(14)) != 0x5555CCCC) {
      fail();
   }
   if (*(volatile uint32_t*)(addr + READ_R0_R1_HI + R1(1) + R0(31)) != 0xAAAA3333) {
      fail();
   }

   writeCfg0(0x80000000, RESET);       // you has opulence

}

