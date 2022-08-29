module RAM32 (CLK,
    EN0,
    VGND,
    VPWR,
    A0,
    Di0,
    Do0,
    WE0);
 input CLK;
 input EN0;
 input VGND;
 input VPWR;
 input [4:0] A0;
 input [31:0] Di0;
 output [31:0] Do0;
 input [3:0] WE0;
endmodule
