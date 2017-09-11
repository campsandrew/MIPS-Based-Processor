`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Name: Andrew Camps
// Create Date: 10/10/2016 03:56:21 PM
// Module Name: Adder32Bit
//////////////////////////////////////////////////////////////////////////////////


module Adder32Bit(A, B, Out);

    input [31:0] A;
    input [31:0] B;
    
    output reg [31:0] Out;
    
    always @(*) begin
        Out <= A + B;
    
    end
    
    
endmodule
