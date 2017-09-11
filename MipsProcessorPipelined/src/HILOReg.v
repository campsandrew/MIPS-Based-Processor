`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Name: Andrew Camps
// Create Date: 10/13/2016 05:10:41 PM
// Module Name: HILOReg
//////////////////////////////////////////////////////////////////////////////////


module HILOReg(Clk, HIin, LOin, HLout, HWrite, LWrite, HLRead);
    
    input [31:0] HIin, LOin;
    input Clk, HWrite, LWrite, HLRead;
    
    output reg [63:0] HLout;
    
    reg [31:0] HI;
    reg [31:0] LO;
    
    always @(posedge Clk) begin
        if(HWrite)
            HI <= HIin;
        if(LWrite)
            LO <= LOin;
    end
    
    always @(negedge Clk) begin
        if(HLRead) begin
            HLout <= {{HI}, {LO}};
        end
    end


endmodule
