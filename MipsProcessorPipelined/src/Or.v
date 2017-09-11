`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Name: Andrew Camps
// Create Date: 11/15/2016 02:37:32 AM
// Module Name: Or
//////////////////////////////////////////////////////////////////////////////////


module Or(A, B, Out);

    input A, B;
    output reg Out;
    
    always @(*) begin
        Out <= A | B;
    end
    
endmodule
