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

