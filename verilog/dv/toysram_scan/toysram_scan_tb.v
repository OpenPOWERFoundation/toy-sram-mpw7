// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

// Test
`define PIN_TE 8
// Scan
`define PIN_SCAN_CLK 9
`define PIN_SCAN_IN 10
`define PIN_SCAN_OUT 11
// RA0
`define PIN_RA0_CLK 12
`define PIN_RA0_RST 13
`define PIN_RA0_R0_EN 14
`define PIN_RA0_R1_EN 15
`define PIN_RA0_W0_EN 16

module toysram_scan_tb;

	reg clock;
	reg RSTB;
	reg CSB;
	reg power1, power2;
	reg power3, power4;

	wire gpio;
	wire [37:0] mprj_io;

   //?
	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;

   // *********************************************************************************
   // driver connections
   wire debug = 1;
   reg pin_te, pin_scan_clk, pin_scan_in, pin_scan_out;
   reg pin_ra0_clk, pin_ra0_rst, pin_ra0_r0_en, pin_ra0_r1_en, pin_ra0_w0_en;

   // drive
   assign mprj_io[`PIN_TE] = pin_te;
   assign mprj_io[`PIN_SCAN_CLK] = pin_scan_clk;
   assign mprj_io[`PIN_SCAN_IN] = pin_scan_in;
   assign mprj_io[`PIN_RA0_CLK] = pin_ra0_clk;
   assign mprj_io[`PIN_RA0_RST] = pin_ra0_rst;
   assign mprj_io[`PIN_RA0_R0_EN] = pin_ra0_r0_en;
   assign mprj_io[`PIN_RA0_R1_EN] = pin_ra0_r1_en;
   assign mprj_io[`PIN_RA0_W0_EN] = pin_ra0_w0_en;

   // sample
   always @(*) begin
      pin_scan_out <= mprj_io[`PIN_SCAN_OUT];
   end

   // *********************************************************************************
   // clocks

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #12.5 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

   // *********************************************************************************
   // setup

	initial begin
		$dumpfile("toysram_scan.vcd");
		$dumpvars(0, toysram_scan_tb);
      $display("\n\n");

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (25) begin
			repeat (1000) @(posedge clock);
			$display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		`ifdef GL
			$display ("*ERROR* Timeout, Test Mega-Project IO Ports (GL) Failed");
		`else
			$display ("*ERROR* Timeout, Test Mega-Project IO Ports (RTL) Failed");
		`endif
		$display("%c[0m",27);
		$finish;
	end

   // *********************************************************************************
   // reset

	initial begin

		RSTB <= 1'b0;
		CSB  <= 1'b1;		// Force CSB high

		#2000;
      $display("Releasing reset.");
		RSTB <= 1'b1;	    	// Release reset

		#3_00_000;
		CSB = 1'b0;		// CSB can be released
	end

   // *********************************************************************************
   // power up

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		power2 <= 1'b0;
		power3 <= 1'b0;
		power4 <= 1'b0;
		#100;
		power1 <= 1'b1;
		#100;
		power2 <= 1'b1;
		#100;
		power3 <= 1'b1;
		#100;
		power4 <= 1'b1;
	end

   // *********************************************************************************
   // monitors

	always @(mprj_io) begin
      if (debug) begin
		   #1 $display("   MPRJ-IO TE    %b ", mprj_io[`PIN_TE]);
		   #1 $display("   MPRJ-IO SCAN  %b ", {mprj_io[`PIN_SCAN_CLK], mprj_io[`PIN_SCAN_IN], mprj_io[`PIN_SCAN_OUT]});
		   #1 $display("   MPRJ-IO RA0   %b ", {mprj_io[`PIN_RA0_CLK], mprj_io[`PIN_RA0_RST], mprj_io[`PIN_RA0_R0_EN], mprj_io[`PIN_RA0_R1_EN], mprj_io[`PIN_RA0_W0_EN]});
      end
	end

   initial begin
        wait(mprj_io[`PIN_TE] == 1'b1);
        $display("Test Enable is active.");
        wait(mprj_io[`PIN_TE] == 1'b0);
        $display("Test Enable is disabled.  Test complete.");
        #1000;
        $finish;
   end

   // *********************************************************************************
   // test

   initial begin

      pin_te <= 1'b0;
      pin_scan_clk <= 1'b0;
      pin_scan_in <= 1'b0;
      pin_ra0_clk <= 1'b0;
      pin_ra0_rst <= 1'b0;
      pin_ra0_r0_en <= 1'b0;
      pin_ra0_r1_en <= 1'b0;
      pin_ra0_w0_en <= 1'b0;
      wait(RSTB == 1'b1);

      #500;
      $display("Checking scanout.");
      if (pin_scan_out !== 1'b0) begin
   		$display("%c[1;31m",27);
         $display("*ERROR* Scanout is not 0.");
   		$display("%c[0m",27);
	   	$finish;
      end
      $display("Setting Test Enable.");
      pin_te <= 1'b1;

      #1000;
      pin_te <= 1'b0;

   end

   // *********************************************************************************
   // hook stuff up
	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD3V3;
	wire VDD1V8;
	wire VSS;

	assign VDD3V3 = power1;
	assign VDD1V8 = power2;
	assign VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vddio_2  (VDD3V3),
		.vssio	  (VSS),
		.vssio_2  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (VDD3V3),
		.vdda1_2  (VDD3V3),
		.vdda2    (VDD3V3),
		.vssa1	  (VSS),
		.vssa1_2  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (VDD1V8),
		.vccd2	  (VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock    (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("toysram_scan.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
`default_nettype wire
