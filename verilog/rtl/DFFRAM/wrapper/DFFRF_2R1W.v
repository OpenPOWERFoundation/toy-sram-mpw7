module DFFRF_2R1W (CLK,
    VGND,
    VPWR,
    WE,
    DA,
    DB,
    DW,
    RA,
    RB,
    RW);
 input CLK;
 input VGND;
 input VPWR;
 input WE;
 output [31:0] DA;
 output [31:0] DB;
 input [31:0] DW;
 input [4:0] RA;
 input [4:0] RB;
 input [4:0] RW;
endmodule
