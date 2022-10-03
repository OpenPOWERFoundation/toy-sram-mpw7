module \10T_32x32_magic (
`ifdef USE_POWER_PINS
   input VDD,GND,
`endif
   input rd0_enable, rd0_a0, rd0_a1, rd0_a2,
   input rd1_enable, rd1_a0, rd1_a1, rd1_a2,
   input wr0_enable, wr0_a0, wr0_a1, wr0_a2,
   input  [31:0] wr0_dat,
   output [31:0] rd0_dat, rd1_dat
);
endmodule
