`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Name: Andrew Camps
// Create Date: 10/28/2016 01:27:11 AM
// Module Name: PipeLineRegister
//////////////////////////////////////////////////////////////////////////////////


module PipeLineRegister(Clk, in, out, Write);

    parameter N = 32;

    input Clk, Write;
    input [N-1:0] in;
    output reg [N-1:0] out;

    reg [N-1:0] register;
    
    always @(posedge Clk) begin
        if(Write)
            register <= in;
    end
    
    always @(*) begin
        out <= register; 
    end
    
endmodule
