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

`define CYC_HEARTBEAT 2000
`define DEBUG 0
`define SCANS 1
`define CMDS 1
`define SCAN_INIT 128'h0123456789ABCDEFFEDCBA9876543210

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
   integer i;
   reg ok, done;
   reg [31:0] cyc;
   reg pin_te, pin_scan_clk, pin_scan_in, pin_scan_out;
   reg pin_ra0_clk, pin_ra0_rst, pin_ra0_r0_en, pin_ra0_r1_en, pin_ra0_w0_en;
   reg [127:0] scan_in_val, scan_out_val, save_val;

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
      cyc = 0;
	end

   // *********************************************************************************
   // setup

	initial begin
		$dumpfile("toysram_scan.vcd");
		$dumpvars(0, toysram_scan_tb);
      $display("\n\n");

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (25) begin
			repeat (`CYC_HEARTBEAT) @(posedge clock) cyc = cyc + 1;
			$display("[%08d] ...tick...", cyc);
		end
		$display("%c[1;31m",27);
		`ifdef GL
			$display ("*ERROR* Timeout, Test Mega-Project IO Ports (GL) Failed");
		`else
			$display ("*ERROR* Timeout, Test Mega-Project IO Ports (RTL) Failed");
		`endif
		$display("%c[0m",27);
		ok <= 1'b0;
	end

   // *********************************************************************************
   // reset

	initial begin

		RSTB <= 1'b0;
		CSB  <= 1'b1;		// Force CSB high

		#2000;
		$display("[%08d] Releasing reset.", cyc);
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
      if (`DEBUG > 0) begin
			#1 $display("[%08d] I/O Update", cyc);
		   $display("   MPRJ-IO TE    %b ", mprj_io[`PIN_TE]);
		   $display("   MPRJ-IO SCAN  %b ", {mprj_io[`PIN_SCAN_CLK], mprj_io[`PIN_SCAN_IN], mprj_io[`PIN_SCAN_OUT]});
		   $display("   MPRJ-IO RA0   %b ", {mprj_io[`PIN_RA0_CLK], mprj_io[`PIN_RA0_RST], mprj_io[`PIN_RA0_R0_EN], mprj_io[`PIN_RA0_R1_EN], mprj_io[`PIN_RA0_W0_EN]});
      end
	end

   initial begin
      ok <= 1'b1;
      done <= 1'b0;
      wait(~ok | done);
      if (~ok) begin
   		$display("%c[1;31m",27);
		   $display("[%08d] You are worthless and weak!", cyc);
   		$display("%c[0m",27);
      end else begin
    		$display("%c[1;32m",27);
		   $display("[%08d] You has opulence.", cyc);
   		$display("%c[0m",27);
      end
      #1000;
      $finish;
   end

   always @(posedge mprj_io[`PIN_TE]) begin
		#1 $display("[%08d] Test Enable is active.", cyc);
   end

   always @(negedge mprj_io[`PIN_TE]) begin
		#1 $display("[%08d] Test Enable is inactive.", cyc);
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

      // wait for rv boot - any signal to check???
      wait(cyc == 32'd15000);


      // scan_reg does not reset to 0's
		$display("[%08d] Setting Test Enable.", cyc);
      pin_te <= 1'b1;
      scan_in_val <= `SCAN_INIT;
      i <= 0;
      #100;

      // --------------------------------------------------------
      // Scanning

  		repeat (`SCANS) begin

         $display("[%08d] Writing scan reg: %032X", cyc, scan_in_val);
         #100;
         $display("[%08d] Scanning in...", cyc);
         // scan_reg left shifts, loads [0]; so load 127->0 if want to see it same order
         repeat (128) begin
            pin_scan_in <= scan_in_val[127-i];  // set bit
            #100 pin_scan_clk <= 1'b1;          // blip on
            i <= i + 1;                         // next bit
            #100 pin_scan_clk <= 1'b0;          // turn off
         end
         $display("[%08d] Scan complete.", cyc);
         scan_out_val <= 128'h0;
         #100;

         // scan_do = scan_reg[127]
         $display("[%08d] Scanning out...", cyc);
         repeat (128) begin
            scan_out_val <= {scan_out_val[126:0],pin_scan_out};  // shift in bit
            #100 pin_scan_clk <= 1'b1;          // blip on
            i <= i + 1;                         // next bit
            #100 pin_scan_clk <= 1'b0;          // turn off
         end
         $display("[%08d] Scan complete.", cyc);
         $display("[%08d] Read scan reg: %032X", cyc, scan_out_val);

         if (scan_in_val !== scan_out_val) begin
            $display("%c[1;31m",27);
            $display("*ERROR* Scanout does not compare.");
            $display("%c[0m",27);
            ok <= 1'b0;
         end else begin
            $display("[%08d] Scan good.\n", cyc);
            scan_in_val <= {~scan_in_val[0], ~scan_in_val[127:1]};  // right shift negate
            i <= 0;
            #100;
         end

      end

      // --------------------------------------------------------
      // Array reads/writes

      /* scan_reg fields:

      assign io_ra0_r0_adr = scan_reg_q[127:123];
      //assign io_ra0_r0_dat = scan_reg_q[122:91]; // loaded by io_ra0_clk
      assign io_ra0_r1_adr = scan_reg_q[90:86];
      //assign io_ra0_r1_dat = scan_reg_q[85:54];  // loaded by io_ra0_clk
      assign io_ra0_w0_adr = scan_reg_q[53:49];
      assign io_ra0_w0_dat = scan_reg_q[48:17];
      */

      // reset array
		$display("[%08d] Resetting array.", cyc);
      pin_ra0_rst <= 1'b1;
      #500;
      pin_ra0_rst <= 1'b0;
      #500;

		$display("[%08d] Array cmds: R0[0], R1[1], W0[0]=08675309", cyc);
      scan_in_val <= {5'h00, 32'hFFFFFFFF, 5'h01, 32'hFFFFFFFF, 5'h00, 32'h08675309, 17'h1BABE};  // R0a, R0d, R1a, R1d, W0a, W0d, <UNUSED>
      i <= 0;
      #100;

  		repeat (`CMDS) begin

         $display("[%08d] Writing scan reg: %032X", cyc, scan_in_val);
         $display("[%08d] R0[%02X]=%08X  R1[%02X]=%08X  W0[%02C]=%08X", cyc,
                   scan_in_val[127:123], scan_in_val[122:91], scan_in_val[90:86], scan_in_val[85:54], scan_in_val[53:49], scan_in_val[48:17]);
         #100;
         $display("[%08d] Scanning in...", cyc);
         // scan_reg left shifts, loads [0]; so load 127->0 if want to see it same order
         repeat (128) begin
            pin_scan_in <= scan_in_val[127-i];  // set bit
            #100 pin_scan_clk <= 1'b1;          // blip on
            i <= i + 1;                         // next bit
            #100 pin_scan_clk <= 1'b0;          // turn off
         end
         $display("[%08d] Scan complete.", cyc);
         $display("[%08d] R0_EN=1, R1_EN=1, W0_EN=1", cyc);
         pin_ra0_r0_en <= 1'b1;
         pin_ra0_r1_en <= 1'b1;
         pin_ra0_w0_en <= 1'b1;
         #100;

         $display("[%08d] Clocking array (set up input regs)...", cyc);
         pin_ra0_clk <= 1'b1;
         #100;
         pin_ra0_clk <= 1'b0;
         #100;

         $display("[%08d] Clocking array (clock array)...", cyc);
         pin_ra0_clk <= 1'b1;
         #100;
         pin_ra0_clk <= 1'b0;
         #100;

         $display("[%08d] R0_EN=1, R1_EN=1, W0_EN=0", cyc);
         pin_ra0_r0_en <= 1'b1;
         pin_ra0_r1_en <= 1'b1;
         pin_ra0_w0_en <= 1'b0;
         #100;

         // 'destructive' scan doesn't reload reg
         scan_out_val <= 128'h0;
         i <= 0;
         #100;
         $display("[%08d] Scanning out...", cyc);
         repeat (128) begin
            scan_out_val <= {scan_out_val[126:0], pin_scan_out};  // shift in bit
            #100 pin_scan_clk <= 1'b1;          // blip on
            i <= i + 1;                         // next bit
            #100 pin_scan_clk <= 1'b0;          // turn off
         end
         $display("[%08d] Scan complete.", cyc);
         $display("[%08d] Read scan reg: %032X", cyc, scan_out_val);
         $display("[%08d] R0[%02X]=%08X  R1[%02X]=%08X W0[%02C]=%08X", cyc,
                   scan_out_val[127:123], scan_out_val[122:91], scan_out_val[90:86], scan_out_val[85:54], scan_out_val[53:49], scan_out_val[48:17]);

         scan_in_val <= scan_out_val;
         i <= 0;
         #100;
         $display("[%08d] Scanning in (restore)...", cyc);
         repeat (128) begin
            pin_scan_in <= scan_in_val[127-i];  // set bit
            #100 pin_scan_clk <= 1'b1;          // blip on
            i <= i + 1;                         // next bit
            #100 pin_scan_clk <= 1'b0;          // turn off
         end
         $display("[%08d] Scan complete.", cyc);

         $display("[%08d] Clocking array...", cyc);
         pin_ra0_clk <= 1'b1;
         #100;
         pin_ra0_clk <= 1'b0;
         #100;

         // 'nondestructive' scan reloads while unloading
         scan_out_val <= 128'h0;
         i <= 0;
         #100;
         $display("[%08d] Scanning out nondestructively...", cyc);
         repeat (128) begin
            pin_scan_in <= pin_scan_out;        // restore bit
            scan_out_val <= {scan_out_val[126:0],pin_scan_out};  // shift in bit
            #100 pin_scan_clk <= 1'b1;          // blip on
            i <= i + 1;                         // next bit
            #100 pin_scan_clk <= 1'b0;          // turn off
         end
         $display("[%08d] Scan complete.", cyc);
         $display("[%08d] Read scan reg: %032X", cyc, scan_out_val);
         $display("[%08d] R0[%02X]=%08X  R1[%02X]=%08X W0[%02C]=%08X", cyc,
                   scan_out_val[127:123], scan_out_val[122:91], scan_out_val[90:86], scan_out_val[85:54], scan_out_val[53:49], scan_out_val[48:17]);

         save_val <= scan_out_val;
         scan_out_val <= 128'h0;
         i <= 0;
         #100;
         $display("[%08d] Scanning out...", cyc);
         repeat (128) begin
            scan_out_val <= {scan_out_val[126:0],pin_scan_out};  // shift in bit
            #100 pin_scan_clk <= 1'b1;          // blip on
            i <= i + 1;                         // next bit
            #100 pin_scan_clk <= 1'b0;          // turn off
         end
         $display("[%08d] Scan complete.", cyc);
         $display("[%08d] Read scan reg: %032X", cyc, scan_out_val);
         $display("[%08d] R0[%02X]=%08X  R1[%02X]=%08X W0[%02C]=%08X", cyc,
                   scan_out_val[127:123], scan_out_val[122:91], scan_out_val[90:86], scan_out_val[85:54], scan_out_val[53:49], scan_out_val[48:17]);

         if (scan_out_val !== save_val) begin
            $display("%c[1;31m",27);
            $display("*ERROR* Scanout does not compare.");
            $display("%c[0m",27);
            ok <= 1'b0;
         end else begin
            $display("[%08d] Nondestructive scan good.\n", cyc);
            scan_in_val <= {~scan_in_val[0], ~scan_in_val[127:1]};  // right shift negate
            i <= 0;
            #100;
         end

         scan_in_val <= scan_out_val;
         i <= 0;
         #100;
         $display("[%08d] Scanning in (restore)...", cyc);
         repeat (128) begin
            pin_scan_in <= scan_in_val[127-i];  // set bit
            #100 pin_scan_clk <= 1'b1;          // blip on
            i <= i + 1;                         // next bit
            #100 pin_scan_clk <= 1'b0;          // turn off
         end
         $display("[%08d] Scan complete.", cyc);

         $display("[%08d] Clocking array...", cyc);
         pin_ra0_clk <= 1'b1;
         #100;
         pin_ra0_clk <= 1'b0;
         #100;

         scan_out_val <= 128'h0;
         i <= 0;
         #100;
         $display("[%08d] Scanning out nondestructively...", cyc);
         repeat (128) begin
            pin_scan_in <= pin_scan_out;        // restore bit
            scan_out_val <= {scan_out_val[126:0],pin_scan_out};  // shift in bit
            #100 pin_scan_clk <= 1'b1;          // blip on
            i <= i + 1;                         // next bit
            #100 pin_scan_clk <= 1'b0;          // turn off
         end
         $display("[%08d] Scan complete.", cyc);
         $display("[%08d] Read scan reg: %032X", cyc, scan_out_val);
         $display("[%08d] R0[%02X]=%08X  R1[%02X]=%08X W0[%02C]=%08X", cyc,
                   scan_out_val[127:123], scan_out_val[122:91], scan_out_val[90:86], scan_out_val[85:54], scan_out_val[53:49], scan_out_val[48:17]);

      end

      #1000;
      pin_te <= 1'b0;

      #1000;
      done <= 1'b1;

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
