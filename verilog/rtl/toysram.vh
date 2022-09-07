// Global Parameters for ToySRAM Testsite

`include "defines.v"

`define RA_SIM 0
`define RA_DFFRAM 1
`define RA_TOYSRAM 2

//`define RA_SELECT `RA_SIM
`define RA_SELECT `RA_DFFRAM

`define GENMODE 0      // 0=NoDelay, 1=Delay

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
// OE!!!
`define PINS_OEB ~{38'h0000000800}

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