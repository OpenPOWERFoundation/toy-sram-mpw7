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

void main()
{
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

   /* toysram site I/Os
   # control.v
   test_enable = dut.io_in[0];
   scan_clk = dut.io_in[1];
   scan_di = dut.io_in[2];
   scan_do = dut.io_out[3]

   io_ra0_clk = dut.io_in[4];
   io_ra0_rst = dut.io_in[5];
   io_ra0_r0_enb = dut.io_in[6];
   io_ra0_r1_enb = dut.io_in[7];
   io_ra0_w0_enb = dut.io_in[8];
   */

	reg_mprj_io_0 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // test_enable
	reg_mprj_io_1 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // scan_clk
	reg_mprj_io_2 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // scan_di
	reg_mprj_io_3 = GPIO_MODE_USER_STD_OUTPUT;            // scan_do
	reg_mprj_io_4 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_clk
	reg_mprj_io_5 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_rst
	reg_mprj_io_6 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_r0_enb
	reg_mprj_io_7 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_r1_enb
	reg_mprj_io_8 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;    // io_ra0_w0_enb

   // *******************************************************************************
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);

}

