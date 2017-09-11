`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Name: Andrew Camps
// Create Date: 10/12/2016 01:12:11 AM
// Module Name: And
//////////////////////////////////////////////////////////////////////////////////


module And(A, B, Out);

    input A, B;
    output reg Out;
    
    always @(*) begin
        Out <= A & B;
    end
    
endmodule
