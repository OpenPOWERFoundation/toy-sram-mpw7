// Global Parameters for ToySRAM Testsite

`include "defines.v"

// Address regions
// slave (shouldn't have to, wb switch won't give cyc)
`define SLAVE_MASK  32'hF0000000
`define SLAVE_ADDR  32'h30000000
// top-level routing
`define UNIT_MASK   32'hFFFF0000
`define CTL_ADDR    32'h00000000
`define RA0_ADDR    32'h00080000
// offsets
`define CFG_MASK    32'h0000FFF0
`define BIST_OFFSET 32'h0000F000 // in RAx
`define CFG_OFFSET  32'h0000E000 // in RAx
`define CFG0_OFFSET 32'h00000000 // in CTL

// Config
`define CFG0_INIT 32'h80000001

// Gen

// comment out RA_SIM if want to generate different ports, etc. for physical
`define RA_SIM 0
`define RA_DFFRAM 1
`define RA_TOYSRAM 2
`define RA_TOYSRAM_BARE 3

//`define RA_SELECT `RA_SIM
//`define RA_SELECT `RA_DFFRAM
`define RA_SELECT `RA_TOYSRAM
`define GENMODE 0      // 0=NoDelay, 1=Delay (Physical)

// RA LCB
`define LCBSDR_CONFIGWIDTH 16
`define LCBDDR_CONFIGWIDTH 32

// GPIO

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
// Misc
`define PIN_RUNMODE 31
`define PIN_ERROR 30
`define PIN_USER_0 29
`define PIN_USER_1 28

// OE matches above!!!
`define PINS_OEB ~{38'h00_F000_0800}

/*
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
*/